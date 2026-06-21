return {
  {
    "mason-org/mason.nvim",
    opts = nil,
  },
  -- terraform-ls advertises LSP semantic tokens. For some .tf files its token
  -- payload drives neovim's tokens_to_ranges() (vim/lsp/semantic_tokens.lua)
  -- into a coroutine that re-schedules itself via vim.schedule and burns 100%
  -- of a core in str_utfindex(), pinning the editor's main loop. Disable
  -- semantic-token highlighting for terraform-ls to avoid the spin. (Other
  -- languages keep semantic tokens.)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("terraform_no_semantic_tokens", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "terraformls" then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })
      return opts
    end,
  },
}
