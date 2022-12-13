local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local keys = require("keys")
local decorations = require("ui.decorations")

-- This decoration theme will round clients according to your theme's
-- border_radius value
-- decorations.enable_rounding()

-- Add a titlebar
client.connect_signal("request::titlebars", function(c)
    awful.titlebar(c, {font = beautiful.titlebar_font, position = beautiful.titlebar_position, size = beautiful.titlebar_size}) : setup {
        {
			{
				awful.titlebar.widget.minimizebutton(c),
				awful.titlebar.widget.maximizedbutton(c),
				awful.titlebar.widget.closebutton(c),
				spacing = dpi(1),
				layout  = wibox.layout.fixed.vertical
			},
			--margins = dpi(10),
			widget = wibox.container.margin
		},
		{
			--{
			--	{ -- Title
			--	align  = 'center',
			--	widget = awful.titlebar.widget.titlewidget(c)
			--	},
			--	layout = wibox.layout.flex.vertical
			--},
			widget = wibox.container.rotate,
			--direction = "east",
		},
		{
			{
      
        awful.titlebar.widget.iconwidget(c),
        spacing = dpi(1),
				layout  = wibox.layout.fixed.vertical
			},
			margins = dpi(6),
			widget = wibox.container.margin
		},
      layout = wibox.layout.align.vertical
    }
end)
