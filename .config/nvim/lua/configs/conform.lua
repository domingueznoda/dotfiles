local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    php = { "pint" },
    xml = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    cs = { "clang_format" },
    python = { "black" },
    blade = { "blade-formatter" },
  },

  formatters = {
    ["blade-formatter"] = {
      prepend_args = {
        "--wrap=120",
        "--indent-size=2",
        "--sort-tailwindcss-classes",
      },
    },
  },

  -- These options will be passed to conform.format()
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
