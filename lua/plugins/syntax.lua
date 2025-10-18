return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "yaml",
                "json",
                "dockerfile",
                "html",
                "css",
                "python",
                "go",
                "gomod",
                "gotmpl",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    { "towolf/vim-helm", ft = { "helm", "gotmpl" } },
    { "pearofducks/ansible-vim", ft = { "yaml.ansible", "ansible", "yaml" } },
}
