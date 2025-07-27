return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-ui-select.nvim',
    'jvgrootveld/telescope-zoxide',
    'debugloop/telescope-undo.nvim'
  },
  config = function()
    -- Telescope rounded border hack
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TelescopeFindPre',
      callback = function()
        vim.opt_local.winborder = 'none'
        vim.api.nvim_create_autocmd('WinLeave', {
          once = true,
          callback = function ()
            vim.opt_local.winborder = 'rounded'
          end
        })
      end
    })
    require('telescope').setup {
      defaults = require('telescope.themes').get_ivy {
        layout_config = {
          height = 0.6
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_cursor {
            layout_config = {
              height = 0.4
            }
          },
        },
        undo = {
          side_by_side = true,
          mappings = {
            i = {
              ['<CR>'] = require('telescope-undo.actions').restore
            },
            n = {
              ['<CR>'] = require('telescope-undo.actions').restore
            }
          }
        }
      }
    }

    require('telescope').load_extension('ui-select')
    require('telescope').load_extension('zoxide')
    require('telescope').load_extension('undo')

    local set = vim.keymap.set
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    set('n', '<space>ff', builtin.find_files, { desc = 'Telescope Find Files' })
    set('n', '<space>fh', builtin.help_tags , { desc = 'Telescope Find Help' })
    set('n', '<space>fg', builtin.live_grep, { desc = 'Telescope Find Grep' })
    set('n', '<space>fn', function()
      builtin.find_files {
        cwd = vim.fn.stdpath('config')
      }
    end, { desc = 'Telescope Find Files Neovim' })
    set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope Find Keymaps' })
    set('n', '<leader>fo', builtin.oldfiles, { desc = 'Telescope Find Old Files' })

    set('n', '<leader>fz', telescope.extensions.zoxide.list, { desc = 'Telescope Find Zoxide' })
    set('n', '<leader>fu', telescope.extensions.undo.undo, { desc = 'Telescope Undo Tree' })

    set('n', '<leader>lD', builtin.lsp_type_definitions, { desc = 'Telescope LSP Type Definition' })
    set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'Telescope LSP Document Symbols' })
    set('n', '<leader>ld', builtin.lsp_definitions, { desc = 'Telescope LSP Definitions' })
    set('n', '<leader>li', builtin.lsp_implementations, { desc = 'Telescope LSP Implementations' })
    set('n', '<leader>lr', builtin.lsp_references, { desc = 'Telescope LSP References' })
  end
}
