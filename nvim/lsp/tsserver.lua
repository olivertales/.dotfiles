return {
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = vim.fs.dirname(
    vim.fs.find({
      'tsconfig.json',
      'jsconfig.json',
      'package.json',
      '.git'
    }, { upward = true })[1]),
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  on_attach = function()
    vim.cmd('compiler tsc')
  end,
  capabilities = {
    initializationOptions = {
      preferences = {
        importMOduleSpecifierPreference = 'project-relative',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayParameterNameHints = 'literals'
      }
    }
  }
}
