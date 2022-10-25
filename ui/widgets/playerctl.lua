local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local playerctl = require("modules.bling").signal.playerctl.lib()

local art = wibox.widget {
    image = gears.filesystem.get_configuration_dir() .. "icons/music.png",
    resize = true,
    widget = wibox.widget.imagebox
}

local create_button = function(symbol, color, command, playpause)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = beautiful.font_name .. "14",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        icon,
        forced_height = dpi(15),
        forced_width = dpi(15),
        widget = wibox.container.background
    }

    playerctl:connect_signal("playback_status", function(_, playing, _)
        if playpause then
            if playing then
                icon.markup = helpers.colorize_text("", color)
            else
                icon.markup = helpers.colorize_text("", color)
            end
        end
    end)

    button:buttons(gears.table.join(
                       awful.button({}, 1, function() command() end)))

    button:connect_signal("mouse::enter", function()
        icon.markup = helpers.colorize_text(icon.text, x.foreground)
    end)

    button:connect_signal("mouse::leave", function()
        icon.markup = helpers.colorize_text(icon.text, color)
    end)

    return button
end

local title_widget = wibox.widget {
    markup = 'No Title',
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    widget = wibox.widget.textbox
}

local artist_widget = wibox.widget {
    markup = 'No Artist',
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    widget = wibox.widget.textbox
}

-- Get Song Info
playerctl:connect_signal("metadata",
                         function(_, title, artist, art_path, _, _, _)
    if title == "" then title = "Not Playing" end

    -- Set art widget
    art:set_image(gears.surface.load_uncached(art_path))

    title_widget:set_markup_silently(
        '<span foreground="' .. x.color5 .. '">' .. title .. '</span>')
    artist_widget:set_markup_silently(
        '<span foreground="' .. x.color6 .. '">' .. artist .. '</span>')
end)

local play_command = function() playerctl:play_pause() end
local prev_command = function() playerctl:previous() end
local next_command = function() playerctl:next() end

local playerctl_play_symbol = create_button("", x.color4,
                                            play_command, true)

local playerctl_prev_symbol = create_button("玲", x.color4,
                                            prev_command, false)
local playerctl_next_symbol = create_button("怜", x.color4,
                                            next_command, false)

local slider = wibox.widget {
    forced_height = dpi(3),
    bar_shape = helpers.rrect(beautiful.border_radius),
    shape = helpers.rrect(beautiful.border_radius),
    background_color = x.color0 .. 55,
    color = x.color6,
    value = 25,
    max_value = 100,
    widget = wibox.widget.progressbar
}

playerctl:connect_signal("position", function(_, pos, length, _)
    slider.value = (pos / length) * 100
end)

local playerctl_wibox = wibox.widget {
    {
        art,
        bg = x.color0,
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox.container.background
    },
    {
        {
            {title_widget, artist_widget, layout = wibox.layout.fixed.vertical},
            top = dpi(10),
            left = dpi(25),
            right = dpi(25),
            widget = wibox.container.margin
        },
        {
            nil,
            {
                playerctl_prev_symbol,
                playerctl_play_symbol,
                playerctl_next_symbol,
                spacing = dpi(40),
                layout = wibox.layout.fixed.horizontal
            },
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        {
            slider,
            bottom = dpi(10),
            left = dpi(25),
            right = dpi(25),
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.vertical
    },
    layout = wibox.layout.align.horizontal
}

return playerctl_wibox
