local status, lualine = pcall(require, "lualine")
if not status then
    return
end

local colors = {
    green = '#86CAC1'
}

local lualine_theme = require("lualine.themes.nightfly")

lualine_theme.insert.a.bg = colors.green

lualine.setup({
    options = {
        theme = lualine_theme
    }
})
