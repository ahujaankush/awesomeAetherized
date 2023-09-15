local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local profile = require("ui.widgets.control_center.profile")
local stats = require("ui.widgets.control_center.stats")
local search = require("ui.widgets.control_center.search")
local music = require("ui.widgets.control_center.music")
local taw = require("ui.widgets.control_center.taw")
local notifbox = require("ui.widgets.control_center.notifs.box")

awful.screen.connect_for_each_screen(function(s)
	local main = wibox.widget({
		{
			profile,
			{
				taw,
				stats,
				spacing = 16,
				layout = wibox.layout.fixed.horizontal,
			},
			music,
			spacing = 20,
			layout = wibox.layout.fixed.vertical,
		},
		notifbox,
		spacing = 20,
		visible = true,
		layout = wibox.layout.fixed.horizontal,
	})

	s.dashboard = awful.popup({
		screen = s,
		widget = {
			{
				{
					nil,
					search,
					layout = wibox.layout.align.horizontal,
				},
				main,
				layout = wibox.layout.fixed.vertical,
				spacing = 20,
			},
			margins = dpi(25),
			widget = wibox.container.margin,
		},
		placement = function(c)
			awful.placement.top(c, {
				margins = {
					top = beautiful.wibar_height + beautiful.useless_gap,
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

function dashboard_hide(s)
	s.dashboard.visible = false
end

function dashboard_show(s)
	s.dashboard.visible = true
end

function dashboard_toggle(s)
	if s.dashboard.visible then
		dashboard_hide(s)
	else
		dashboard_show(s)
	end
end
