return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim'
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    local harpoon_extensions = require("harpoon.extensions")
    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-h>", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-t>", function()
          harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr })
      end,
    })

    vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Open Harpoon Telescope" })
    vim.keymap.set("n", "<leader>h<leader>", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open Harpoon window" })

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = 'Add to Harpoon' })
    vim.keymap.set("n", "<leader>hr", function() harpoon:list():remove() end, { desc = 'Remove from Harpoon' })

    vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = 'Select Harpoon (1)' })
    vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = 'Select Harpoon (2)' })
    vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = 'Select Harpoon (3)' })
    vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = 'Select Harpoon (4)' })
    vim.keymap.set("n", "<leader>h5", function() harpoon:list():select(5) end, { desc = 'Select Harpoon (5)' })
    vim.keymap.set("n", "<leader>h6", function() harpoon:list():select(6) end, { desc = 'Select Harpoon (6)' })
    vim.keymap.set("n", "<leader>h7", function() harpoon:list():select(7) end, { desc = 'Select Harpoon (7)' })
    vim.keymap.set("n", "<leader>h8", function() harpoon:list():select(8) end, { desc = 'Select Harpoon (8)' })
    vim.keymap.set("n", "<leader>h9", function() harpoon:list():select(9) end, { desc = 'Select Harpoon (9)' })
    vim.keymap.set("n", "<leader>h0", function() harpoon:list():select(10) end, { desc = 'Select Harpoon (10)' })

    vim.keymap.set("n", "<leader>h<S-Tab>", function() harpoon:list():prev() end, { desc = 'Select Harpoon previous' })
    vim.keymap.set("n", "<leader>h<Tab>", function() harpoon:list():next() end, { desc = 'Select Harpoon next' })
  end
}
