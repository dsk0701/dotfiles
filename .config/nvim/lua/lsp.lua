require('mason').setup()
require('mason-lspconfig').setup()

require('lspconfig').clangd.setup({})
require('lspconfig').denols.setup({})
require('lspconfig').intelephense.setup({})
require('lspconfig').kotlin_language_server.setup({})
require('lspconfig').sourcekit.setup({})
