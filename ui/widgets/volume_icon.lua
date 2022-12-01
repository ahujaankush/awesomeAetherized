local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")
local currentVol = 50
local volume_icon_text_icon = helpers.colorize_text("墳", x.color6)
local volume_icon = wibox.widget {
    widget = wibox.widget.textbox,
    --       image = gears.surface(beautiful.theme_assets.awesome_icon(512,
    --                                                                 x.color8,
    --                                                                x.background)),
    markup = volume_icon_text_icon,
    font = beautiful.font_name .. " 20",
    resize = true
}

local volume_icon_container = wibox.widget {
    {

        volume_icon,
        widget = wibox.container.margin,
        margins = dpi(12)
    },
    widget = wibox.container.background
}

local volume_icon_tooltip = awful.tooltip {};
volume_icon_tooltip.preferred_alignments = {"middle", "front", "back"}
volume_icon_tooltip.mode = "outside"
volume_icon_tooltip:add_to_object(volume_icon_container)
volume_icon_tooltip.markup = helpers.colorize_text(currentVol, x.color13)

awesome.connect_signal("evil::volume", function(value, muted)
    local textColor = x.color6
    local mutedColor = x.color14


    if muted then
        volume_icon_text_icon = helpers.colorize_text("ﱝ", x.color1)
        textColor = x.color1
    elseif value <= 10 then
        volume_icon_text_icon = helpers.colorize_text("", x.color3)
        textColor = x.color3
    elseif value <= 30 then
        volume_icon_text_icon = helpers.colorize_text("", x.color11)
        textColor = x.color11
    elseif value <= 60 then
        volume_icon_text_icon = helpers.colorize_text("墳", x.color6)
        textColor = x.color6
    elseif value <= 90 then
        volume_icon_text_icon = helpers.colorize_text("", x.color4)
        textColor = x.color4
    else
        volume_icon_text_icon = helpers.colorize_text("", x.color5)
        textColor = x.color5
    end

    volume_icon.markup = volume_icon_text_icon
    currentVol = value

    volume_icon_tooltip.markup = helpers.colorize_text(currentVol, textColor)
end)

volume_icon_container:connect_signal("button::press", function()
    helpers.volume_control(0)
--    volume_icon_container.bg = x.color0
end)

-- volume_icon_container:connect_signal("button::release", function()
--     volume_icon_container.bg = x.background .. "00"
-- end)

return volume_icon_container

