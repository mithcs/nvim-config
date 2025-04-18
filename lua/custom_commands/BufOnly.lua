local g = vim.g
local api = vim.api
local option = api.nvim_buf_get_option

function BufOnly()
    local del_non_modifiable = g.bufonly_delete_non_modifiable or false

    local cur = api.nvim_get_current_buf()

    local deleted, modified = 0, 0

    for _, n in ipairs(api.nvim_list_bufs()) do
        -- If the iter buffer is modified one, then don't do anything
        if option(n, "modified") then
            -- iter is not equal to current buffer
            -- iter is modifiable or del_non_modifiable == true
            -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
            modified = modified + 1
        elseif n ~= cur and (option(n, "modifiable") or del_non_modifiable) then
            api.nvim_buf_delete(n, {})
            deleted = deleted + 1
        end
    end

    print("BufOnly: " .. deleted .. " deleted buffer(s), " .. modified .. " modified buffer(s)")
end

vim.api.nvim_create_user_command('BufOnly', BufOnly, {})
