return {
  cmd = { 'lua-language-server' },
  root_markers = { { '.luarc.json', '.luarc.json' }, '.git' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT'
      }
    }
  }
}
