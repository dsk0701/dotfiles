-- Claude Code 連携（coder/claudecode.nvim）.
-- VS Code 拡張と同じ IDE 連携プロトコル（WebSocket）で nvim と Claude Code CLI を直結する.
-- 主目的: 編集中の選択範囲を @File#L.. の参照付きでそのまま Claude に送り、
-- 変更提案を nvim のネイティブ diff で承認/却下する.
-- ファイル名は module 名 'claudecode' と衝突させない（前回の名前衝突の知見）.
local ok, claudecode = pcall(require, 'claudecode')
if not ok then
  return
end

claudecode.setup({
  -- snacks.nvim を依存に入れていないため、組み込みの native ターミナルを使う.
  terminal = {
    provider = 'native',
    -- Claude ペインを左側に開く（既定は 'right'）.
    split_side = 'left',
  },
})

-- UTF-8 安全な charwise 選択抽出のパッチ.
-- 本家 selection.lua は `'>`/カーソルの byte 列（= 末尾文字の「先頭バイト」）を
-- string.sub の終端にそのまま渡すため、日本語など複数バイト文字の末尾が
-- 途中で千切れて不正な UTF-8 になる。これを WebSocket テキストフレームで送ると
-- 受信側（Claude CLI）が不正フレームとして切断し、サーバ側に ECONNRESET が出る。
-- ここでは終端列を文字境界まで伸ばして再抽出し、両経路（送信時の marks 版／
-- 選択中の自動通知の live 版）の charwise テキストだけを差し替える。
-- M テーブルのメンバを包むだけなので本体ソース行に依存せず dein update にも耐える。
local sel_ok, sel = pcall(require, 'claudecode.selection')
if sel_ok then
  -- 末尾の複数バイト文字を文字境界まで含めて charwise テキストを取り直す.
  local function extract_charwise_safe(bufnr, sc, ec)
    local lines = vim.api.nvim_buf_get_lines(bufnr, sc.lnum - 1, ec.lnum, false)
    if #lines == 0 then
      return nil
    end
    local last = lines[#lines]
    local end_col = ec.col
    -- end_col は末尾文字の先頭バイト位置。その文字の最終バイトまで伸ばす.
    -- ($ や MAXCOL で行末超過しているときは伸ばさず string.sub に丸めさせる).
    if end_col >= 1 and end_col <= #last then
      end_col = end_col + vim.str_utf_end(last, end_col)
    end
    if #lines == 1 then
      return string.sub(last, sc.col, end_col)
    end
    local parts = { string.sub(lines[1], sc.col) }
    for i = 2, #lines - 1 do
      parts[#parts + 1] = lines[i]
    end
    parts[#parts + 1] = string.sub(last, 1, end_col)
    return table.concat(parts, '\n')
  end

  -- 取り直したテキストで result.text と isEmpty を上書きする（LSP 位置はそのまま）.
  local function apply_fixed_text(result, bufnr, sc, ec)
    local fixed = extract_charwise_safe(bufnr, sc, ec)
    if fixed then
      result.text = fixed
      if result.selection then
        result.selection.isEmpty = (#fixed == 0)
      end
    end
    return result
  end

  -- 経路1: <Space>cs での送信（'<` `'>` マーク使用）.
  local orig_marks = sel.get_visual_selection_from_marks
  sel.get_visual_selection_from_marks = function(...)
    local result = orig_marks(...)
    if not result or vim.fn.visualmode() ~= 'v' then -- charwise のみ補正.
      return result
    end
    local sp, ep = vim.fn.getpos("'<"), vim.fn.getpos("'>")
    if sp[2] == 0 or ep[2] == 0 then
      return result
    end
    return apply_fixed_text(
      result,
      0,
      { lnum = sp[2], col = sp[3] },
      { lnum = ep[2], col = ep[3] }
    )
  end

  -- 経路2: Visual 選択中の selection_changed 自動通知（getpos("v") + カーソル使用）.
  local orig_live = sel.get_visual_selection
  sel.get_visual_selection = function(...)
    local result = orig_live(...)
    if not result then
      return result
    end
    -- アクティブな charwise visual のときだけ補正（v）.
    if (vim.api.nvim_get_mode().mode or ''):sub(1, 1) ~= 'v' then
      return result
    end
    local anchor = vim.fn.getpos('v')
    local cur = vim.api.nvim_win_get_cursor(0)
    local p1 = { lnum = anchor[2], col = anchor[3] }
    local p2 = { lnum = cur[1], col = cur[2] + 1 }
    local sc, ec
    if p1.lnum < p2.lnum or (p1.lnum == p2.lnum and p1.col <= p2.col) then
      sc, ec = p1, p2
    else
      sc, ec = p2, p1
    end
    return apply_fixed_text(result, 0, sc, ec)
  end
end

local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end

-- <Space>c = Claude Code（<Space>ca は LSP code_action なので衝突しない）.
nmap('<Space>cc', '<cmd>ClaudeCode<cr>', 'Claude: ターミナル開閉')
nmap('<Space>cf', '<cmd>ClaudeCodeFocus<cr>', 'Claude: フォーカス')
-- 選択範囲を Claude に送る（参照 @File#L.. が自動付与される）.
vim.keymap.set('v', '<Space>cs', '<cmd>ClaudeCodeSend<cr>', { silent = true, desc = 'Claude: 選択範囲を送る' })
-- 変更提案の diff を承認/却下する.
nmap('<Space>cy', '<cmd>ClaudeCodeDiffAccept<cr>', 'Claude: diff を承認')
nmap('<Space>cn', '<cmd>ClaudeCodeDiffDeny<cr>', 'Claude: diff を却下')

-- Claude ターミナルペインはノーマルモード用マップが発火しない（全キーが TUI に渡る）.
-- ターミナルモードで <C-o> を「ノーマルへ抜けてウィンドウコマンド」のプレフィックスにし、
-- <C-o>w / <C-o>h などで他ペインへ移動できるようにする.
-- <C-w> は Claude 入力欄の単語削除に温存するため使わない（Claude は Ctrl-O を使わない）.
vim.keymap.set('t', '<C-o>', [[<C-\><C-n><C-w>]], { silent = true, desc = 'Terminal: ウィンドウコマンドへ抜ける' })
