return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Toggle Terminal" },
    { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
  },
  opts = {
    size = 15,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    float_opts = {
      border = "curved",
    },
  },
}
