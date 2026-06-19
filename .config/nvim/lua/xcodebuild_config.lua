-- xcodebuild.nvim: Neovim から iOS/macOS アプリをビルド・実行・テスト・デバッグする.
-- ピッカー UI は telescope を使用（普段のファイル検索等は ddu のまま）.
local ok, xcodebuild = pcall(require, 'xcodebuild')
if not ok then
  return
end

xcodebuild.setup({})

local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end

-- build/run/test/select 等は Picker（全アクション一覧）から呼ぶ.
map('<Space>X', '<cmd>XcodebuildPicker<cr>', 'Xcodebuild: アクション一覧')
map('<Space>xC', '<cmd>XcodebuildCleanBuild<cr>', 'Xcodebuild: クリーン（ビルドフォルダ）')
map('<Space>xD', '<cmd>XcodebuildCleanDerivedData<cr>', 'Xcodebuild: Derived Data 削除')

-- デバッグ（nvim-dap）。Xcode 16+ は lldb-dap を使うため codelldb 不要.
local dap_ok, dap = pcall(require, 'dap')
if dap_ok then
  require('xcodebuild.integrations.dap').setup()

  -- texthl は色名指定（colorscheme が後で適用されても解決される）.
  vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', numhl = '' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticError', numhl = '' })
  vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DiagnosticInfo', numhl = '' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '✗', texthl = 'DiagnosticError', numhl = '' })
  vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticWarn', linehl = 'Visual', numhl = '' })

  local dapui_ok, dapui = pcall(require, 'dapui')
  if dapui_ok then
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
  end

  -- debug は <Space>x 配下に集約（<Space>d は diffview に割り当て）.
  local xcodedap = require('xcodebuild.integrations.dap')
  map('<Space>xr', function() xcodedap.build_and_debug() end, 'Xcodebuild: ビルド&デバッグ')
  map('<Space>xd', function() xcodedap.debug_without_build() end, 'Xcodebuild: デバッグ（ビルドなし）')
  map('<Space>xt', function() xcodedap.debug_tests() end, 'Xcodebuild: テストをデバッグ')
  map('<Space>xs', function() xcodedap.terminate_session() end, 'Xcodebuild: デバッグ終了')
  map('<Space>xc', function() dap.continue() end, 'DAP: 続行')
  map('<Space>b', function() dap.toggle_breakpoint() end, 'DAP: ブレークポイント ON/OFF')
  map('<Space>B', function() dap.list_breakpoints(true) end, 'DAP: ブレークポイント一覧(quickfix)')
  map('<Space>xB', function() dap.clear_breakpoints() end, 'DAP: 全ブレークポイント解除')
end
