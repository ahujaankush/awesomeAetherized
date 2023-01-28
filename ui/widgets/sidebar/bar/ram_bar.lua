local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Set colors
local active_color = {
	type = "linear",
	from = { 0, 0 },
	to = { 100 }, -- replace with w,h later
	stops = { { 0, x.color14 }, { 0.50, x.color4 } },
}

local ram_bar = wibox.widget({
	forced_height = dpi(100),
	forced_width = dpi(5),
	shape = gears.shape.rounded_bar,
	bg = active_color,
	widget = wibox.container.background,
})

awesome.connect_signal("evil::ram", function(used, total)
	ram_bar.forced_height = dpi((used / total) * 100)
end)

return ram_bar
