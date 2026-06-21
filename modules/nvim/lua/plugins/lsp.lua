return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        mpls = {
          cmd = {
            "mpls",
            "--no-auto",
            "--theme",
            "dark",
            "--enable-emoji",
            "--enable-footnotes",
          },
          on_attach = function(client, bufnr)
            if not client._mpls_focus_tracking then
              local group = vim.api.nvim_create_augroup("mpls-focus-" .. client.id, { clear = true })

              vim.api.nvim_create_autocmd("BufEnter", {
                group = group,
                pattern = "*.md",
                callback = function(ctx)
                  local uri = vim.uri_from_fname(vim.api.nvim_buf_get_name(ctx.buf))
                  client:notify("mpls/editorDidChangeFocus", { uri = uri })
                end,
                desc = "mpls: notify buffer focus changed",
              })

              client._mpls_focus_tracking = true
            end

            vim.api.nvim_buf_create_user_command(bufnr, "LspMplsOpenPreview", function()
              client:exec_cmd({
                title = "Preview markdown with mpls",
                command = "open-preview",
              })
            end, { desc = "Preview markdown with mpls" })

            vim.keymap.set("n", "<leader>mp", "<cmd>LspMplsOpenPreview<cr>", {
              buffer = bufnr,
              desc = "Markdown Preview",
            })
          end,
        },
      },
    },
  },
}
