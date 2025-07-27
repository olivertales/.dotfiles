return {
  'mfussenegger/nvim-dap',
  config = function()
    local netcoredbg_adapter = {
      type = 'executable',
      command = vim.fn.stdpath('data') .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe',
      args = { '--interpreter=vscode' },
      options = { cwd = vim.fn.getcwd(), detached = false }
    }

    local dap = require('dap')
    dap.adapters.coreclr = netcoredbg_adapter
    dap.adapters.netcoredbg_adapter = netcoredbg_adapter

    local dap_dotnet_utils = require('config.nvim-dap-dotnet')
    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'Launch - netcoredbg_adapter',
        request = 'launch',
        program = function()
          return dap_dotnet_utils.build_dll_path()
        end
      }
    }
  end
}
