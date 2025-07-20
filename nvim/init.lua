-- Map leader
vim.g.mapleader = " "      -- Set leader key to space
vim.g.maplocalleader = " " -- Set local leader key (NEW)

-- Plugins
require('config.lazy')

-- Configurations
require('config.options')
require('config.visuals')
require('config.keymaps')
require('config.autocmd')
require('config.languages')
require('config.terminal')
require('config.globals')
