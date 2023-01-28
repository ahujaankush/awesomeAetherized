local gears = require("gears")
local wibox = require("wibox")

-- Set colors
local active_color = {
	type = "linear",
	from = { 0, 0 },
	to = { 200 }, -- replace with w,h later
	stops = { { 0, x.color1 }, { 0.50, x.color3 } },
}

local temperature_bar = wibox.widget({
	forced_height = dpi(100),
	forced_width = dpi(5),
	shape = gears.shape.rounded_bar,
	bg = active_color,
	widget = wibox.container.background,
})

awesome.connect_signal("evil::temperature", function(value)
	temperature_bar.forced_height = dpi(value)
end)

return temperature_bar