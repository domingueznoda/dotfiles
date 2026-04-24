return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 1. Filetypes y Treesitter
      vim.filetype.add({
        extension = {
          mc = "monkeyc",
          mcgen = "monkeyc",
        },
      })
      vim.treesitter.language.register("javascript", "monkeyc")
      vim.treesitter.language.register("javascript", "monkey-c")

      -- 2. Detección de SDK y JAR
      local current_sdk_cfg_path = "~/.Garmin/ConnectIQ/current-sdk.cfg"
      if vim.g.monkeyc_current_sdk_cfg_path then
        current_sdk_cfg_path = vim.g.monkeyc_current_sdk_cfg_path
      elseif vim.loop.os_uname().sysname == "Darwin" then
        current_sdk_cfg_path = "~/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg"
      end

      local ok, lines = pcall(vim.fn.readfile, vim.fn.expand(current_sdk_cfg_path))
      if not ok then
        return
      end
      local workspace_dir = table.concat(lines, "\n")
      local monkeyc_ls_jar = workspace_dir .. "/bin/LanguageServer.jar"

      if vim.fn.filereadable(monkeyc_ls_jar) ~= 1 then
        return
      end

      -- 3. Definición de Capabilities Personalizadas
      local monkeycLspCapabilities = vim.lsp.protocol.make_client_capabilities()
      monkeycLspCapabilities.textDocument.declaration = { dynamicRegistration = true }
      monkeycLspCapabilities.textDocument.implementation = { dynamicRegistration = true }
      monkeycLspCapabilities.textDocument.typeDefinition = { dynamicRegistration = true }
      monkeycLspCapabilities.textDocument.documentHighlight = { dynamicRegistration = true }
      monkeycLspCapabilities.textDocument.hover = { dynamicRegistration = true }
      monkeycLspCapabilities.textDocument.signatureHelp = { contextSupport = true, dynamicRegistration = true }
      monkeycLspCapabilities.workspace = { didChangeWorkspaceFolders = { dynamicRegistration = true } }
      monkeycLspCapabilities.textDocument.foldingRange = { lineFoldingOnly = true, dynamicRegistration = true }

      -- 4. Registro del servidor en la lista de LazyVim
      opts.servers = opts.servers or {}
      opts.servers.monkeyc_ls = {
        cmd = {
          "java",
          "-Dapple.awt.UIElement=true",
          "-classpath",
          monkeyc_ls_jar,
          "com.garmin.monkeybrains.languageserver.LSLauncher",
        },
        filetypes = { "monkey-c", "monkeyc", "jungle", "mss" },
        root_dir = require("lspconfig.util").root_pattern("monkey.jungle", "manifest.xml"),
        capabilities = monkeycLspCapabilities,
        settings = {
          developerKeyPath = vim.fn.expand(vim.g.monkeyc_connect_iq_dev_key_path or "~/.Garmin/connect_iq_dev_key.der"),
          compilerWarnings = true,
          jungleFiles = vim.g.monkeyc_jungle_files or "monkey.jungle",
          testDevices = { vim.g.monkeyc_default_device or "enduro3" },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.completionProvider = {
            triggerCharacters = { ".", ":" },
            resolveProvider = false,
          }
          local req = client.request
          client.request = function(method, params, handler, bufnr_req)
            if method == "textDocument/definition" then
              return req(method, params, function(err, result, context, config)
                local function fix_uri(uri)
                  return uri:match("^file:/[^/]") and uri:gsub("^file:/", "file:///") or uri
                end
                if vim.islist(result) then
                  for _, res in ipairs(result) do
                    if res.uri then
                      res.uri = fix_uri(res.uri)
                    end
                  end
                elseif result and result.uri then
                  result.uri = fix_uri(result.uri)
                end
                return handler(err, result, context, config)
              end, bufnr_req)
            elseif method == "textDocument/signatureHelp" then
              params.context = { triggerKind = 1 }
            end
            return req(method, params, handler, bufnr_req)
          end
        end,
      }

      -- 5. Keymaps (Mantenidos igual que tu original)
      vim.keymap.set("n", "<M-h>", function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.api.nvim_win_get_config(winid).zindex then
            vim.cmd.fclose()
            return
          end
        end
        vim.lsp.buf.hover()
      end, { silent = true })

      vim.keymap.set("i", "<M-h>", vim.lsp.buf.signature_help, { silent = true })

      vim.keymap.set("n", "<leader>mr", function()
        vim.cmd("botright 12split | term ./run.sh")
        vim.cmd("startinsert")
      end, { desc = "MonkeyC: Run Simulator" })
    end,
  },
}
