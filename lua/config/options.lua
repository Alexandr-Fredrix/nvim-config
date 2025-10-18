local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.termguicolors = true
opt.wrap = true
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 4
opt.expandtab = false
opt.smartindent = true
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.updatetime = 200
opt.laststatus = 3

vim.diagnostic.config({
    float = { border = "rounded" },
})
