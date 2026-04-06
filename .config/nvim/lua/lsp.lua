local ok, mason = pcall(require, 'mason')
if not ok then
  return
end
mason.setup()
require('mason-lspconfig').setup()

vim.lsp.enable({
  'clangd',
  'denols',
  'intelephense',
  'kotlin_language_server',
  'sourcekit',
})
