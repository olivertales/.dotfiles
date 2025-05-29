--I hope you enjoy your Neovim journey,
-- TJ

vim.g.mapleader = ' '

vim.g.maplocalleader = ' '

--Powershell setup

local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
}

for option, value in pairs(powershell_options) do
    vim.opt[option] = value
end

vim.o.termguicolors = true

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "rust_analyzer" },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    --Omnisharp alternative
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
    },

    --Db connection in neovim
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            {
                'tpope/vim-dadbod',
                lazy = true
            },
            {
                'kristijanhusak/vim-dadbod-completion',
                ft = { 'sql', 'mysql', 'plsql' },
                lazy = true
            },
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
        end
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            local bkp_data = require('bookeeping.data')
            local bkp_utils = require('bookeeping.utils')
            local note = bkp_data.load_notes()
            local note_text = ""
            if note then
                local text_array = bkp_utils.get_note_text(note)
                for idx = #text_array - 1, #text_array - 12, -1 do
                    note_text = text_array[idx] .. '\n' .. note_text
                end
            else
                note_text = "No notes available"
            end
            require('snacks').setup({
                bigfile = { enabled = true },
                bufdelete = { enabled = true },
                dashboard = {
                    enabled = true,
                    sections = {
                        { section = "header" },
                        {
                            pane = 2,
                            section = "terminal",
                            height = 5,
                            padding = 1,
                        },
                        { section = "keys", gap = 1, padding = 1 },
                        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                        {
                            pane = 2,
                            icon = " ",
                            title = "Git Status",
                            section = "terminal",
                            enabled = function()
                                return Snacks.git.get_root() ~= nil
                            end,
                            cmd = "git status --short --branch --renames",
                            height = 5,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        },
                        {
                            title = "Notes",
                            icon = "🕮",
                            padding = 1,
                            pane = 2
                        },
                        {
                            pane = 2,
                            indent = 3,
                            text = note_text
                        },
                        { section = "startup" },
                    }
                },
                dim = { enabled = true },
                quickfile = { enabled = true }
            })
        end,
    },

    -- Nice inline errors for lsp
    {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function()
            require('lsp_lines').setup()
        end
    },

    {
        'stevearc/dressing.nvim',
        opts = {},
    },

    --File navigator
    {
        'stevearc/oil.nvim',
        opts = {
            columns = {
                'icon',
                'size'
            },
            delete_to_trash = true,
            constrain_cursor = 'editable',
            view_options = {
                show_hidden = true,
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },

    --Color visualizer
    'brenoprata10/nvim-highlight-colors',

    --Autopair plugin
    {
        'windwp/nvim-autopairs',
        lazy = true,
        opts = {}
    },
    --Auto close html tag
    {
        'windwp/nvim-ts-autotag',
        lazy = true
    },

    {
        "ckipp01/stylua-nvim"
    },

    --GitHub Pull Request UI
    {
        'ldelossa/gh.nvim',
        lazy = true,
        dependencies = 'ldelossa/litee.nvim'
    },

    --Tabout
    {
        'abecodes/tabout.nvim',
        lazy = false,
        opts = {
            tabkey = '<Tab>',             -- key to trigger tabout, set to an empty string to disable
            backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
            act_as_tab = true,            -- shift content if tab out is not possible
            act_as_shift_tab = false,     -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
            default_tab = '<C-t>',        -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
            default_shift_tab = '<C-d>',  -- reverse shift default action,
            enable_backwards = false,     -- well ...
            completion = false,           -- if the tabkey is used in a completion pum
            ignore_beginning = false,
            tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = '`', close = '`' },
                { open = '(', close = ')' },
                { open = '[', close = ']' },
                { open = '{', close = '}' }
            },
            exclude = {} -- tabout will ignore these filetypes
        },
        dependencies = { -- These are optional
            "nvim-treesitter/nvim-treesitter",
            "L3MON4D3/LuaSnip",
            "hrsh7th/nvim-cmp"
        },
        opt = true,              -- Set this to true if the plugin is optional
        event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
        priority = 1000,
    },

    -- LuaSnip
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = '2.*',
        build = 'make install_jsregexp',
        keys = function()
            return {}
        end
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = "hrsh7th/cmp-nvim-lsp"
    },

    --CMP snippets completion
    { 'saadparwaiz1/cmp_luasnip' },

    --Autocompletion parameter marking
    { 'ray-x/lsp_signature.nvim' },

    --Lsp autocomplete icons
    { 'onsails/lspkind.nvim' },

    --Undo tree
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        opts = {
            float_diff = false,
            window = {
                winblend = 10
            }
        },
        keys = {
            { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
        },
    },

    {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup {
                init = function()
                    -- Require providers
                    require("hover.providers.lsp")
                    require('hover.providers.gh')
                    require('hover.providers.gh_user')
                    -- require('hover.providers.jira')
                    require('hover.providers.dap')
                    require('hover.providers.fold_preview')
                    require('hover.providers.diagnostic')
                    require('hover.providers.man')
                    -- require('hover.providers.dictionary')
                    require('hover.providers.highlight')
                end,
                preview_opts = {
                    border = 'rounded'
                },
                preview_window = false,
                title = true,
                mouse_providers = {
                    'LSP'
                },
                mouse_delay = 1000
            }
            vim.keymap.set("n", "K", function()
                local api = vim.api
                local hover_win = vim.b.hover_preview
                if hover_win and api.nvim_win_is_valid(hover_win) then
                    api.nvim_set_current_win(hover_win)
                else
                    require("hover").hover()
                end
            end, { desc = "hover.nvim" })
            vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
            vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end,
                { desc = "hover.nvim (previous source)" })
            vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end,
                { desc = "hover.nvim (next source)" })

            -- Mouse support
            vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
            vim.o.mousemoveevent = true
        end,

    },

    --Snippets collection plugin
    { 'rafamadriz/friendly-snippets' },

    -- Useful plugin to show you pending keybinds.
    {
        'folke/which-key.nvim',
        opts = {}
    },

    {
        -- Adds git releated signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = ' +' },
                change = { text = ' ~' },
                delete = { text = ' _' },
                topdelete = { text = ' ‾' },
                changedelete = { text = ' ~' },
            },
        },
    },

    --Theme
    {
        "craftzdog/solarized-osaka.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            terminal_colors = true,
            transparent = true,
            dim_inactive = false,
            lualine_bold = true,
            hide_inactive_statusline = true,
            styles = {
                floats = 'transparent',
                sidebars = 'transparent'
            },
            sidebars = { 'qf', 'vista_kind', 'terminal', 'lazy', 'dap', 'oil', 'help' },
            on_colors = function(colors)
                local hslutil = require("solarized-osaka.hsl")
                local hsl = hslutil.hslToHex
                colors.bg = hsl(258, 35, 4)
            end,
            on_highlights = function(highlights, colors)
                highlights['@variable']              = { fg = colors.violet100 }
                highlights['@variable.builtin']      = '@variable'
                highlights['@keyword']               = { fg = colors.magenta }
                highlights['@type.builtin']          = '@keyword'
                highlights['@constant.builtin']      = '@keyword'
                highlights['@keyword.operator']      = '@keyword'
                highlights['@keyword.exception']     = '@keyword'
                highlights['@keyword.conditional']   = { fg = colors.violet700 }
                highlights['@boolean']               = '@keyword.conditional'
                highlights['@operator']              = { fg = colors.base3 }
                highlights['@punctuation.delimiter'] = '@operator'
                highlights['@comment']               = { fg = colors.yellow300 }
            end,
        },
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true },
        opts = {
            options = {
                component_separators = '|',
                section_separators = { left = '', right = '' },
                globalstatus = true,
                theme = 'palenight',
            },
            sections = {
                lualine_a = { 'buffers' },
                lualine_b = { 'branch', 'diff' },
                lualine_c = { 'diagnostics' },
                lualine_x = { "require('dap').status()", { 'filetype', fmt = string.upper }, 'fileformat' },
                lualine_y = { { 'progress', fmt = string.upper }, 'location' },
                lualine_z = { "os.date('%X')" },
            },
        },
    },
    --Debug plugin
    {
        'mfussenegger/nvim-dap',
        lazy = true
    },
    --Debug UI plugin
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
            layouts = { {
                elements = { {
                    id = "scopes",
                    size = 0.25
                }, {
                    id = "breakpoints",
                    size = 0.25
                }, {
                    id = "stacks",
                    size = 0.25
                }, {
                    id = "watches",
                    size = 0.25
                } },
                position = "left",
                size = 40
            }, {
                elements = { {
                    id = "repl",
                    size = 1
                }, },
                position = "bottom",
                size = 10
            } },
        }
    },

    --Asynchronous IO Neovim
    { "nvim-neotest/nvim-nio" },

    --Javascript debugging dependencies
    -- {
    --     'microsoft/vscode-js-debug',
    --     lazy = true,
    --     build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out'
    -- },

    {
        "olimorris/persisted.nvim",
        event = "BufReadPre", -- Ensure the plugin loads only when a buffer has been loaded
        opts = {
            autosave = true,
            use_git_branch = true
        },
        config = function(_, opts)
            local persisted = require("persisted")
            persisted.branch = function()
                local branch = vim.fn.systemlist("git branch --show-current")[1]
                return vim.v.shell_error == 0 and branch or nil
            end
            persisted.setup(opts)
        end,
    },

    --Change surrounding symbols
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        opts = {},
    },

    --Trouble nvim, diagnostics and quickfix
    {
        "folke/trouble.nvim",
        opts = {},
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    --TODO comments highlighting
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = true,
    },

    --Word highlighting
    { 'RRethy/vim-illuminate' },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build ' ..
            'build --config Release && cmake --install build --prefix build'
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    },

    --Section context on top of the screen
    { 'nvim-treesitter/nvim-treesitter-context' },

    --Notification plugin
    {
        "rcarriga/nvim-notify",
        opts = { background_colour = '#201a32' },
    },

    --Bookeeping
    --My plugin!
    {
        "Thalles-Gabriel/bookeeping.nvim",
        opts = {}
    }

}, {})


local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = highlight } }

--Neovim Notification
vim.notify = require('notify')
--Neovim theme
-- vim.opt.background = "dark"
vim.cmd [[colorscheme solarized-osaka]]

--Neovim dim
vim.cmd [[:lua Snacks.dim()]]

--Extra configuration
vim.opt.path:append { '**' }
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 10

--Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

--Virtual diagnostics
vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { only_current_line = true, highlight_whole_line = false }
})

--Turn off paste when leaving Insert
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = '*',
    command = "set nopaste"
})

--Asterisks in block comments
vim.opt.formatoptions:append { 'r' }
vim.opt.wildoptions = 'pum'

--Indentation lines and symbols
vim.opt.list = true

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

--File explorer keymap
vim.keymap.set("n", "<leader><CR>", '<CMD>Oil<CR>', { desc = "Open parent directory" })

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
}

--Setup telescope with [Persisted] session
require('telescope').load_extension('persisted')

--Load session with Telescope
vim.api.nvim_create_autocmd("User", {
    pattern = "PersistedTelescopeLoadPre",
    callback = function(session)
        -- Save the currently loaded session passing in the path to the current session
        require("persisted").save({ session = vim.g.persisted_loaded_session })

        -- Delete all of the open buffers
        vim.api.nvim_input("<ESC>:%bd!<CR>")
    end,
})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.install').compilers = { "clang", "gcc", "zig" }

require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'go', 'lua', 'tsx', 'typescript', 'help', 'vim', 'css', 'html',
        'javascript', 'markdown', 'markdown_inline' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner'
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>lr', vim.lsp.buf.rename, 'Re[n]ame')
    nmap('<leader>la', vim.lsp.buf.code_action, 'Code [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gf', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ld', require('telescope.builtin').lsp_document_symbols, '[D]ocument Symbols')
    nmap('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')

    -- See `:help K` for why this keymap
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    --Autocompletion parameters attach
    require('lsp_signature').on_attach({
        event = 'InsertEnter',
        bind = true,
        handler_opts = { border = 'rounded' },
        hint_prefix = nil,
        always_trigger = true,
        toggle_key = '<C-o>',
        hint_enable = false,
        max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.9)
    }, bufnr)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client ~= nil then
            for bufnr, _ in pairs(client.attached_buffers) do
                on_attach(client, bufnr)
            end
        end
    end,
})

--Roslyn setup
require('roslyn').setup {
    config = {
        settings = {
            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
            },
        }
    },
    filewatching = "roslyn",
    lock_target = true
}

--Setup autotag
require('nvim-ts-autotag').setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true
    }
})

-- Setup mason so it can manage external tooling
require('mason').setup {
    registries = {
        "github:mason-org/mason-registry",
        "github:crashdummyy/mason-registry"
    }
}

-- nvim-cmp, luasnip and autopairs setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require("luasnip.loaders.from_vscode").lazy_load()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')


luasnip.config.setup {}

--Color highlighting
require('nvim-highlight-colors').setup({})

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    formatting = {
        format = function(entry, item)
            local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
            item = require("lspkind").cmp_format({
                mode = "symbol_text",
                menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                }),
                maxwidth = {
                    menu = 50,
                    abbr = 50,
                },
                maxheight = {
                    menu = 30
                },
                ellipsis_char = '...',
                show_labelDetails = true,
            })(entry, item)
            if color_item.abbr_hl_group then
                item.kind_hl_group = color_item.abbr_hl_group
                item.kind = color_item.abbr
            end
            return item
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<C-q>'] = cmp.mapping.close(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        {
            name = 'lazydev',
            group_index = 0,
        }
    }),

    completion = {
        completeopt = 'menu,menuone,noinsert,preview'
    }
})


--Angular Setup TODO: Test if Neovim 11 needs this
vim.filetype.add({
    pattern = {
        [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `htmlangular` if it matches the pattern
    },
})
vim.cmd('runtime! ftplugin/html.vim!')
require('lspconfig').angularls.setup({
    filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' }
})

-- The line beneath this is called `modeline`. See `:help modeline`

--Debugging configurations

local dap, dapui = require('dap'), require('dapui')

require('dap.ext.vscode').load_launchjs(nil, {})

--Setting up dap-ui
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Store dotnet dll path
vim.g.dotnet_get_dll_path = function()
    local request = function()
        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. [[\bin\debug\]], 'file')
    end

    if vim.g['dotnet_last_dll_path'] == nil then
        vim.g['dotnet_last_dll_path'] = request()
        -- else
        --     if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
        --         vim.g['dotnet_last_dll_path'] = request()
        --     end
    end

    return vim.g['dotnet_last_dll_path']
end

dap.adapters.coreclr = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. [[\mason\packages\netcoredbg\netcoredbg\netcoredbg.exe]],
    args = { '--interpreter=vscode' },
    options = { cwd = vim.fn.getcwd(), detached = false }
}

--Must execute dap in project folder
dap.providers.configs['dotnet'] = function(bufnr)
    return {
        {
            name = ".NET Neovim Launch",
            type = "coreclr",
            request = "launch",
            program = function()
                return vim.g.dotnet_get_dll_path()
            end,
            args = {},
            stopAtEntry = false,
            console = "integratedTerminal"
        }
    }
end

--Keybindings

--Increment/Decrement numbers
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

--Select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')

--New Tab
vim.keymap.set('n', '<C-w>t', '<cmd>tabedit<CR>', { silent = true, noremap = true, desc = "New Ta[b]" })
vim.keymap.set('n', '<C-w>T', '<cmd>bw<CR>', { silent = true, desc = '[C]lose [T]ab' })

--Cycling through buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true, desc = '[Tab] through buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>',
    { noremap = true, silent = true, desc = 'Rever[s]e [Tab] through bubffer' })
vim.keymap.set('n', '<C-w>q', ':lua Snacks.bufdelete.delete()<CR>', { silent = true, desc = '[Q]uit [C]urrent buffer' })

--Window
vim.keymap.set('n', '<C-w>w', ':close<CR>', { noremap = true, silent = true, desc = '[C]lose [W]indow' })

vim.keymap.set('n', '<C-w>w', ':close<CR>', { noremap = true, silent = true, desc = '[C]lose [W]indow' })

--Moving selected lines/words
-- Normal-mode commands
vim.keymap.set('n', '<A-j>', ':m+ <CR>==', { noremap = true, silent = true, desc = 'Move line [Down]' })
vim.keymap.set('n', '<A-k>', ':m-2 <CR>==', { noremap = true, silent = true, desc = 'Move line [Up]' })

-- Visual-mode commands
vim.keymap.set('v', '<A-j>', ":m '>+1'<CR>gv=gv", { noremap = true, silent = true, desc = 'Move line [Down]' })
vim.keymap.set('v', '<A-k>', ":m '<-2'<CR>gv=gv", { noremap = true, silent = true, desc = 'Move line [Up]' })

--Debugging Keybindings
vim.keymap.set('n', '<F5>', dap.continue, { noremap = true, silent = true, desc = 'Debug Start/Continue' })
vim.keymap.set('n', '<S-F5>', dap.restart, { noremap = true, silent = true, desc = 'Debug Restart' })
vim.keymap.set('n', '<F6>', dap.terminate, { noremap = true, silent = true, desc = 'Debug Stop' })
vim.keymap.set('n', '<F10>', dap.step_over, { noremap = true, silent = true, desc = 'Debug Step Over' })
vim.keymap.set('n', '<F11>', dap.step_into, { noremap = true, silent = true, desc = 'Debug Step Into' })
vim.keymap.set('n', '<S-F11>', dap.step_out, { noremap = true, silent = true, desc = 'Debug Step Out' })
vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { noremap = true, silent = true, desc = 'Debug toggle breakpoint' })
vim.keymap.set('n', '<S-F9>', dap.clear_breakpoints, {
    noremap = true,
    silent = true,
    desc =
    'Debug remove all breakpoints'
})
vim.keymap.set('n', '<A-K>', '<cmd>lua require("dapui").eval()<cr>',
    { noremap = true, silent = true, desc = 'Evaluate Expression' })

--List of errors, diagnostics... plugin
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', '<cmd>Trouble diagnostics toggle<CR><C-w>j',
    { desc = "Open Trouble list" })

--Format
vim.keymap.set('n', '<leader>f', '<cmd>Format<CR>', { noremap = true, silent = true, desc = '[F]ormat[ ]file text' })


--Git/Fugitive
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { silent = true, noremap = true, desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gc', ':Git ', { noremap = true, desc = '[G]it [C]ommand line' })

--GitHub PR setup and bindings
require('litee.lib').setup()
require('litee.gh').setup()

local wk = require("which-key")
wk.add {
    { '<leader>g',    group = 'Git' },
    { '<leader>gh',   group = 'Github' },
    { '<leader>ghc',  group = 'Commits' },
    { '<leader>ghcc', '<cmd>GHCloseCommit<cr>',    desc = 'Close' },
    { '<leader>ghce', '<cmd>GHExpandCommit<cr>',   desc = 'Expand' },
    { '<leader>ghco', '<cmd>GHOpenToCommit<cr>',   desc = 'Open To' },
    { '<leader>ghcp', '<cmd>GHPopOutCommit<cr>',   desc = 'Pop Out' },
    { '<leader>ghcz', '<cmd>GHCollapseCommit<cr>', desc = 'Collapse' },
    { '<leader>ghi',  group = 'Issues' },
    { '<leader>ghip', '<cmd>GHPreviewIssue<cr>',   desc = 'Preview' },
    { '<leader>ghl',  group = 'Litee' },
    { '<leader>ghlt', '<cmd>LTPanel<cr>',          desc = 'Toggle Panel' },
    { '<leader>ghp',  group = 'Pull Request' },
    { '<leader>ghpc', '<cmd>GHClosePR<cr>',        desc = 'Close' },
    { '<leader>ghpd', '<cmd>GHPRDetails<cr>',      desc = 'Details' },
    { '<leader>ghpe', '<cmd>GHExpandPR<cr>',       desc = 'Expand' },
    { '<leader>ghpo', '<cmd>GHOpenPR<cr>',         desc = 'Open' },
    { '<leader>ghpp', '<cmd>GHPopOutPR<cr>',       desc = 'PopOut' },
    { '<leader>ghpr', '<cmd>GHRefreshPR<cr>',      desc = 'Refresh' },
    { '<leader>ghpt', '<cmd>GHOpenToPR<cr>',       desc = 'Open To' },
    { '<leader>ghpz', '<cmd>GHCollapsePR<cr>',     desc = 'Collapse' },
    { '<leader>ghr',  group = 'Review' },
    { '<leader>ghpp', '<cmd>GHPopOutPR<cr>',       desc = 'PopOut' },
    { '<leader>ghpr', '<cmd>GHRefreshPR<cr>',      desc = 'Refresh' },
    { '<leader>ghpt', '<cmd>GHOpenToPR<cr>',       desc = 'Open To' },
    { '<leader>ghpz', '<cmd>GHCollapsePR<cr>',     desc = 'Collapse' },
    { '<leader>ghr',  group = 'Review' },
    { '<leader>ghrb', '<cmd>GHStartReview<cr>',    desc = 'Begin' },
    { '<leader>ghre', '<cmd>GHExpandReview<cr>',   desc = 'Expand' },
    { '<leader>ghrs', '<cmd>GHSubmitReview<cr>',   desc = 'Submit' },
    { '<leader>ghrz', '<cmd>GHCollapseReview<cr>', desc = 'Collapse' },
    { '<leader>ght',  group = 'Threads' },
    { '<leader>ghtc', '<cmd>GHCreateThread<cr>',   desc = 'Create' },
    { '<leader>ghtn', '<cmd>GHNextThread<cr>',     desc = 'Next' },
    { '<leader>ghtt', '<cmd>GHToggleThread<cr>',   desc = 'Toggle' },
}

--Telescope Keybindings
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
--Telescope File Browser
--
function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
end

local fBrowserConfiguration =
'<cmd>lua require("telescope").extensions.file_browser.file_browser({path = "%:p:h", cwd = telescope_buffer_dir(), respect_git_ignore = false, hidden = true, grouped = true, previewer = false, initial_mode = "normal", layout_config = {height = 40}})<CR>'

vim.keymap.set('n', '<leader>sb', fBrowserConfiguration,
    { silent = true, noremap = true, desc = "[S]earch File [B]rowser" }
)

--Neovim statusline terminal access
vim.keymap.set('n', '<F2>', ':! ', { desc = 'Terminal statusline' })



--Terminal mappings
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
