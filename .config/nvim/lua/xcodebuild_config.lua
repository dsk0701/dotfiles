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

map('<Space>X', '<cmd>XcodebuildPicker<cr>', 'Xcodebuild: アクション一覧')
map('<Space>xb', '<cmd>XcodebuildBuild<cr>', 'Xcodebuild: ビルド')
map('<Space>xr', '<cmd>XcodebuildBuildRun<cr>', 'Xcodebuild: ビルド&実行')
map('<Space>xR', '<cmd>XcodebuildRun<cr>', 'Xcodebuild: 実行（ビルドなし）')
map('<Space>xt', '<cmd>XcodebuildTest<cr>', 'Xcodebuild: テスト')
map('<Space>xT', '<cmd>XcodebuildTestClass<cr>', 'Xcodebuild: テスト（クラス）')
map('<Space>x.', '<cmd>XcodebuildTestSelected<cr>', 'Xcodebuild: テスト（選択）')
map('<Space>xe', '<cmd>XcodebuildTestExplorerToggle<cr>', 'Xcodebuild: テストエクスプローラ')
map('<Space>xl', '<cmd>XcodebuildToggleLogs<cr>', 'Xcodebuild: ログ表示トグル')
map('<Space>xc', '<cmd>XcodebuildToggleCodeCoverage<cr>', 'Xcodebuild: カバレッジ表示')
map('<Space>xd', '<cmd>XcodebuildSelectDevice<cr>', 'Xcodebuild: デバイス選択')
map('<Space>xs', '<cmd>XcodebuildSelectScheme<cr>', 'Xcodebuild: スキーム選択')
map('<Space>xp', '<cmd>XcodebuildSelectTestPlan<cr>', 'Xcodebuild: テストプラン選択')
map('<Space>xC', '<cmd>XcodebuildClean<cr>', 'Xcodebuild: クリーン')

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

  local xcodedap = require('xcodebuild.integrations.dap')
  map('<Space>dd', function() xcodedap.build_and_debug() end, 'Xcodebuild: ビルド&デバッグ')
  map('<Space>dr', function() xcodedap.debug_without_build() end, 'Xcodebuild: デバッグ（ビルドなし）')
  map('<Space>dt', function() xcodedap.debug_tests() end, 'Xcodebuild: テストをデバッグ')
  map('<Space>dx', function() xcodedap.terminate_session() end, 'Xcodebuild: デバッグ終了')
  map('<Space>dc', function() dap.continue() end, 'DAP: 続行')
  map('<Space>b', function() dap.toggle_breakpoint() end, 'DAP: ブレークポイント')
  map('<Space>B', function() dap.list_breakpoints(true) end, 'DAP: ブレークポイント一覧(quickfix)')
  map('<Space>dB', function() dap.clear_breakpoints() end, 'DAP: 全ブレークポイント解除')
end
