--BASIC SETUP
--vim.o.termguicolors = true
--Encoding
vim.cmd("set encoding=utf-8")
vim.cmd("set fileencoding=utf-8")
vim.cmd("set fileencodings=utf-8")
--Fix backspace indent
vim.cmd("set backspace=indent,eol,start")
-- Status bar
vim.cmd("set laststatus=2")
--Visual settings
vim.cmd("syntax on")
vim.cmd("set ruler")
vim.cmd("set number")
vim.cmd("let no_buffers_menu=1")
vim.cmd("set wildmenu")
-- Modeline overrides
vim.cmd("set modeline")
vim.cmd("set modelines=10")
vim.cmd("set title")
vim.cmd('set titleold="Terminal"')
vim.cmd("set titlestring=%F")
vim.cmd('set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\\ (line\\ %l/%L,\\ col\\ %c)')
-- PERSONAL MAPPINGS --
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=0")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
-- Leader set to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "
--Enable hidden buffers
vim.cmd("set hidden")
--Searching
vim.cmd("set hlsearch")
vim.cmd("set incsearch")
vim.cmd("set ignorecase")
vim.cmd("set smartcase")

vim.cmd("set fileformats=unix,dos,mac")

if vim.fn.exists('$SHELL') == 1 then
    vim.o.shell = vim.fn.getenv('SHELL')
else
    vim.o.shell = '/bin/sh'
end
--Session management
vim.cmd('let g:session_directory = "~/.config/nvim/session"')
vim.cmd('let g:session_autoload = "no"')
vim.cmd('let g:session_autosave = "no"')
vim.cmd('let g:session_command_aliases = 1')
-- Copy and paste to system clipboard in visual, VISUAL LINE, normal modes
vim.keymap.set({ 'n', 'v', 'x' }, 'y', '"+y', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v', 'x' }, 'p', '"+p', { noremap = true, silent = true })
--Copy deletion to buffer first before deletion
vim.keymap.set({ 'n', 'v', 'x' }, 'd', '"+d', { noremap = true, silent = true })
-- Tabs
vim.keymap.set('n', '<Tab>', 'gt', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', 'gT', { noremap = true, silent = true })
vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })
-- Maintain visual mode when shifting
vim.keymap.set({ 'v', 'x' }, '<', '<gv', { noremap = true, silent = true })
vim.keymap.set({ 'v', 'x' }, '>', '>gv', { noremap = true, silent = true })
-- Clear search highlighting
vim.keymap.set('n', '<C-h>', ':nohlsearch', { noremap = true, silent = true })
