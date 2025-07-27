return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'nightfly'
    },
    sections = {
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        {
          'filename',
          newfile_status = true,
          symbols = {
            readonly = '[Readonly]'
          }
        }
      },
      lualine_y = {
        { 'progress', separator = '|' },
        'location',
      },
      lualine_z = { 'os.date("%X")' }
    }
  }
}
