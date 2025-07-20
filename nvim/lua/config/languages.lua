vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    if client:supports_method('textDocument/completion', ev.buf) then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end
})

vim.lsp.enable({
  'lua_ls',
  'roslyn',
  'tsserver'
})

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true, hightlight_whole_line = false }
})
