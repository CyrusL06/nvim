-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Dynamic Objectives Panel for Neovim
local M = {}
M.buf = nil
M.win = nil

-- File to store objectives
local objectives_file = vim.fn.stdpath("data") .. "/objectives.txt"

-- Load objectives from file
local function load_objectives()
  local file = io.open(objectives_file, "r")
  if file then
    local content = file:read("*all")
    file:close()
    return vim.split(content, "\n")
  else
    -- Default objectives if file doesn't exist
    return {
      "📋 TODAY'S OBJECTIVES",
      "═══════════════════════",
      "",
      "[ ] Your first objective here",
      "[ ] Add more with :ObjectiveAdd",
      "",
      "Press 'e' to edit, 'd' to delete line",
      "Press 's' to save changes",
    }
  end
end

-- Save objectives to file
local function save_objectives()
  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(M.buf, 0, -1, false)
  local file = io.open(objectives_file, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
    print("✓ Objectives saved!")
  end
end

-- Toggle objective completion (checkbox)
local function toggle_objective()
  local line = vim.api.nvim_get_current_line()
  local new_line

  if line:match("%[ %]") then
    new_line = line:gsub("%[ %]", "[✓]", 1)
  elseif line:match("%[✓%]") then
    new_line = line:gsub("%[✓%]", "[ ]", 1)
  else
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.bo[M.buf].modifiable = true
  vim.api.nvim_buf_set_lines(M.buf, row - 1, row, false, { new_line })
  vim.bo[M.buf].modifiable = false
  save_objectives()
end

-- Delete current line
local function delete_line()
  vim.bo[M.buf].modifiable = true
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(M.buf, row - 1, row, false, {})
  vim.bo[M.buf].modifiable = false
  save_objectives()
end

-- Add new objective
local function add_objective()
  vim.bo[M.buf].modifiable = true
  vim.ui.input({ prompt = "New objective: " }, function(input)
    if input and input ~= "" then
      local lines = vim.api.nvim_buf_get_lines(M.buf, 0, -1, false)
      table.insert(lines, "[ ] " .. input)
      vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
      save_objectives()
    end
    vim.bo[M.buf].modifiable = false
  end)
end

-- Edit mode toggle
local function toggle_edit_mode()
  if vim.bo[M.buf].modifiable then
    vim.bo[M.buf].modifiable = false
    save_objectives()
    print("Read-only mode")
  else
    vim.bo[M.buf].modifiable = true
    print("Edit mode - Press 's' to save")
  end
end

-- Open objectives panel
function M.open()
  -- Check if already open
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_set_current_win(M.win)
    return
  end

  -- Create or reuse buffer FIRST with proper setup
  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then
    M.buf = vim.api.nvim_create_buf(false, true)

    -- Set name first
    vim.api.nvim_buf_set_name(M.buf, "Objectives")

    -- Set buffer options
    vim.bo[M.buf].buftype = "nofile"
    vim.bo[M.buf].bufhidden = "hide"
    vim.bo[M.buf].swapfile = false
    vim.bo[M.buf].filetype = "objectives"

    -- Load and set objectives (buffer is still modifiable)
    local objectives = load_objectives()
    pcall(vim.api.nvim_buf_set_lines, M.buf, 0, -1, false, objectives)

    -- NOW make it read-only
    vim.bo[M.buf].modifiable = false
  end

  -- Create window and attach buffer
  vim.cmd("botright vsplit")
  vim.cmd("vertical resize 40")

  M.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(M.win, M.buf)

  -- Window settings
  vim.wo[M.win].number = false
  vim.wo[M.win].relativenumber = false
  vim.wo[M.win].signcolumn = "no"
  vim.wo[M.win].wrap = true

  -- Keymaps for the objectives buffer
  local opts = { buffer = M.buf, silent = true }
  vim.keymap.set("n", "<CR>", toggle_objective, opts)
  vim.keymap.set("n", "x", toggle_objective, opts)
  vim.keymap.set("n", "d", delete_line, opts)
  vim.keymap.set("n", "a", add_objective, opts)
  vim.keymap.set("n", "e", toggle_edit_mode, opts)
  vim.keymap.set("n", "s", save_objectives, opts)
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(M.win, true)
  end, opts)

  -- Return focus to previous window
  vim.cmd("wincmd p")
end

-- Close objectives panel
function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
end

-- Toggle objectives panel
function M.toggle()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    M.close()
  else
    M.open()
  end
end

-- Auto-open on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      M.open()
    end, 100)
  end,
})

-- Auto-close objectives panel when quitting
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    M.close()
  end,
})
-- Commands
vim.api.nvim_create_user_command("ObjectivesToggle", M.toggle, {})
vim.api.nvim_create_user_command("ObjectivesOpen", M.open, {})
vim.api.nvim_create_user_command("ObjectivesClose", M.close, {})
vim.api.nvim_create_user_command("ObjectiveAdd", add_objective, {})

-- Keymap to toggle
vim.keymap.set("n", "<leader>oo", M.toggle, { desc = "Toggle Objectives" })

return M
