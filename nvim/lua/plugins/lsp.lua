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
      "hrsh7th/cmp-nvim-lsp",
      { "j-hui/fidget.nvim", tag = "legacy", config = true },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require "lspconfig"

      -- Setup mason-lspconfig
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "html",
          "cssls",
          "tailwindcss",
          "svelte",
          "prismals",
          "css_variables",
          "eslint",
          "ts_ls",
          "dockerls",
          "dotls",
          "graphql",
          "jsonls",
          "vimls",
          "yamlls",
          "textlsp",
          "stylelint_lsp",
          "docker_compose_language_service",
          "terraformls",
          "tailwindcss",
          "vale_ls",
        },
        automatic_installation = true,
      }

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
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = {
                  [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                  [vim.fn.stdpath "config" .. "/lua"] = true,
                },
              },
            },
          },
        },
        yaml = {
          keyOrdering = false,
          schemas = {
            kubernetes = "k8s-*.yaml",
            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/manifest/**/*.yaml",
          },
        },
        eslint = {
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
        stylelint_lsp = {

          filetypes = { "css", "scss", "less" },
          settings = {
            stylelintplus = {
              autoFixOnSave = true,
            },
          },
        },
        cssls = {
          filetypes = { "css", "scss", "less" },
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
        },
      }

      for server, settings in pairs(servers) do
        lspconfig[server].setup {
          capabilities = capabilities,
          settings = settings,
        }
      end
    end,
  },

  -- Formatters and linters
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { { "prettierd", "prettier" } },
          typescript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
          svelte = { { "prettierd", "prettier" } },
          css = { { "prettierd", "prettier" } },
          html = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          yaml = { { "prettierd", "prettier" } },
          markdown = { { "prettierd", "prettier" } },
          graphql = { { "prettierd", "prettier" } },
          java = { "google-java-format" },
          kotlin = { "ktlint" },
          scss = { "prettierd", "prettier" },
          fish = { "fish_indent" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      }
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
      require("lspsaga").setup {
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
      }
    end,
  },
}
