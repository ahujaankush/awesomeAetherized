local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local midText = wibox.widget({
	halign = "center",
	font = beautiful.font .. " 20",
	markup = helpers.colorize_text(" ", x.foreground),
	widget = wibox.widget.textbox,
})

local createProg = function(color, signal, size, icon)
	local progress = wibox.widget({
		widget = wibox.container.arcchart,
		max_value = 100,
		min_value = 0,
		padding = 0,
		value = 100,
		rounded_edge = false,
		thickness = 16,
		start_angle = math.random(250, 870) * math.pi / 180,
		colors = { color },
		bg = color .. "11",
		forced_width = dpi(size),
		forced_height = dpi(size),
	})
	awesome.connect_signal("evil::" .. signal, function(val)
		progress.value = val
	end)
	progress:connect_signal("mouse::enter", function()
		midText.markup = helpers.colorize_text(icon, color)
	end)
	progress:connect_signal("mouse::leave", function()
		midText.markup = helpers.colorize_text(" ", color)
	end)
	return {
		{ progress, layout = wibox.layout.fixed.vertical },
		widget = wibox.container.place,
		valign = "center",
		halign = "center",
	}
end
local batteryprog = createProg(x.color2, "battery", 85, "󰁹")
local memprog = createProg(x.color1, "ram", 135, "󰍛")
local diskprog = createProg(x.color14, "disk", 185, "󰋊")
local cpuprog = createProg(x.color11, "cpu", 235, "󰘚")

local finalwidget = wibox.widget({
	{
		{
			{
				{
					{
						midText,
						widget = wibox.container.place,
						halign = "center",
						valign = "center",
					},
					batteryprog,
					memprog,
					diskprog,
					cpuprog,
					layout = wibox.layout.stack,
				},
				spacing = 10,
				layout = wibox.layout.fixed.vertical,
			},
			widget = wibox.container.place,
			valign = "center",
		},
		widget = wibox.container.margin,
		margins = 20,
	},
	forced_width = 300,
	widget = wibox.container.background,
	bg = x.color0 .. "cc",
})

return finalwidget
