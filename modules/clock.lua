-- Stolen and edited from Nooo37
-- https://github.com/Nooo37/dots/blob/master/awesome/.config/awesome/module/clock.lua
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local cairo = require("lgi").cairo
local math = require("math")

local function create_minute_pointer(minute)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, 1000, 1000)
    local cr = cairo.Context(img)
    local angle = (minute / 60) * 2 * math.pi
    cr:translate(500, 500)
    cr:rotate(angle)
    cr:translate(-500, -500)
    cr:set_source(gears.color(beautiful.xforeground))
    cr:rectangle(485, 100, 15, 420)
    cr:fill()
    return img
end

local function create_second_pointer(sec)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, 1000, 1000)
    local cr = cairo.Context(img)
    local angle = (sec / 60) * 2 * math.pi
    cr:translate(500, 500)
    cr:rotate(angle)
    cr:translate(-500, -500)
    cr:set_source(gears.color(beautiful.xcolor0))
    cr:rectangle(485, 100, 10, 400)
    cr:fill()
    return img
end


local function create_hour_pointer(hour)
    local img = cairo.ImageSurface(cairo.Format.ARGB32, 1000, 1000)
    local cr = cairo.Context(img)
    local angle = ((hour % 12) / 12) * 2 * math.pi
    cr:translate(500, 500)
    cr:rotate(angle)
    cr:translate(-500, -500)
    cr:set_source(gears.color(beautiful.xcolor6))
    cr:rectangle(480, 200, 20, 320)
    cr:fill()
    return img
end

local minute_pointer = create_minute_pointer(37)
local hour_pointer = create_hour_pointer(17)
local second_pointer = create_second_pointer(45)

local minute_pointer_img = wibox.widget.imagebox()
local hour_pointer_img = wibox.widget.imagebox()
local second_pointer_img = wibox.widget.imagebox()

local analog_clock = wibox.widget {
    { -- circle
        wibox.widget.textbox(""),
        shape = function(cr, width, height)
            gears.shape.circle(cr, width, height, height / 2)
        end,
        shape_border_width = 4,
        shape_border_color = beautiful.xcolor8,
        widget = wibox.container.background
    },
	second_pointer_img,
    minute_pointer_img,
    hour_pointer_img,
    layout = wibox.layout.stack
}

local minute = 0
local hour = 0
local second = 0

gears.timer {
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = function()
        minute = os.date("%M")
        hour = os.date("%H")
		second = os.date("%S")
		second_pointer = create_second_pointer(second)
        minute_pointer = create_minute_pointer(minute + (second / 60))
        hour_pointer = create_hour_pointer(hour + (minute / 60))
		second_pointer_img.image = second_pointer
	    minute_pointer_img.image = minute_pointer
        hour_pointer_img.image = hour_pointer
    end
}

return analog_clock
