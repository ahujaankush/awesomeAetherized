local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")

local color = x.color5;

local width = dpi(50)
local height = dpi(300)

local active_color_1 = {
    type = 'linear',
    from = {0, 0},
    to = {300},
    stops = {{0, x.color6}, {0.50, x.color4}}
}

local volume_icon = wibox.widget {
    {
        widget = wibox.widget.imagebox,
        --       image = gears.surface(beautiful.theme_assets.awesome_icon(512,
        --                                                                 x.color8,
        --                                                                x.background)),
        image = icons.getIcon("beautyline/devices/scalable/audio-headphones-symbolic.svg"),
        resize = true
    },
    margins = dpi(13),
    widget = wibox.container.margin
}

local volume_adjust = awful.popup({
    type = "notification",
    maximum_width = width,
    maximum_height = height,
    visible = false,
    ontop = true,
    widget = wibox.container.background,
    bg = "#00000000",
    placement = function(c)
        awful.placement.right(c, {margins = {right = 10}})
    end
})

local volume_bar = wibox.widget {
    bar_shape = gears.shape.rounded_rect,
    shape = gears.shape.rounded_rect,
    background_color = beautiful.notification_osd_indicator_bg,
    color = active_color_1,
    max_value = 100,
    value = 0,
    widget = wibox.widget.progressbar
}

local volume_ratio = wibox.widget {
    layout = wibox.layout.ratio.vertical,
    {
        {volume_bar, direction = "east", widget = wibox.container.rotate},
        top = dpi(20),
        left = dpi(20),
        right = dpi(20),
        widget = wibox.container.margin
    },
    volume_icon,
    nil
}

volume_ratio:adjust_ratio(2, 0.72, 0.28, 0)

volume_adjust.widget = wibox.widget {
    volume_ratio,
    shape = helpers.rrect(beautiful.border_radius),
    border_width = beautiful.border_width * 0,
    border_color = beautiful.border_color,
    bg = beautiful.notification_osd_bg,
    opacity = beautiful.notification_osd_opacity,
    widget = wibox.container.background
}

-- create a 3 second timer to hide the volume adjust
-- component whenever the timer is started
local hide_volume_adjust = gears.timer {
    timeout = 3,
    autostart = true,
    callback = function()
        volume_adjust.visible = false
        volume_bar.mouse_enter = false
    end
}

awesome.connect_signal("evil::volume", function(volume, muted)
    volume_bar.value = volume

    if muted == true then
        volume_icon.markup = "<span foreground='" .. color ..
                                 "'><b>ﳌ</b></span>"
        volume_bar.color = x.color8
    else
        if volume <= 50 then
            color = x.color5
            volume_icon.markup = "<span foreground='" .. color ..
            "'><b></b></span>"
        else
            color = x.color4
            volume_icon.markup = "<span foreground='" .. color ..
            "'><b></b></span>"
        end
        volume_bar.color = active_color_1
    end

    if volume_adjust.visible then
        hide_volume_adjust:again()
    else
        volume_adjust.visible = true
        hide_volume_adjust:start()
    end

end)
