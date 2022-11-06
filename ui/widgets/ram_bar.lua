local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set colors
local active_color = {
    type = 'linear',
    from = {0, 0},
    to = {200}, -- replace with w,h later
    stops = {{0, x.color14}, {0.50, x.color4}}
}
local background_color = beautiful.ram_bar_background_color or "#222222"

local ram_bar = wibox.widget{
    max_value     = 100,
    value         = 50,
    forced_height = dpi(10),
    margins       = {
        top = dpi(8),
        bottom = dpi(8),
    },
    forced_width  = dpi(200),
    shape         = gears.shape.rounded_bar,
    bar_shape     = gears.shape.rounded_bar,
    color         = active_color,
    background_color = background_color,
    border_width  = 0,
    border_color  = beautiful.border_color,
    widget        = wibox.widget.progressbar,
}

awesome.connect_signal("evil::ram", function(used, total)
    local used_ram_percentage = 100 - ((used / total) * 100)
    ram_bar.value = used_ram_percentage
end)

return ram_bar