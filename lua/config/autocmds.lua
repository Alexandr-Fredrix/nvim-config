local yank_group = vim.api.nvim_create_augroup("HighlightOnYank", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = yank_group,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI" }, {
    group = autosave_group,
    callback = function(event)
        local buf = event.buf

        if not vim.api.nvim_buf_is_loaded(buf) then
            return
        end

        if vim.bo[buf].buftype ~= "" or vim.bo[buf].readonly or not vim.bo[buf].modifiable then
            return
        end

        if vim.api.nvim_buf_get_name(buf) == "" then
            return
        end

        if not vim.bo[buf].modified then
            return
        end

        pcall(vim.api.nvim_buf_call, buf, function()
            vim.cmd("silent! write")
        end)
    end,
})
