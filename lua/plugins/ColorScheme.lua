local C = {
  "samharju/synthweave.nvim",
  lazy = true, -- make sure we load this during startup if it is your main colorscheme
  --priority = 1000,
  config = function()
    vim.cmd.colorscheme("synthweave")
    --fo transparent version
    -- vim.cmd.colorscheme("synthweave-transparent")
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.opt.fillchars = { eob = " " }
  end,
}

local OneDarkTheme = {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 10000, -- make sure to load this before all the other start plugins
  config = function()
    require("onedark").setup({
      transparent = true,
      lualine = { transparent = true },
      style = "darker",
    })
    -- Enable theme
    require("onedark").load()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatTitle", { bg = "none" })
    vim.opt.fillchars = { eob = " " }
  end,
}
return { C, OneDarkTheme }
