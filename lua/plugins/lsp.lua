return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "b0o/schemastore.nvim",
        },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local schemastore = require("schemastore")

            mason.setup()

            local yaml_schemas = schemastore.yaml.schemas({
                select = {
                    "Ansible Playbook",
                    "Ansible Tasks File",
                    "Ansible Vars File",
                    "Ansible Inventory",
                    "docker-compose.yml",
                },
                extra = {
                    {
                        name = "Kubernetes",
                        description = "Kubernetes",
                        fileMatch = {
                            "*.k8s.yaml",
                            "*.k8s.yml",
                            "*.kubernetes.yaml",
                            "*.kubernetes.yml",
                            "k8s/**/*.yaml",
                            "kubernetes/**/*.yaml",
                        },
                        url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
                    },
                },
            })

            local servers = {
                ansiblels = {},
                dockerls = {},
                yamlls = {
                    settings = {
                        yaml = {
                            schemaStore = {
                                enable = false,
                                url = "",
                            },
                            schemas = yaml_schemas,
                            keyOrdering = false,
                        },
                    },
                },
                html = {},
                cssls = {},
                pyright = {},
                gopls = {},
                helm_ls = {
                    settings = {
                        ["helm-ls"] = {
                            yamlls = {
                                path = "yamlls",
                            },
                        },
                    },
                },
            }

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_enable = false,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(client, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                end

                map("gd", vim.lsp.buf.definition, "Go to definition")
                map("gr", vim.lsp.buf.references, "List references")
                map("gi", vim.lsp.buf.implementation, "Go to implementation")
                map("K", vim.lsp.buf.hover, "Hover documentation")
                map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("<leader>fd", vim.diagnostic.open_float, "Line diagnostics")
                map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next diagnostic")

                vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                    vim.lsp.buf.format({ async = true })
                end, { desc = "Format current buffer with LSP" })

                if client and ((client.supports_method and client:supports_method("textDocument/formatting"))
                        or client.server_capabilities.documentFormattingProvider) then
                    local format_group = vim.api.nvim_create_augroup("LspFormatOnSave" .. bufnr, { clear = true })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = format_group,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
                        end,
                    })
                end
            end

            for server_name, server_opts in pairs(servers) do
                local opts = vim.tbl_deep_extend("force", {}, server_opts, {
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
                vim.lsp.config(server_name, opts)
                vim.lsp.enable(server_name)
            end
        end,
    },
}
