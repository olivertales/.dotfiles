return {
  -- root_dir = function(buf, on_dir)
  --   local found_files = vim.fs.find(function(name, path)
  --     return name:match('.*%.csproj$') or name:match('.*%.sln$') or name:match('.git')
  --   end, { upward = true, path = vim.fn.getcwd(), type = 'file' })
  --   local found_dir = vim.fs.dirname(found_files[1])
  --   on_dir(found_dir)
  -- end,
  cmd = {
    'dotnet',
    '/usr/lib/roslyn/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll',
    '--logLevel=Information',
    '--stdio',
    '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path())
  },
  cmd_env = {
    Configuration = "Debug"
  },
  root_markers = { '.git' },
  filetypes = { 'cs' },
  on_attach = function()
    vim.cmd('compiler dotnet')
  end,
  capabilities = {
    textDocument = {
      diagnostic = {
        dynamicRegistration = true
      }
    }
  },
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      csharp_enable_inlay_hints_for_indexer_parameters = true,
      csharp_enable_inlay_hints_for_literal_parameters = true,
      csharp_enable_inlay_hints_for_object_creation_parameters = true,
      csharp_enable_inlay_hints_for_other_parameters = true,
      csharp_enable_inlay_hints_for_parameters = true,
    },
    ['csharp|completion'] = {
      dotnet_provide_regex_completions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
    ['csharp|formatting'] = {
      dotnet_organize_imports_on_format = true
    }
  }
}
