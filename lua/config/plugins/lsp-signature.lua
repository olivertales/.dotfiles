return {
  'ray-x/lsp_signature.nvim',
  event = 'InsertEnter',
  opts = {
    bind = true,
    max_height = 10,
    close_timeout = 1000,
    toggle_key = '<M-Space>',
    select_signature_key = '<M-n>'
  }
}
