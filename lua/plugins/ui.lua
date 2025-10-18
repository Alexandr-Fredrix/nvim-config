return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
            transparent = false,
            styles = {
                sidebars = "dark",
                floats = "dark",
            },
            lualine_bold = true,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = function()
            local builtin = require("telescope.builtin")
            return {
                { "<leader>ff", builtin.find_files, desc = "Find files" },
                { "<leader>fg", builtin.live_grep, desc = "Live grep project" },
                { "<leader>fb", builtin.buffers, desc = "List buffers" },
                { "<leader>fh", builtin.help_tags, desc = "Search help tags" },
            }
        end,
        opts = {
            defaults = {
                layout_strategy = "flex",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                prompt_prefix = "   ",
                selection_caret = " ",
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
        },
        config = function()
            require("nvim-tree").setup({
                disable_netrw = true,
                hijack_cursor = true,
                view = {
                    width = 28,
                    side = "left",
                },
                renderer = {
                    highlight_git = true,
                    highlight_opened_files = "all",
                    indent_markers = {
                        enable = true,
                    },
                },
                filters = {
                    dotfiles = false,
                },
                diagnostics = {
                    enable = true,
                    show_on_dirs = true,
                },
                git = {
                    enable = true,
                    ignore = false,
                },
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = function()
            return {
                options = {
                    theme = "tokyonight",
                    globalstatus = true,
                    icons_enabled = true,
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = { "alpha" },
                        winbar = { "alpha" },
                    },
                },
                sections = {
                    lualine_a = { { "mode", icon = "" } },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = {
                        {
                            "diagnostics",
                            symbols = { error = " ", warn = " ", info = " ", hint = " " },
                        },
                        {
                            function()
                                local clients = vim.lsp.get_clients({ bufnr = 0 })
                                if #clients == 0 then
                                    return "No LSP"
                                end
                                return clients[1].name
                            end,
                            icon = " ",
                        },
                        "encoding",
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { { "location", icon = "" } },
                },
            }
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "slant",
                    show_close_icon = false,
                    show_buffer_close_icons = false,
                    always_show_bufferline = false,
                    indicator = {
                        style = "underline",
                    },
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "Explorer",
                            text_align = "left",
                            separator = true,
                        },
                    },
                },
            })

            local map = vim.keymap.set
            map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
            map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
            for i = 1, 9 do
                map("n", ("<leader>%d"):format(i), ("<cmd>BufferLineGoToBuffer %d<CR>"):format(i), {
                    desc = ("Go to buffer %d"):format(i),
                })
            end
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({
                icons = { separator = "➜", group = "" },
                win = {
                    border = "rounded",
                    padding = { 1, 2, 1, 2 },
                },
                layout = {
                    align = "center",
                },
            })

            local leader_mappings = {
                { "<leader>", group = "Main shortcuts" },
                { "<leader>?", desc = "Show keymaps" },
                { "<leader>e", desc = "Toggle file tree" },
                { "<leader>f", group = "Search" },
                { "<leader>ff", desc = "Find files" },
                { "<leader>fg", desc = "Live grep project" },
                { "<leader>fb", desc = "List buffers" },
                { "<leader>fh", desc = "Search help" },
                { "<leader>t", group = "Terminal" },
                { "<leader>tt", desc = "Floating terminal" },
                { "<leader>tg", desc = "LazyGit UI" },
                { "<leader>g", group = "Git actions" },
                { "<leader>gs", desc = "Git status" },
                { "<leader>gc", desc = "Git commit" },
                { "<leader>gp", desc = "Git push" },
                { "<leader>b", group = "Buffers" },
                { "<leader>bn", desc = "New buffer" },
                { "<leader>bd", desc = "Close buffer" },
                { "<leader>c", group = "Comments" },
                { "<leader>cc", desc = "Toggle comment line" },
                { "<leader>cb", desc = "Toggle block comment" },
                { "<leader>w", group = "Write/Save" },
                { "<leader>ww", desc = "Save buffer" },
                { "<leader>q", group = "Quit" },
                { "<leader>qq", desc = "Quit Neovim" },
                { "<leader>h", group = "Git hunks" },
                { "<leader>hs", desc = "Stage hunk" },
                { "<leader>hr", desc = "Reset hunk" },
                { "<leader>hp", desc = "Preview hunk" },
                { "<leader>hb", desc = "Show blame" },
            }
            for i = 1, 9 do
                table.insert(leader_mappings, { ("<leader>%d"):format(i), desc = ("Go to buffer %d"):format(i) })
            end
            wk.add(leader_mappings)

            wk.add({
                { "<leader>cc", desc = "Toggle comment line" },
                { "<leader>cb", desc = "Toggle block comment" },
            }, { mode = { "n", "v" } })

            wk.add({
                { "<S-l>", desc = "Next buffer" },
                { "<S-h>", desc = "Previous buffer" },
            }, { mode = "n" })
        end,
    },
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            local header = {
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣶⣶⣿⣿⣭⣼⣒⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠛⠛⠛⠻⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⢈⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣷⡄⠀⠀⠀⠀⣿⣷⢠⣶⣦⣤⣿⣿⣿⣿⣿⣿⣿⡧⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⡉⠻⣿⣿⣿⣿⣦⠀⠀⠸⠀⢡⣌⠉⠙⠛⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⢮⣝⣿⣛⣿⣷⡀⢰⢃⡿⡿⠃⠀⣼⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠞⠉⢿⣿⣿⣿⡌⡞⠛⠛⠛⢛⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠋⠀⠀⣀⣸⣿⡿⠋⠀⢇⠀⢀⣠⣾⣿⣿⢟⣫⣽⣿⣿⣿⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠊⠁⢀⣠⠔⠛⠉⠀⠀⠀⠀⠀⣀⡽⠛⠛⠋⣩⣾⣿⠿⠃⠀⠈⠓⢦⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠋⢀⡤⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠚⠋⠁⠀⠀⠀⠀⠀⠀⠀⠱⡄⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠎⠙⡉⠁⡠⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠸⡄⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠊⢀⣠⣾⣿⠇⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣿⣿⣦⡀⠀⠀⠹⡄⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⡠⠃⣰⣿⣿⣿⣯⣤⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡎⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣿⣿⣿⣿⣿⣷⣤⠀⠀⢳⠀",
                "⠀⠀⠀⠀⠀⠀⡠⠊⢀⣰⣿⣿⣿⣿⣿⠟⠢⣄⠀⠀⠀⠀⠀⢀⣀⣠⠤⠚⠀⠀⠀⠀⣠⣤⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣄⠀⢇",
                "⠀⠀⠀⢀⡴⠊⠀⣠⣾⣿⣿⣿⣿⣿⡿⠀⠀⠀⠑⠦⠤⠤⠴⠋⠀⠀⠀⠀⢀⣀⣀⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢂⣞",
                "⠀⢀⡴⠋⠀⢀⣼⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⣀⣄⠀⠀⣐⠛⠛⢛⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿",
                "⣴⣋⣀⣀⣠⣾⣿⣿⠿⠛⠛⠋⠉⠀⠀⠀⠀⠀⢀⣀⣤⣴⣾⣿⣧⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
            }

            dashboard.section.header.val = header
            dashboard.section.header.opts = { position = "center", hl = "AlphaHeader" }

            local function button(shortcut, icon, text, command)
                return dashboard.button(shortcut, string.format("%s  %s", icon, text), command)
            end

            dashboard.section.buttons.val = {
                button("f", "", "Find file", ":Telescope find_files<CR>"),
                button("n", "", "New file", ":ene <BAR> startinsert<CR>"),
                button("p", "", "Find project", ":lua require('telescope.builtin').git_files()<CR>"),
                button("r", "", "Recent files", ":Telescope oldfiles<CR>"),
                button("t", "", "Find text", ":Telescope live_grep<CR>"),
                button("c", "", "Config", ":e ~/.config/nvim/init.lua<CR>"),
                button("q", "", "Quit", ":qa<CR>"),
            }
            dashboard.section.buttons.opts = { spacing = 0, position = "center" }

            local function footer()
                local stats = require("lazy").stats()
                return string.format("Loaded %d/%d plugins in %.2fms", stats.loaded, stats.count, stats.startuptime)
            end

            dashboard.section.footer.val = footer()
            dashboard.section.footer.opts = { position = "center", hl = "AlphaFooter" }

            local saved_laststatus

            dashboard.opts.opts = dashboard.opts.opts or {}
            dashboard.opts.opts.noautocmd = true
            dashboard.opts.opts.on_open = function()
                saved_laststatus = vim.opt.laststatus:get()
                vim.opt.laststatus = 0
            end
            dashboard.opts.opts.on_close = function()
                vim.opt.laststatus = saved_laststatus or 3
            end

            alpha.setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyDone",
                callback = function()
                    dashboard.section.footer.val = footer()
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })

            vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#ff9e64" })
            vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#7aa2f7", italic = true })
            vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#bb9af7" })

            for _, btn in ipairs(dashboard.section.buttons.val) do
                btn.opts.hl = "AlphaButtons"
                btn.opts.hl_shortcut = "AlphaButtons"
                btn.opts.opts = btn.opts.opts or {}
                btn.opts.opts.position = "center"
            end
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "契" },
                topdelete = { text = "契" },
                changedelete = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("n", "]h", gs.next_hunk, "Next hunk")
                map("n", "[h", gs.prev_hunk, "Prev hunk")
                map({ "n", "v" }, "<leader>hs", gs.stage_hunk, "Stage hunk")
                map({ "n", "v" }, "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, "Blame line")
            end,
        },
    },
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            toggler = {
                line = "<leader>cc",
                block = "<leader>cb",
            },
            opleader = {
                line = "<leader>cc",
                block = "<leader>cb",
            },
            mappings = {
                basic = false,
                extra = false,
            },
        },
        config = function(_, opts)
            require("Comment").setup(opts)
            local api = require("Comment.api")

            pcall(vim.keymap.del, "n", "gc")
            pcall(vim.keymap.del, "n", "gcc")
            pcall(vim.keymap.del, "n", "gbc")
            pcall(vim.keymap.del, "v", "gc")
            pcall(vim.keymap.del, "v", "gb")

            vim.keymap.set("n", "<leader>cc", function()
                api.toggle.linewise.current()
            end, { desc = "Toggle comment line" })

            vim.keymap.set("v", "<leader>cc", function()
                local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
                vim.api.nvim_feedkeys(esc, "nx", false)
                api.toggle.linewise(vim.fn.visualmode())
            end, { desc = "Toggle comment selection" })

            vim.keymap.set("n", "<leader>cb", function()
                api.toggle.blockwise.current()
            end, { desc = "Toggle block comment" })

            vim.keymap.set("v", "<leader>cb", function()
                local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
                vim.api.nvim_feedkeys(esc, "nx", false)
                api.toggle.blockwise(vim.fn.visualmode())
            end, { desc = "Toggle block comment selection" })
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal" },
        },
        cmd = { "ToggleTerm", "TermExec" },
        config = function()
            require("toggleterm").setup({
                open_mapping = nil,
                direction = "float",
                shade_terminals = true,
                shading_factor = 2,
                float_opts = {
                    border = "curved",
                    winblend = 5,
                },
                winbar = {
                    enabled = true,
                    name_formatter = function(term)
                        return "  " .. term.name
                    end,
                },
                on_open = function()
                    vim.cmd("startinsert")
                end,
                on_close = function()
                    vim.cmd("stopinsert")
                end,
            })

            local Terminal = require("toggleterm.terminal").Terminal

            vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
            vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Move left" })
            vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Move down" })
            vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Move up" })
            vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Move right" })

            vim.keymap.set("n", "<leader>tg", function()
                local lazygit = Terminal:new({
                    cmd = "lazygit",
                    hidden = true,
                    direction = "float",
                })
                lazygit:toggle()
            end, { desc = "LazyGit UI" })
        end,
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit" },
        keys = {
            { "<leader>gs", "<cmd>Git status<CR>", desc = "Git status" },
            { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
            { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
        },
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "echasnovski/mini.icons",
        version = "*",
        config = true,
        lazy = true,
    },
}
