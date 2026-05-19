return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Define a custom language server for monkeyc
      local configs = require("lspconfig.configs")
      local lspconfig = require("lspconfig")

      vim.filetype.add({
        extension = {
          mc = "monkeyc",
          jungle = "jungle",
        },
      })

      vim.treesitter.language.register("javascript", "monkeyc")
      vim.treesitter.language.register("javascript", "monkey-c")

      local function get_language_server_path()
        local workspace_dir = table.concat(vim.fn.readfile(vim.fn.expand("~/.Garmin/ConnectIQ/current-sdk.cfg")), "\n")
        local jar_path = workspace_dir .. "/bin/LanguageServer.jar"

        if vim.fn.filereadable(jar_path) == 1 then
          return jar_path
        end
        print("Monkey C Language Server not found: " .. jar_path)
        return nil
      end

      local monkeyc_lsp_jar = get_language_server_path()
      if monkeyc_lsp_jar then
        -- To enable tracing of the official VSCode plugin, add the following snippet
        -- under "contributes" -> "configuration" -> "properties"
        -- in ~/.vscode/extensions/garmin.monkey-c-1.1.1/package.json
        --
        -- "monkeyc.trace.server": {
        -- 	"scope": "window",
        -- 	"type": "string",
        -- 	"enum": [
        -- 		"off",
        -- 		"messages",
        -- 		"verbose"
        -- 	],
        -- 	"default": "verbose",
        -- 	"description": "Traces the communication between VS Code and the language server."
        -- },
        --
        -- Then open a MonkeyC project and check the VSCode "Output" window
        --
        -- To debug the nvim plugin:
        -- tail -f ~/.local/state/nvim/lsp.log
        --
        -- Uncomment the following to enable debug logging
        -- vim.lsp.set_log_level("debug")
        --
        -- Open a MonkeyC project and check the lsp.log output
        --

        local monkeycLspCapabilities = vim.lsp.protocol.make_client_capabilities()
        -- Need to set some variables in the client capabilities to prevent the
        -- LanguageServer from raising exceptions
        monkeycLspCapabilities.textDocument.declaration.dynamicRegistration = true
        monkeycLspCapabilities.textDocument.implementation.dynamicRegistration = true
        monkeycLspCapabilities.textDocument.typeDefinition.dynamicRegistration = true
        monkeycLspCapabilities.textDocument.documentHighlight.dynamicRegistration = true
        monkeycLspCapabilities.workspace = {
          didChangeWorkspaceFolders = {
            dynamicRegistration = true,
          },
        }
        monkeycLspCapabilities.textDocument.foldingRange = {
          lineFoldingOnly = true,
          dynamicRegistration = true,
        }

        if not configs.monkeyc_ls then
          local root = lspconfig.util.root_pattern("manifest.xml") or vim.fn.getcwd()
          configs.monkeyc_ls = {
            default_config = {
              cmd = {
                "java",
                "-Dapple.awt.UIElement=true",
                "-classpath",
                monkeyc_lsp_jar,
                "com.garmin.monkeybrains.languageserver.LSLauncher",
              },
              filetypes = { "monkeyc", "jungle", "mss" },
              root_dir = root,
              settings = {
                {
                  developerKeyPath = vim.g.monkeyc_connect_iq_dev_key_path
                    or vim.fn.expand("~/.Garmin/connect_iq_dev_key.der"),
                  compilerWarnings = true,
                  compilerOptions = vim.g.monkeyc_compiler_options or "",
                  developerId = "",
                  jungleFiles = "monkey.jungle",
                  javaPath = "",
                  typeCheckLevel = "Default",
                  optimizationLevel = "Default",
                  testDevices = {
                    "enduro3", -- get this dynamically from the manifest file
                  },
                  debugLogLevel = "Default",
                },
              },
              capabilities = monkeycLspCapabilities,
              init_options = {
                publishWarnings = vim.g.monkeyc_publish_warnings or true,
                compilerOptions = vim.g.monkeyc_compiler_options or "",
                typeCheckMsgDisplayed = true,
                workspaceSettings = {
                  {
                    path = root(vim.fn.getcwd()),
                    jungleFiles = {
                      root(vim.fn.getcwd()) .. "/monkey.jungle",
                    },
                  },
                },
              },
            },
          }
        end

        -- print(vim.lsp.client.config)
        lspconfig.monkeyc_ls.setup({})
      end
    end,
  },
}
