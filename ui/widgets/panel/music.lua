local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local bling = require("modules.bling")
local helpers = require("helpers")
local playerctl = bling.signal.playerctl.lib()
local art = wibox.widget({
	image = beautiful.player_img,
	opacity = 0.25,
	shape = helpers.rrect(4),
	forced_height = dpi(36),
	forced_width = dpi(255),
	widget = wibox.widget.imagebox,
})
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	-- Set art widget
	art.image = helpers.cropSurface(6, gears.surface.load_uncached(album_path))
end)
local next = wibox.widget({
	align = "center",
	font = beautiful.font_name .. " 16",
	text = "󰒭",
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:next()
		end),
	},
})

local prev = wibox.widget({
	align = "center",
	font = beautiful.font_name .. " 16",
	text = "󰒮",
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:previous()
		end),
	},
})
local play = wibox.widget({
	align = "center",
	font = beautiful.font_name .. " 16",
	markup = helpers.colorize_text("󰐊", x.foreground),
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:play_pause()
		end),
	},
})
playerctl:connect_signal("playback_status", function(_, playing, player_name)
	play.markup = playing and helpers.colorize_text("󰏤", x.foreground) or helpers.colorize_text("󰐊", x.foreground)
end)
local finalwidget = wibox.widget({
	art,
	{
		{
			widget = wibox.widget.textbox,
		},
		bg = {
			type = "linear",
			from = { 0, 0 },
			to = { 250, 0 },
			stops = { { 0, x.background .. "00" }, { 1, x.color0 } },
		},
		shape = helpers.rrect(beautiful.border_radius),
		widget = wibox.container.background,
	},
	{
		{
			{
				align = "center",
				font = beautiful.font_name .. " 14",
				markup = helpers.colorize_text("󰋋 ", x.foreground),
				widget = wibox.widget.textbox,
			},
			nil,
			{ prev, play, next, spacing = 8, layout = wibox.layout.fixed.horizontal },
			layout = wibox.layout.align.horizontal,
		},
		widget = wibox.container.margin,
		left = 6,
		right = 6,
	},
	layout = wibox.layout.stack,
})

return finalwidget
