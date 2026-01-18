return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      size = 15,
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      shell = vim.o.shell,
      start_in_insert = true,
    })

    -- Custom npm command functions
    local Terminal = require("toggleterm.terminal").Terminal

    local npm_start = Terminal:new({
      cmd = "npm start",
      direction = "horizontal",
      close_on_exit = false,
    })

    local npm_dev = Terminal:new({
      cmd = "npm run dev",
      direction = "horizontal",
      close_on_exit = false,
    })

    -- Keybindings
    vim.keymap.set("n", "<leader>ns", function()
      npm_start:toggle()
    end, { desc = "npm start" })
    vim.keymap.set("n", "<leader>nd", function()
      npm_dev:toggle()
    end, { desc = "npm run dev" })
  end,
}
