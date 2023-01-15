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
	awful
		.titlebar(c, { font = beautiful.titlebar_font, position = beautiful.titlebar_position, size = beautiful.titlebar_size })
		:setup({
			{
				{
					{
						awful.titlebar.widget.minimizebutton(c),
						awful.titlebar.widget.maximizedbutton(c),
						awful.titlebar.widget.closebutton(c),
						layout = wibox.layout.fixed.vertical,
					},
					bg = x.color0,
					widget = wibox.container.background,
					shape = helpers.rrect(beautiful.border_radius),
				},
				margins = {
					right = dpi(5),
					left = dpi(5),
					top = dpi(8),
				},
				widget = wibox.container.margin,
			},
			nil,
			{
				{
					{
						awful.titlebar.widget.iconwidget(c),
						margins = dpi(4),
						widget = wibox.container.margin,
					},
					bg = x.color0,
					shape = helpers.rrect(beautiful.border_radius),
					widget = wibox.container.background,
				},
				margins = {
					left = dpi(5),
					right = dpi(5),
					bottom = dpi(8),
				},
				widget = wibox.container.margin,
			},

			layout = wibox.layout.align.vertical,
		})
end)
