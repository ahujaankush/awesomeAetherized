local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local dash_center_cont = wibox.widget({
	{
		require("ui.widgets.dash_center.user"),
		require("ui.widgets.dash_center.sliders"),
		require("ui.widgets.dash_center.field_panel"),
		spacing = dpi(20),
		forced_width = beautiful.dash_center_width,
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.margin,
	margins = {
		bottom = dpi(20),
	},
})

screen.connect_signal("request::desktop_decoration", function(s)
	s.dash_center = awful.popup({
		screen = s,
		widget = dash_center_cont,
		placement = function(c)
			awful.placement.top_right(c, {
				margins = {
					top = beautiful.wibar_height + beautiful.useless_gap,
					right = beautiful.useless_gap,
				},
			})
		end,
		ontop = true,
		visible = false,
		bg = x.background,
		fg = x.foreground,
		opacity = beautiful.dash_center_opacity,
	})
end)

function dash_center_hide(s)
	s.dash_center.visible = false
end

function dash_center_show(s)
	s.dash_center.visible = true
end

function dash_center_toggle(s)
	if s.dash_center.visible then
		dash_center_hide(s)
	else
		dash_center_show(s)
	end
end
