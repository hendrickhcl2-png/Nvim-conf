-- ~/.config/nvim/lua/plugins/sql.lua
return {
  {
    "nanotee/sqls.nvim",
    dependencies = { "AstroNvim/astrocore" },
    ft = { "sql", "mysql", "plsql" }, -- load on SQL filetypes, before LspAttach
  },
}
