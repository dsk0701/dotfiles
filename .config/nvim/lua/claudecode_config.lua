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
