return {
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      { "j-hui/fidget.nvim", tag = "legacy", config = true },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lspconfig = require("lspconfig")

      -- Setup mason-lspconfig
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "css_variables",
          "cssls",
          "docker_compose_language_service",
          "dockerls",
          "dotls",
          "eslint",
          "graphql",
          "biome",
          "html",
          "jsonls",
          "lua_ls",
          "prismals",
          "svelte",
          "stylelint_lsp",
          "tailwindcss",
          "terraformls",
          "textlsp",
          -- "ts_ls",
          "vtsls",
          "vale_ls",
          "vimls",
          "yamlls",
        },
        automatic_installation = true,
      })

      -- Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end,
      })

      -- Configure LSP servers
      local servers = {
        biome = {
          filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        },
        tailwindcss = {
          filetypes = { "html", "css", "javascriptreact", "typescriptreact", "svelte" },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "clsx\\(([^)]*)\\)", -- Supports clsx utility
                  "classnames\\(([^)]*)\\)", -- Supports classnames utility
                  '"([^"]*)"', -- Generic class string matching
                },
              },
            },
          },
        },
        -- ts_ls = {
        --   filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        --   settings = {
        --     typescript = {
        --       inlayHints = {
        --         includeInlayParameterNameHints = "all",
        --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        --         includeInlayFunctionParameterTypeHints = true,
        --         includeInlayVariableTypeHints = true,
        --         includeInlayPropertyDeclarationTypeHints = true,
        --         includeInlayFunctionLikeReturnTypeHints = true,
        --         includeInlayEnumMemberValueHints = true,
        --       },
        --     },
        --   },
        -- },
        vtsls = {
          filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = {
                  enabled = "all", -- corresponds to includeInlayParameterNameHints
                  suppressWhenArgumentMatchesName = false, -- corresponds to includeInlayParameterNameHintsWhenArgumentMatchesName
                },
                parameterTypes = {
                  enabled = true, -- corresponds to includeInlayFunctionParameterTypeHints
                },
                variableTypes = {
                  enabled = true, -- corresponds to includeInlayVariableTypeHints
                },
                propertyDeclarationTypes = {
                  enabled = true, -- corresponds to includeInlayPropertyDeclarationTypeHints
                },
                functionLikeReturnTypes = {
                  enabled = true, -- corresponds to includeInlayFunctionLikeReturnTypeHints
                },
                enumMemberValues = {
                  enabled = true, -- corresponds to includeInlayEnumMemberValueHints
                },
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
            },
          },
        },
        yamlls = {
          settings = { -- Wrap these settings properly
            yaml = { -- Add this nesting level
              keyOrdering = false,
              schemas = {
                kubernetes = "k8s-*.yaml",
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/manifest/**/*.yaml",
              },
            },
          },
        },
        eslint = {
          -- Move the on_attach to the setup call instead
          settings = {}, -- Add empty settings if needed
        },
        stylelint_lsp = {
          settings = {
            stylelintplus = {
              autoFixOnSave = true,
            },
          },
          filetypes = { "css", "scss", "less" },
        },
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
          filetypes = { "css", "scss", "less" },
        },
        -- css_variables = {},
        -- docker_compose_language_service = {},
        -- dockerls = {},
        -- dotls = {},
        -- graphql = {},
        -- html = {},
        -- jsonls = {},
        -- prismals = {},
        -- svelte = {},
        -- tailwindcss = {},
        -- terraformls = {},
        -- vale_ls = {},
        -- vimls = {},
      }

      -- Separate on_attach function
      local on_attach = function(client, bufnr)
        -- Any on_attach functionality
        if client.name == "eslint" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end
      end

      -- Setup servers
      for server, config in pairs(servers) do
        lspconfig[server].setup({
          capabilities = capabilities,
          settings = config.settings,
          filetypes = config.filetypes,
          on_attach = on_attach,
        })
      end
    end,
  },

  -- Lsp saga
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    config = function()
      require("lspsaga").setup({
        ui = {
          title = true,
          -- Border type can be single, double, rounded, solid, shadow.
          border = "rounded",
          winblend = 0,
          expand = "",
          collapse = "",
          code_action = "",
          incoming = " ",
          outgoing = " ",
          hover = " ",
          kind = {},
        },
      })
    end,
  },
}
