local wibox = require('wibox')
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local notif_header = wibox.widget {
    markup = 'Notification Center',
    font = beautiful.font_name .. " 15",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

return wibox.widget {
    {
        notif_header,
        nil,
        require("ui.widgets.control_center.notif-center.clear-all"),
        expand = "none",
        spacing = dpi(20),
        layout = wibox.layout.align.horizontal
    },
    require('ui.widgets.control_center.notif-center.build-notifbox'),

    spacing = dpi(20),
    layout = wibox.layout.fixed.vertical,
}
