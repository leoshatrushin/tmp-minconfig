return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "Issafalcon/lsp-overloads.nvim", -- lsp view all overloads and signatures
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.signatureHelpProvider then
                        print("Setting up lsp-overloads")
                        require("lsp-overloads").setup(client, {
                            keymaps = {
                                previous_signature = "<C-m>",
                                next_signature = "<C-k>",
                            },
                        })
                    end
                end,
            })

            local lspconfig = require("lspconfig")
            require("mason").setup()
            require("mason-lspconfig").setup({
                handlers = {
                    function(server)
                        local config = {}
                        config.capabilities = require("cmp_nvim_lsp").default_capabilities() 
                        lspconfig[server].setup(config)
                    end,
                },
            })
        end,
    },
}
