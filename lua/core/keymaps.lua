-- Define keymaps of Neovim and installed plugins

---An abbreviation of *vim.keymap.set*(`mode`, `lhs`, `rhs`, opts) with
---```lua
---    opts = { noremap = true, silent = true }
---```
---@param m string | table[string]
---@param l string
---@param r string | function
---@param desc string
local function map(m, l, r, desc)
    vim.keymap.set(m, l, r, { noremap = true, silent = true, desc = desc })
end

-- --------------------- --------------------- ---------------------

-- Remove mapped '.'
map('n', '.', '<Nop>', 'No Operation')
-- Change leader to '.'
vim.g.mapleader = '.'

-- --------------------- --------------------- ---------------------

-- Neovim Shortcuts

-- Remove annoyance
map('n', '<C-.>', '<Nop>', 'No Operation')
map('i', '<C-.>', '<Nop>', 'No Operation')

-- Buffer mappings
map('n', '<Space>n', ':bn<CR>', 'Next Buffer')
map('n', '<Space>p', ':bp<CR>', 'Prev Buffer')
map('n', '<Space>c', ':BufOnly<CR>', 'Keep Only Curr Buf')

-- Close easily
map('n', '<Space>d', ':close<CR>', 'Delete Curr Buf')

-- Create Split
map('n', '<leader>s', ':split<CR>', 'Horizontal Split')
map('n', '<leader>vs', ':vsplit<CR>', 'Vertical Split')

-- Stay sane
map('i', 'jk', '<ESC>', 'Normal Mode')

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h', 'Goto Left Split')
map('n', '<C-k>', '<C-w>k', 'Goto Top Split')
map('n', '<C-l>', '<C-w>l', 'Goto Right Split')
map('n', '<C-j>', '<C-w>j', 'Goto Bottom Split')

-- Windows resizing
map('n', '<C-Up>', ':resize +2<CR>', '+ Resize Horizontal Split')
map('n', '<C-Down>', ':resize -2<CR>', '- Resize Horizontal Split')
map('n', '<C-Left>', ':vertical resize +2<CR>', '+ Resize Vertical Split')
map('n', '<C-Right>', ':vertical resize -2<CR>', '- Resize Vertical Split')

-- Reload configuration without restart nvim
map('n', '<leader>r', ':so %<CR>', 'Reload Configuration')

-- Fast saving with <leader> and w
map('n', '<leader>w', ':w<CR>', 'Save')

-- Spell check
map('n', '<F12>', ':setlocal spell! spelllang=en<CR>', 'Toggle Spell Check')

-- Move line up or down
map('n', '<A-j>', ':m+<CR>', 'Move Line Up')
map('n', '<A-k>', ':m--<CR>', 'Move Line Down')

-- Set parent directory as root
map('n', '<leader>R', ':cd %:h<CR>', 'Set Parent Dir as Root')

-- Go to config file
map('n', '<leader><leader><leader>', ':e $MYVIMRC<CR>', 'Open Config File')

-- Terminal mappings
map('n', '<leader>t', ':terminal<CR>', 'Open Terminal')
map('t', 'jk', '<C-\\><C-n>', 'Normal Mode')

-- to move around splits
map('t', '<C-h>', '<C-\\><C-n><C-w>h', 'Goto Left Split')
map('t', '<C-j>', '<C-\\><C-n><C-w>j', 'Goto Bottom Split')
-- map('t', '<C-k>', '<C-\\><C-n><C-w>k')
-- map('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- Indent entire file
-- map('n', '<leader>=', 'gg=G\'\'', 'Indent Current File')

map('n', 'tc',
    function()
        vim.wo.colorcolumn = (vim.wo.colorcolumn == '81' and '0' or '81')
        print('Colorcolumn: ' .. (vim.wo.colorcolumn == '81' and 'true' or 'false'))
    end,
    'Toggle Colorcolumn'
)
