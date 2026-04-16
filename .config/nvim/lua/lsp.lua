local ok, mason = pcall(require, 'mason')
if not ok then
  return
end
mason.setup()
require('mason-lspconfig').setup()

vim.lsp.config('*', {
  capabilities = require('ddc_source_lsp').make_client_capabilities(),
})

vim.lsp.config('sourcekit', {
  cmd = { 'xcrun', 'sourcekit-lsp' },
})

vim.lsp.enable({
  'clangd',
  'denols',
  'intelephense',
  'kotlin_language_server',
  'sourcekit',
})
