local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local rubato = require("modules.rubato")
local color = require("modules.color")

-- This decoration theme will round clients according to your theme's
-- border_radius value
require("ui.decorations").enable_rounding()

local createButton = function(c, coln, colh, fn)
	local btn = wibox.widget({
		forced_width = 12,
		forced_height = 12,
		bg = coln,
		shape = helpers.rrect(10),
		buttons = {
			awful.button({}, 1, function()
				fn(c)
			end),
		},
		widget = wibox.container.background,
	})
	local resize_anim = rubato.timed({
		pos = 12,
		duration = 0.12,
		easing = rubato.easing.linear,
		subscribed = function(pos)
			btn.forced_width = pos
		end,
	})
	local transition = color.transition(color.color({ hex = coln }), color.color({ hex = colh }), color.transition.HSLA)
	local transition_anim = rubato.timed({
		pos = 0,
		duration = 0.25,
		easing = rubato.easing.linear,
		subscribed = function(pos)
			btn:set_bg(transition(pos).hex)
		end,
	})
	btn:connect_signal("mouse::enter", function(_)
		resize_anim.target = 50
		transition_anim.target = 1
	end)
	btn:connect_signal("mouse::leave", function(_)
		resize_anim.target = 12
		transition_anim.target = 0
	end)
	return btn
end

-- Add a titlebar
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local close = createButton(c, x.color9, x.color1, function(c1)
		c1:kill()
	end)

	local maximize = createButton(c, x.color11, x.color3, function(c1)
		c1.maximized = not c1.maximized
	end)

	local minimize = createButton(c, x.color10, x.color2, function(c1)
		gears.timer.delayed_call(function()
			c1.minimized = not c1.minimized
		end)
	end)

	awful
		.titlebar(c, { font = beautiful.titlebar_font, position = beautiful.titlebar_position, size = beautiful.titlebar_size })
		:setup({
			{
				{
					{
						awful.titlebar.widget.iconwidget(c),
						margins = dpi(2),
						widget = wibox.container.margin,
					},
					bg = x.color8,
					shape = helpers.rrect(beautiful.border_radius),
					widget = wibox.container.background,
				},
				bottom = beautiful.border_width,
				widget = wibox.container.margin,
			},
			{
				{
					align = "left",
					valign = "center",
					widget = awful.titlebar.widget.titlewidget(c),
				},
				left = beautiful.border_width,
				widget = wibox.container.margin,
			},

			{
				{
					{
						{
							{
								close,
								maximize,
								minimize,
								spacing = dpi(10),
								widget = wibox.container.place,
								halign = "center",
								layout = wibox.layout.fixed.horizontal,
							},
							left = dpi(10),
							right = dpi(10),
							widget = wibox.container.margin,
						},
						widget = wibox.container.place,
						halign = "center",
					},
					bg = x.color8,
					shape = helpers.rrect(beautiful.border_radius),
					widget = wibox.container.background,
				},
				bottom = beautiful.border_width,
				widget = wibox.container.margin,
			},
			layout = wibox.layout.align.horizontal,
		})
end)
