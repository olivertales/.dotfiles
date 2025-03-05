--[[
I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
-- Set <space> as the leader key
-- See `:help mapleader` ]]
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
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

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
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
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
    -- NOTE: First, some plugins that don't require any configuration

    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    -- 'tpope/vim-sleuth',

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    --Omnisharp fix
    { 'Hoffs/omnisharp-extended-lsp.nvim' },


    --Db connection in neovim
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod',                     lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end
    },
    --Windowed builtin terminal
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
        },
    },

    -- Nice inline erros for lsp
    {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function ()
            require('lsp_lines').setup()
        end
    },

    {
      'stevearc/dressing.nvim',
      opts = {},
    },
    --
    -- --Noice, ui cmdline and search style
    -- {
    --     "folke/noice.nvim",
    --     dependencies = {
    --         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         "rcarriga/nvim-notify",
    --     },
    --     opts = {
    --         cmdline = {
    --             enabled = true,
    --             format = {
    --                 filter = { pattern = "^:%s*!", icon = ">_", lang = "bash" },
    --             },
    --         },
    --         lsp = {
    --             -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    --             override = {
    --                 ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    --                 ["vim.lsp.util.stylize_markdown"] = true,
    --                 ["cmp.entry.get_documentation"] = true,
    --             },
    --
    --             signature = {
    --                 enabled = false
    --             },
    --         },
    --         -- you can enable a preset for easier configuration
    --         presets = {
    --             command_palette = true,       -- position the cmdline and popupmenu together
    --             long_message_to_split = true, -- long messages will be sent to a split
    --             inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    --             lsp_doc_border = true,        -- add a border to hover docs and signature help
    --         },
    --     },
    -- },

    --File navigator
    {
        'stevearc/oil.nvim',
        opts = {},
    },

    --Color highlighter plugin
    {
        'norcalli/nvim-colorizer.lua',
        opts = {
            '*',
            '!vim',
            css = {
                css = true,
                css_fn = true,
            },
        },
    },

    --Autopair plugin
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end,
    },
    --Auto close html tag
    { 'windwp/nvim-ts-autotag' },

    {
        "ckipp01/stylua-nvim"
    },
    --GitHub Pull Request UI
    {
        'ldelossa/gh.nvim',
        dependencies = 'ldelossa/litee.nvim'
    },

    -- LuaSnip
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = '2.*',
        build = 'make install_jsregexp',
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    },

    --Autocompletion parameter marking
    { 'ray-x/lsp_signature.nvim' },

    --Lsp autocomplete icons
    { 'onsails/lspkind.nvim' },

    --Undo tree
    { 'mbbill/undotree' },

    --Snippets collection plugin
    { 'rafamadriz/friendly-snippets' },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',        opts = {} },

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

    -- TransparencyToggle
    { 'xiyaowong/transparent.nvim' },

    -- Carbon theme
    -- { 'nyoom-engineering/oxocarbon.nvim' },

    {
        "craftzdog/solarized-osaka.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = false,
            dim_inactive = true,
            on_colors = function(colors)
                colors.green500 = colors.violet500
            end
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
        'mfussenegger/nvim-dap'
    },
    --Debug UI plugin
    { "rcarriga/nvim-dap-ui",      dependencies = { "mfussenegger/nvim-dap" }, },

    --Asynchronous IO Neovim
    { "nvim-neotest/nvim-nio" },

    --Javascript debugging dependencies
    {
        'microsoft/vscode-js-debug',
        lazy = true,
        build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out'
    },

    --Javascript debugger
    {
        'mxsdev/nvim-dap-vscode-js',
        dependencies = { 'mfussenegger/nvim-dap' },
        opts = {
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge' },
        },
    },

    --Startup screen plugin
    {
        "startup-nvim/startup.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require "startup".setup({
                theme = "startify"
            })
        end
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
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    --[[  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  }, ]]

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

    --Typescript compile plugin
    {
        'dmmulroy/tsc.nvim',
        opts = {}
    },

    --Notification plugin
    {
        "rcarriga/nvim-notify",
        opts = { background_colour = '#201a32' },
    },

    -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
    --       These are some example plugins that I've included in the kickstart repository.
    --       Uncomment any of the lines below to enable them.
    -- require 'kickstart.plugins.autoformat',
    -- require 'kickstart.plugins.debug',

    -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
    --    up-to-date with whatever is in the kickstart repo.
    --
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    --
    --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
    --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
    -- { import = 'custom.plugins' },
}, {})


--Rainbow indent hightlighting
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
vim.cmd [[colorscheme solarized-osaka-storm]]

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
vim.o.completeopt = 'menuone,noselect'

--File explorer setup and keymap
require("oil").setup()
vim.keymap.set("n", "<leader><CR>", require("oil").open, { desc = "Open parent directory" })

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
        vim.highlight.on_yank()
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

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.install').compilers = { "clang", "gcc", "zig" }

require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'rust', 'tsx', 'typescript', 'help', 'vim', 'css', 'html',
        'javascript', 'markdown' },

    autotag = { enable = true, },
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
                ['ic'] = '@class.inner',
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
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
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
        bind = true,
        handler_opts = { border = 'rounded' },
        hint_prefix = nil,
        always_trigger = true,
        toggle_key = '<C-o>',
    }, bufnr)
end


-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

--Setup dap-ui
require('dapui').setup()

-- Setup neovim lua configuration
require('neodev').setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
        }
    end,
}

--Zig remove format on save
vim.g.zig_fmt_autosave = 0

--Omnisharp trying fix
require 'lspconfig'.omnisharp.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
        ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
        ["textDocument/references"] = require('omnisharp_extended').references_handler,
        ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
    },
    settings = settings
})

-- nvim-cmp, luasnip and autopairs setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

luasnip.config.setup {}

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

cmp.setup {
    preselect = cmp.PreselectMode.None,
    formatting = {
        format = require('lspkind').cmp_format({
            mode = "symbol_text",
            menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[Latex]",
            })
        }),
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
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

--Debugging configurations

local dap, dapui = require('dap'), require('dapui')

-- for _, language in ipairs({ "typescript", "javascript" }) do
--   dap.configurations[language] = {
--     {
--       {
--         type = "pwa-node",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--       },
--       {
--         type = "pwa-node",
--         request = "attach",
--         name = "Attach",
--         processId = require'dap.utils'.pick_process,
--         cwd = "${workspaceFolder}",
--       },
--       {
--         type = "msedge",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--       },
--     }
--   }
-- end

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

-- require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. [[\.vscode\launch.json]], nil)
-- Store dll path
vim.g.dotnet_get_dll_path = function()
    local request = function()
        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. [[\bin\Debug\]], 'file')
    end

    if vim.g['dotnet_last_dll_path'] == nil then
        vim.g['dotnet_last_dll_path'] = request()
    else
        if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
            vim.g['dotnet_last_dll_path'] = request()
        end
    end

    return vim.g['dotnet_last_dll_path']
end

--Build DotNet project
vim.g.dotnet_build_project = function()
    local default_path = vim.fn.getcwd() .. '/'
    if vim.g['dotnet_last_proj_path'] ~= nil then
        default_path = vim.g['dotnet_last_proj_path']
    end
    local path = vim.fn.input('Path to your *proj file: ', default_path, 'file')
    vim.g['dotnet_last_proj_path'] = path
    local cmd = 'dotnet build -c Debug ' .. path .. ' > nul'
    print('')
    print('Cmd to execute: ' .. cmd)
    local f = os.execute(cmd)
    if f == 0 then
        print('\nBuild: ✔️ ')
    else
        print('\nBuild: ❌ (code: ' .. f .. ')')
    end
end

dap.adapters.coreclr = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. [[\mason\packages\netcoredbg\netcoredbg\netcoredbg.exe]],
    args = { '--interpreter=vscode' },
    options = { cwd = vim.fn.getcwd() }
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = ".NET Launch",
        request = "launch",
        program = function()
            return vim.g.dotnet_get_dll_path()
        end,
    },
}
--Keybindings

--Increment/Decrement numbers
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

--Delete a word backwards
vim.keymap.set('n', 'dw', 'vb"_d')

--Select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')

--New Tab
vim.keymap.set('n', 'B', ':tabedit<CR>', { silent = true, noremap = true, desc = "New Ta[b]" })

--Cycling through buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true, desc = '[Tab] through buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>',
    { noremap = true, silent = true, desc = 'Rever[s]e [Tab] through bubffer' })
vim.keymap.set('n', '<C-q>', ':bd<CR>', { noremap = true, silent = true, desc = '[Q]uit [C]urrent buffer' })

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
vim.keymap.set('n', '<leader>db', ':lua vim.g.dotnet_build_project()<CR>',
    { noremap = true, silent = true, desc = '[B]uild[ ][D]otNet' })
vim.keymap.set('n', '<leader>dr', ':! dotnet watch run vim.fn.getcwd<CR>',
    { noremap = true, silent = true, desc = '[D]otNet Watch [R]un' })

--List of errors, diagnostics... plugin
--[[ vim.keymap.set('n', '<leader>l', '<cmd>TroubleToggle<CR>', {noremap = true, silent = true, desc='Toggle Trouble diagnostics[ ][l]ist'}) ]]
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', '<cmd>Trouble diagnostics win.type = split win.position=bottom<CR>', { desc = "Open Trouble list" })

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
  { '<leader>g', group = 'Git' },
  { '<leader>gh', group = 'Github' },
  { '<leader>ghc', group = 'Commits' },
  { '<leader>ghcc', '<cmd>GHCloseCommit<cr>', desc = 'Close' },
  { '<leader>ghce', '<cmd>GHExpandCommit<cr>', desc = 'Expand' },
  { '<leader>ghco', '<cmd>GHOpenToCommit<cr>', desc = 'Open To' },
  { '<leader>ghcp', '<cmd>GHPopOutCommit<cr>', desc = 'Pop Out' },
  { '<leader>ghcz', '<cmd>GHCollapseCommit<cr>', desc = 'Collapse' },
  { '<leader>ghi', group = 'Issues' },
  { '<leader>ghip', '<cmd>GHPreviewIssue<cr>', desc = 'Preview' },
  { '<leader>ghl', group = 'Litee' },
  { '<leader>ghlt', '<cmd>LTPanel<cr>', desc = 'Toggle Panel' },
  { '<leader>ghp', group = 'Pull Request' },
  { '<leader>ghpc', '<cmd>GHClosePR<cr>', desc = 'Close' },
  { '<leader>ghpd', '<cmd>GHPRDetails<cr>', desc = 'Details' },
  { '<leader>ghpe', '<cmd>GHExpandPR<cr>', desc = 'Expand' },
  { '<leader>ghpo', '<cmd>GHOpenPR<cr>', desc = 'Open' },
  { '<leader>ghpp', '<cmd>GHPopOutPR<cr>', desc = 'PopOut' },
  { '<leader>ghpr', '<cmd>GHRefreshPR<cr>', desc = 'Refresh' },
  { '<leader>ghpt', '<cmd>GHOpenToPR<cr>', desc = 'Open To' },
  { '<leader>ghpz', '<cmd>GHCollapsePR<cr>', desc = 'Collapse' },
  { '<leader>ghr', group = 'Review' },
  { '<leader>ghrb', '<cmd>GHStartReview<cr>', desc = 'Begin' },
  { '<leader>ghrc', '<cmd>GHCloseReview<cr>', desc = 'Close' },
  { '<leader>ghrd', '<cmd>GHDeleteReview<cr>', desc = 'Delete' },
  { '<leader>ghre', '<cmd>GHExpandReview<cr>', desc = 'Expand' },
  { '<leader>ghrs', '<cmd>GHSubmitReview<cr>', desc = 'Submit' },
  { '<leader>ghrz', '<cmd>GHCollapseReview<cr>', desc = 'Collapse' },
  { '<leader>ght', group = 'Threads' },
  { '<leader>ghtc', '<cmd>GHCreateThread<cr>', desc = 'Create' },
  { '<leader>ghtn', '<cmd>GHNextThread<cr>', desc = 'Next' },
  { '<leader>ghtt', '<cmd>GHToggleThread<cr>', desc = 'Toggle' },
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
function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
end

local fBrowserConfiguration =
'<cmd>lua require("telescope").extensions.file_browser.file_browser({path = "%:p:h", cwd = telescope_buffer_dir(), respect_git_ignore = false, hidden = true, grouped = true, previewer = false, initial_mode = "normal", layout_config = {height = 40}})<CR>'

vim.keymap.set('n', '<leader>sb', fBrowserConfiguration,
    { silent = true, noremap = true, desc = "[S]earch File [B]rowser" }
)

--Replace text
vim.keymap.set('n', ';', ':%s/', { desc = 'Replace text' })

--UndoTree toggle
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { silent = true, noremap = true, desc = '[U]ndo Tree Toggle' })

--Neovim statusline terminal access
vim.keymap.set('n', '<F2>', ':! ', { desc = 'Terminal statusline' })

--Toggle terminal
local term = require('toggleterm.terminal').Terminal

function Toggle_Terminal(termDirec)
    term:new({ direction = termDirec }):toggle()
end

vim.keymap.set('n', '<leader>it', "<cmd>lua Toggle_Terminal('tab')<CR>",
    { desc = 'Toggle Tab Term[i]nal', silent = true, noremap = true })
vim.keymap.set('n', '<leader>iv', "<cmd>lua Toggle_Terminal('vertical')<CR>",
    { desc = 'Toggle [V]ertical Term[i]nal', silent = true, noremap = true })
vim.keymap.set('n', '<leader>ih', "<cmd>lua Toggle_Terminal('horizontal')<CR>",
    { desc = 'Toggle [H]orizontal Term[i]nal', silent = true, noremap = true })
vim.keymap.set('n', '<leader>if', "<cmd>lua Toggle_Terminal('float')<CR>",
    { desc = 'Toggle [F]loating Term[i]nal', silent = true, noremap = true })

--Terminal mappings
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<leader><Tab>', [[<cmd>tabNext<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

--Toggling through tabs
vim.keymap.set('n', '<leader><Tab>', '<cmd>tabNext<CR>', { desc = 'Cycle[ ][Tab]s', silent = true, noremap = true })
