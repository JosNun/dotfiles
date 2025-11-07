-- Go language-specific configuration
-- Only loads in regular Neovim (not VS Code)
-- Note: gopls LSP is configured in coding.lua

-- Auto-format and organize imports on save for Go files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- Organize imports
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
        end
      end
    end
    -- Format
    vim.lsp.buf.format({ async = false })
  end,
})

-- Set Go-specific editor options
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(event)
    -- Go uses tabs, not spaces
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false

    -- Go-specific keymaps
    local opts = { buffer = event.buf, noremap = true, silent = true }

    vim.keymap.set("n", "<leader>r", function()
      vim.cmd("!go run %")
    end, vim.tbl_extend("force", opts, { desc = "Go run current file" }))

    vim.keymap.set("n", "<leader>t", function()
      vim.cmd("!go test")
    end, vim.tbl_extend("force", opts, { desc = "Go test" }))

    vim.keymap.set("n", "<leader>b", function()
      local file = vim.fn.expand("%")
      if file:match("_test%.go$") then
        vim.cmd("!go test -c")
      else
        vim.cmd("!go build")
      end
    end, vim.tbl_extend("force", opts, { desc = "Go build/test compile" }))

    vim.keymap.set("n", "<leader>c", function()
      vim.cmd("!go test -cover")
    end, vim.tbl_extend("force", opts, { desc = "Go test coverage" }))
  end,
})

-- Return empty table since we're not defining any plugins here
return {}
