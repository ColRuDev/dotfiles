local keymap = vim.keymap.set

vim.g.mapleader = ""

-- Search using snacks picker
vim.keymap.set("v", "<leader>sg", function()
  -- Get the selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return
  end

  -- Handle single line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    -- Handle multi-line selection
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local selected_text = table.concat(lines, "\n")

  -- Escape special characters for grep
  selected_text = vim.fn.escape(selected_text, "\\.*[]^$()+?{}")

  -- Use the selected text for grep
  if pcall(require, "snacks") then
    require("snacks").picker.grep({ search = selected_text })
  elseif pcall(require, "fzf-lua") then
    require("fzf-lua").live_grep({ search = selected_text })
  else
    vim.notify("No grep picker available", vim.log.levels.ERROR)
  end
end, { desc = "Grep Selected Text" })

-- Grep keybinding for visual mode with G - search selected text at root level
vim.keymap.set("v", "<leader>sG", function()
  -- Get git root or fallback to cwd
  local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  local root = vim.v.shell_error == 0 and git_root ~= "" and git_root or vim.fn.getcwd()

  -- Get the selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return
  end

  -- Handle single line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    -- Handle multi-line selection
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local selected_text = table.concat(lines, "\n")

  -- Escape special characters for grep
  selected_text = vim.fn.escape(selected_text, "\\.*[]^$()+?{}")

  -- Use the selected text for grep at root level
  if pcall(require, "snacks") then
    require("snacks").picker.grep({ search = selected_text, cwd = root })
  elseif pcall(require, "fzf-lua") then
    require("fzf-lua").live_grep({ search = selected_text, cwd = root })
  else
    vim.notify("No grep picker available", vim.log.levels.ERROR)
  end
end, { desc = "Grep Selected Text (Root Dir)" })

keymap("i", "jk", "<ESC>")

-- Move between windows with Ctrl + h,j,k,l
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")
