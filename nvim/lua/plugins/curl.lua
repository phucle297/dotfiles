return {
  {
    "oysandvik94/curl.nvim",
    keys = {
      {
        "<leader>cc",
        function()
          require("curl").open_curl_tab()
        end,
        desc = "Open curl tab (scoped)",
      },
      {
        "<leader>co",
        function()
          require("curl").open_global_tab()
        end,
        desc = "Open curl tab (global)",
      },
      {
        "<leader>csc",
        function()
          require("curl").create_scoped_collection()
        end,
        desc = "Create scoped collection",
      },
      {
        "<leader>cgc",
        function()
          require("curl").create_global_collection()
        end,
        desc = "Create global collection",
      },
      {
        "<leader>fsc",
        function()
          require("curl").pick_scoped_collection()
        end,
        desc = "Pick scoped collection",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
}
