return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- ===== Language Servers =====
        -- TypeScript / JavaScript
        "typescript-language-server",

        -- Python
        "pyright",

        -- Docker
        "docker-compose-language-service",
        "docker-language-server",
        "dockerfile-language-server",
        "hadolint",

        -- C / C++
        "clangd",

        -- HTML / CSS
        "html-lsp",
        "css-lsp",

        -- JSON / YAML (rất nên có)
        "json-lsp",
        "yamlls",

        -- ===== Formatters =====
        "prettier", -- js/ts/html/css/json
        "biome",
        "black", -- python
        "isort", -- python imports
        "stylua", -- lua

        -- ===== Linters =====
        "eslint_d", -- js/ts
        "oxlint",
        "flake8", -- python

        -- ===== Utilities =====
        "cpplint",
        "vale",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
