require('lsp')

-- 非アクティブウィンドウを暗くしてアクティブウィンドウを目立たせる.
require('tint').setup()

-- 検索時にマッチ位置の近くに「現在何番目/全何件」のレンズを表示する.
require('hlslens').setup({
  -- カーソルに最も近いマッチにのみレンズを表示する.
  nearest_only = true,
})

local kopts = { noremap = true, silent = true }
vim.keymap.set('n', 'n',
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts)
vim.keymap.set('n', 'N',
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
  kopts)
vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
-- ハイライトとレンズをまとめて消す.
vim.keymap.set('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

-- カーソル行の commit メッセージをポップアップ表示する.
-- ポップアップ内 o/O でその行の履歴をさらに遡る/戻る.
vim.g.git_messenger_no_default_mappings = true
-- git-messenger はカレントバッファのファイルがあるディレクトリで git を起動する.
-- fugitive:// など URI スキームのバッファ（リビジョン閲覧）や非ファイルバッファでは
-- 作業ディレクトリが不正になり E475(expected valid directory) で落ちる.
-- fugitive のリビジョンバッファは buftype が空なので、実在ファイルかどうかで判定する.
vim.keymap.set('n', '<Space>gm', function()
  local file = vim.fn.expand('%:p')
  if vim.bo.buftype ~= '' or file == '' or vim.fn.filereadable(file) == 0 then
    vim.notify('git-messenger: 実在するファイルバッファで実行してください', vim.log.levels.WARN)
    return
  end
  vim.cmd('GitMessenger')
end, { silent = true })

-- 変更全体の差分レビューとマージコンフリクト解決.
-- マージ中の :DiffviewOpen は自動で 3-way 解決画面になる.
-- ファイルアイコンは nvim-web-devicons を使用（.vimrc.dein で追加。表示には Nerd Font が必要）.
require('diffview').setup({ use_icons = true })

-- diffview のキーマップ（<Space>d = diffview）.
vim.keymap.set('n', '<Space>do', '<Cmd>DiffviewOpen<CR>', { silent = true, desc = 'Diffview: 差分を開く' })
vim.keymap.set('n', '<Space>dc', '<Cmd>DiffviewClose<CR>', { silent = true, desc = 'Diffview: 閉じる' })
vim.keymap.set('n', '<Space>dh', '<Cmd>DiffviewFileHistory %<CR>', { silent = true, desc = 'Diffview: 現在ファイルの履歴' })
vim.keymap.set('n', '<Space>dH', '<Cmd>DiffviewFileHistory<CR>', { silent = true, desc = 'Diffview: リポジトリ全体の履歴' })

-- iOS/macOS 開発（xcodebuild.nvim）。ファイル名は module 名 'xcodebuild' と衝突させない.
require('xcodebuild_config')
