vim.opt.ignorecase = true
vim.opt.smartcase = true

if vim.g.vscode then
  -- VS Code specific configs
else
  -- 24 bit colors (may not need this?)
  vim.opt.termguicolors = true

  -- Line numbers
  vim.opt.number = true
  vim.opt.relativenumber = true

  -- Clipboard
  if vim.fn.has('unnamedplus') == 1 then
    vim.opt.clipboard:append('unnamed')
    vim.opt.clipboard:append('unnamedplus')
  end

  -- Persistent undo
  if vim.fn.has('persistent_undo') == 1 then
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.expand('~/.config/vim/tmp/undo//')
  end

  -- Save on build
  vim.opt.autowrite = true

  -- Indentation
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4

  -- Hide buffers instead of closing them
  vim.opt.hidden = true

  -- Visual aids
  vim.opt.colorcolumn = "80"
  vim.opt.cursorline = true

  vim.opt.mouse = 'a'

end
