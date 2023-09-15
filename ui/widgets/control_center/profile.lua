local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local helpers = require("helpers")


local profilepicture = wibox.widget({
	image = user.profile_picture,
	opacity = 0.65,
	clip_shape = helpers.rrect(4),
	forced_height = 80,
	forced_width = 80,
	widget = wibox.widget.imagebox,
})

local uptime = wibox.widget({
	halign = "right",
	font = beautiful.font .. " 11",
	markup = helpers.colorize_text("??? ???", x.color7),
	widget = wibox.widget.textbox,
})

awful.widget.watch("uptime -p", 60, function(_, stdout)
	-- Remove trailing whitespaces
	local out = stdout:gsub("^%s*(.-)%s*$", "%1")
	uptime:set_markup(helpers.colorize_text(out, x.color7))
end)

local name = wibox.widget({
	nil,
	{
		{
			halign = "right",
			font = beautiful.font .. " Bold 14",
			markup = helpers.colorize_text("Welcome!", x.foreground .. "cc"),
			widget = wibox.widget.textbox,
		},
		{
			halign = "right",
			font = beautiful.font .. " 13",
			markup = user.name,
			widget = wibox.widget.textbox,
		},
		spacing = 3,
		layout = wibox.layout.fixed.vertical,
	},
	layout = wibox.layout.align.vertical,
	expand = "none",
})

local finalwidget = wibox.widget({
	{
		{

			profilepicture,
			nil,
			{
				uptime,
				name,
				spacing = 5,
				layout = wibox.layout.fixed.vertical,
			},
			spacing = 70,
			layout = wibox.layout.align.horizontal,
		},
		margins = 25,
		widget = wibox.container.margin,
	},
	bg = x.color0 .. "cc",
	widget = wibox.container.background,
})

return finalwidget
