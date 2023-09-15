local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local mysystray = wibox.widget.systray()
mysystray.base_size = beautiful.systray_icon_size

return wibox.widget({
	{
		{
			mysystray,
			top = dpi(7.25),
			left = dpi(5),
			right = dpi(7.5),
			widget = wibox.container.margin,
		},
		{
			require("ui.widgets.panel.battery_bar"),
			top = dpi(5),
      bottom = dpi(5),
			right = dpi(5),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
	},
	bg = x.color0,
	shape = helpers.rrect(beautiful.border_radius),
	widget = wibox.container.background,
})
