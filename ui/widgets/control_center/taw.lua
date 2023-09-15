local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local icondir = gears.filesystem.get_configuration_dir() .. "icons/weather/"

local weather_icons = {
	["01d"] = icondir .. "weather-clear-sky.svg",
	["02d"] = icondir .. "weather-few-clouds.svg",
	["04d"] = icondir .. "weather-few-clouds.svg",
	["03d"] = icondir .. "weather-clouds.svg",
	["09d"] = icondir .. "weather-showers-scattered.svg",
	["09n"] = icondir .. "weather-showers-scattered.svg",
	["10d"] = icondir .. "weather-showers.svg",
	["11d"] = icondir .. "weather-strom.svg",
	["13d"] = icondir .. "weather-snow.svg",
	["50d"] = icondir .. "weather-fog.svg",
	["01n"] = icondir .. "weather-clear-night.svg",
	["02n"] = icondir .. "weather-few-clouds-night.svg",
	["03n"] = icondir .. "weather-clouds-night.svg",
	["04n"] = icondir .. "weather-clouds-night.svg",
	["10n"] = icondir .. "weather-showers.svg",
	["11n"] = icondir .. "weather-strom.svg",
	["13n"] = icondir .. "weather-snow.svg",
	["50n"] = icondir .. "weather-fog.svg",
	["_"] = icondir .. "weather-clear-sky.svg",
}

local weather = wibox.widget({
	{
		{
			{
				{
					{
						id = "desc",
						font = beautiful.font .. " Light 12",
						markup = "Scattered Clouds",
						valign = "center",
						align = "start",
						widget = wibox.widget.textbox,
					},
					{
						id = "temp",
						font = beautiful.font .. " Light 16",
						markup = "31 C",
						valign = "center",
						align = "start",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.vertical,
				},
				{
					{
						id = "image",
						image = gears.filesystem.get_configuration_dir() .. "theme/icons/weather/weather-fog.svg",
						opacity = 0.65,
						clip_shape = helpers.rrect(4),
						forced_height = 50,
						forced_width = 50,
						widget = wibox.widget.imagebox,
					},
					widget = wibox.container.place,
					halign = "right",
				},
				spacing = dpi(30),
				layout = wibox.layout.fixed.vertical,
			},
			layout = wibox.layout.fixed.vertical,
		},
		widget = wibox.container.margin,
		margins = 18,
	},
	forced_width = 100,
	bg = x.color0 .. "cc",
	widget = wibox.container.background,
})

local time = wibox.widget({
	{
		{
			{
				{
					{
						{
							font = beautiful.font .. " Bold 46",
							format = "%I",
							align = "center",
							valign = "center",
							widget = wibox.widget.textclock,
						},
						{
							font = beautiful.font .. " 46",
							format = "%M",
							align = "center",
							valign = "center",
							widget = wibox.widget.textclock,
						},
						spacing = 15,
						layout = wibox.layout.fixed.horizontal,
					},
					widget = wibox.container.place,
					halign = "center",
				},
				widget = wibox.container.place,
				halign = "center",
				valign = "center",
			},
			widget = wibox.container.margin,
			margins = 20,
		},
		bg = x.color0 .. "cc",
		widget = wibox.container.background,
	},
	widget = wibox.container.margin,
})

awesome.connect_signal("evil::weather", function(temp, desc, icon)
	weather:get_children_by_id("desc")[1].markup = desc
	weather:get_children_by_id("temp")[1].markup = temp .. " C"
	weather:get_children_by_id("image")[1].image = weather_icons[icon]
end)

local finalWidget = {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(16),
	time,
	weather,
}

return finalWidget
