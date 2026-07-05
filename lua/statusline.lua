local severities = {
    { vim.diagnostic.severity.ERROR, '' },
    { vim.diagnostic.severity.WARN,  '' },
    { vim.diagnostic.severity.INFO,  '' },
    { vim.diagnostic.severity.HINT,  '' },
}

function show_lsp_status()
    if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
        return ''
    end

    local progress = vim.lsp.status()
    if progress ~= '' then
        return progress
    end

    local parts = {}
    local counts = vim.diagnostic.count(0)
    for _, sev in ipairs(severities) do
        local n = counts[sev[1]]
        if n and n > 0 then
            table.insert(parts, sev[2] .. ' ' .. n)
        end
    end

    if #parts == 0 then
        return ''
    end
    return table.concat(parts, ' ')
end

vim.api.nvim_create_autocmd({ 'LspProgress', 'DiagnosticChanged' }, {
    command = 'redrawstatus',
})

vim.o.statusline = "%{%v:lua.show_lsp_status()%}"
