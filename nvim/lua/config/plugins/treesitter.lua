return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context'
  },
  config = function()
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = { "c", 'c_sharp', "lua", 'html', 'typescript', 'css', 'javascript', 'tsx', "vim", "vimdoc", "query", "markdown", "markdown_inline" },
      auto_install = false,
      sync_install = true,
      ignore_install = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
        }
      }
    }
    require 'nvim-treesitter.install'.compilers = { 'gcc', 'zig' }

    require'treesitter-context'.setup { enable = true }

  end
}
