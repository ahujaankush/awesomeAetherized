local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local playerctl = require("modules.bling").signal.playerctl.lib()

local create_button = function(symbol, color, command, playpause)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = "Material Icons Bold 18",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        icon,
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

    button:buttons(gears.table.join(awful.button({}, 1, function()
        command()
    end)))

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
    font = beautiful.font_name.." 12",
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    widget = wibox.widget.textbox
}

local artist_widget = wibox.widget {
    markup = 'No Artist',
    font = beautiful.font_name.." 11",
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    widget = wibox.widget.textbox
}

-- Get Song Info
playerctl:connect_signal("metadata", function(_, title, artist, art_path, _, _, _)
    if title == "" then
        title = "Not Playing"
    end

    title_widget:set_markup_silently('<span foreground="' .. x.foreground .. '">' .. title .. '</span>')
    artist_widget:set_markup_silently('<span foreground="' .. x.color7 .. '">' .. artist .. '</span>')
end)

local play_command = function()
    playerctl:play_pause()
end
local prev_command = function()
    playerctl:previous()
end
local next_command = function()
    playerctl:next()
end

local note_symbol = ""
local big_note = wibox.widget.textbox(note_symbol)
big_note.font = "Material Icons Bold 15"
big_note.align = "center"
big_note.markup = helpers.colorize_text(note_symbol, x.color4)
local small_note = wibox.widget.textbox()
small_note.align = "center"
small_note.markup = helpers.colorize_text(note_symbol, x.color13)
small_note.font = "Material Icons Bold 11"
-- small_note.valign = "bottom"
local double_note = wibox.widget {
    big_note,
    -- small_note,
    {
        small_note,
        top = dpi(11),
        widget = wibox.container.margin
    },
    spacing = dpi(-9),
    layout = wibox.layout.fixed.horizontal
}

local playerctl_play_symbol = wibox.widget {
    double_note,
    -- bg = "#00000000",
    widget = wibox.container.background
}
playerctl_play_symbol:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        playerctl:play_pause()
    end),
    awful.button({ }, 3, function ()
        playerctl:play_pause()
    end)
))

local playerctl_prev_symbol = create_button("", x.color14, prev_command, false)
local playerctl_next_symbol = create_button("", x.color14, next_command, false)

local playerctl_wibox = wibox.widget {

    {
        {
            nil,
            {
                playerctl_prev_symbol,
                playerctl_play_symbol,
                playerctl_next_symbol,
                spacing = dpi(15),
                layout = wibox.layout.fixed.horizontal
            },
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        {
            {
                title_widget,
                spacing = dpi(5),
                artist_widget,
                layout = wibox.layout.fixed.vertical
            },
            bottom = dpi(8),
            left = dpi(25),
            right = dpi(25),
            widget = wibox.container.margin
        },
        
        layout = wibox.layout.align.vertical
    },
    layout = wibox.layout.align.vertical
}

return playerctl_wibox
