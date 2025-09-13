-- ----------------------------------------------------------------------
-- Plugin Manager (Lazy.nvim)
-- ----------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ========== UI / THEMES ==========
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine" },
  { "EdenEast/nightfox.nvim" },
  { "EdenEast/nightfox.nvim" }, -- for carbonfox
  { "folke/tokyonight.nvim" },  -- for tokyonight
  { "ellisonleao/gruvbox.nvim" }, -- for gruvbox

  { "xiyaowong/transparent.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Rainbow brackets + indent guides
  { "HiPhish/rainbow-delimiters.nvim" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- ========== LSP + Autocompletion ==========
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- ========== UX ==========
  { "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } },
  { "folke/which-key.nvim" },
  { "goolord/alpha-nvim" }, -- Dashboard
  { "utilyre/barbecue.nvim", dependencies = { "SmiteshP/nvim-navic" } },
  { "karb94/neoscroll.nvim" }, -- smooth scrolling
  { "akinsho/toggleterm.nvim" },
	
  -- ========== Envs ==========
  { "kmontocam/nvim-conda", dependencies = { "nvim-lua/plenary.nvim" } },

  -- ========== Discord Rich Presence ==========
  { "IogaMaster/neocord" },
})

-- ----------------------------------------------------------------------
-- General Settings
-- ----------------------------------------------------------------------
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.guifont = "JetBrainsMono Nerd Font:h14"

-- ----------------------------------------------------------------------
-- Transparency
-- ----------------------------------------------------------------------
require("transparent").setup({
  groups = { "Normal", "NormalNC", "NormalFloat", "FloatBorder", "NvimTreeNormal" },
  extra_groups = { "BufferLineTabClose", "BufferLineBufferSelected" },
  exclude = {},
})

-- ----------------------------------------------------------------------
-- Bufferline
-- ----------------------------------------------------------------------
require("bufferline").setup({
  options = {
    separator_style = "slant",
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = true,
    show_close_icon = false,
  }
})

-- ----------------------------------------------------------------------
-- Lualine
-- ----------------------------------------------------------------------
require("lualine").setup({
  options = {
    theme = "carbonfox",
    section_separators = { "", "" },
    component_separators = { "", "" },
    globalstatus = true,
  },
})

-- ----------------------------------------------------------------------
-- NvimTree
-- ----------------------------------------------------------------------
require("nvim-tree").setup({
  view = { width = 30, side = "left" },
  renderer = { highlight_git = true, icons = { show = { folder_arrow = true } } },
})

-- ----------------------------------------------------------------------
-- Telescope
-- ----------------------------------------------------------------------
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })

-- ----------------------------------------------------------------------
-- Treesitter
-- ----------------------------------------------------------------------
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "go", "bash", "json", "yaml" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- ----------------------------------------------------------------------
-- Mason + LSP Config
-- ----------------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "basedpyright", "gopls" },
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.basedpyright.setup({ capabilities = capabilities })
lspconfig.gopls.setup({ capabilities = capabilities })

-- ----------------------------------------------------------------------
-- Autocompletion
-- ----------------------------------------------------------------------
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- ----------------------------------------------------------------------
-- Noice + Notify + Which-key
-- ----------------------------------------------------------------------
require("noice").setup()
require("which-key").setup()
vim.notify = require("notify")

-- ----------------------------------------------------------------------
-- Alpha Dashboard
-- ----------------------------------------------------------------------
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
  "███████╗██╗   ██╗██████╗ ██████╗ ██╗ ██████╗ ",
  "██╔════╝██║   ██║██╔══██╗██╔══██╗██║██╔═══██╗",
  "█████╗  ██║   ██║██████╔╝██████╔╝██║██║   ██║",
  "██╔══╝  ██║   ██║██╔═══╝ ██╔═══╝ ██║██║   ██║",
  "██║     ╚██████╔╝██║     ██║     ██║╚██████╔╝",
  "╚═╝      ╚═════╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝ ",
}
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
  dashboard.button("r", "  Recent", ":Telescope oldfiles<CR>"),
  dashboard.button("g", "  Live grep", ":Telescope live_grep<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}
alpha.setup(dashboard.opts)

-- ----------------------------------------------------------------------
-- Smooth Scrolling
-- ----------------------------------------------------------------------
require("neoscroll").setup()

-- ----------------------------------------------------------------------
-- Barbecue (winbar like VSCode)
-- ----------------------------------------------------------------------
require("barbecue").setup()

-- ----------------------------------------------------------------------
-- Neocord (Discord RPC)
-- ----------------------------------------------------------------------
require("neocord").setup({
  logo = "auto", -- use auto or "neovim"
  logo_tooltip = "The One True Editor",
  main_image = "file", -- "file" or "neovim"
  show_time = true,
  editing_text = "Editing %s",
  workspace_text = "Working on %s",
  file_explorer_text = "Browsing %s",
})

-- ----------------------------------------------------------------------
-- Neovide GPU Config (if using Neovide)
-- ----------------------------------------------------------------------
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.8
  vim.g.neovide_cursor_vfx_mode = "railgun"
end

-- List of dark themes
local themes = { "carbonfox", "tokyonight-storm", "gruvbox" }
local current = 1

-- Function to toggle themes
function ToggleTheme()
  current = current % #themes + 1
  vim.cmd("colorscheme " .. themes[current])
  print("Theme: " .. themes[current])
end

-- Keymap: <leader>tt to toggle theme
vim.keymap.set("n", "<leader>tt", ToggleTheme, { desc = "Toggle Theme" })

-- ----------------------------------------------------------------------
-- Theme setup
-- ----------------------------------------------------------------------
vim.cmd.colorscheme("carbonfox")

