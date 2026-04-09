-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if the lazy.nvim plugin is not already installed
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
-- import your plugins
  spec = {
    -- Add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- theme with transparency support
    { 'projekt0n/github-nvim-theme', name = 'github-theme', priority = 1000 },

    -- Search files
    { import = "lazyvim.plugins.extras.editor.snacks_picker" },

    -- Formatting plugins
    { import = "lazyvim.plugins.extras.lang.typescript.biome" },

    -- Linting plugins
    { import = "lazyvim.plugins.extras.linting.eslint" },

    -- Coding plugins
    { import = "lazyvim.plugins.extras.coding.mini-surround" }, -- Surround text with brackets/quotes
    { import = "lazyvim.plugins.extras.editor.mini-diff" }, -- Git blame
    { import = "lazyvim.plugins.extras.coding.blink" }, -- auto-completion
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" }, -- highlights text patterns
    -- AI plugins
    { import = "lazyvim.plugins.extras.ai.copilot" },
  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
