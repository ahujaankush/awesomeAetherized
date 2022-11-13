local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local icons = require("icons")

local weather_temperature_symbol
if user.weather_units == "metric" then
    weather_temperature_symbol = "°C"
elseif user.weather_units == "imperial" then
    weather_temperature_symbol = "°F"
end

local weather_text = wibox.widget{
    text = "Weather unavailable",
    align  = 'center',
    valign = 'center',
    font = beautiful.font_name.." 14",
    widget = wibox.widget.textbox
}

local weather_icon = wibox.widget.imagebox(icons.getIcon("beautyline/apps/scalable/indicator-weather.svg"))
weather_icon.resize = true
weather_icon.forced_width = 40
weather_icon.forced_height = 40

local weather = wibox.widget{
    weather_icon,
    weather_text,
    layout = wibox.layout.fixed.horizontal
}

local weather_icons = {
    ["01d"] = icons.getIcon("elenaLinebit/sun.png"),
    ["01n"] = icons.getIcon("elenaLinebit/star.png"),
    ["02d"] = icons.getIcon("elenaLinebit/dcloud.png"),
    ["02n"] = icons.getIcon("elenaLinebit/ncloud.png"),
    ["03d"] = icons.getIcon("elenaLinebit/cloud.png"),
    ["03n"] = icons.getIcon("elenaLinebit/cloud.png"),
    ["04d"] = icons.getIcon("elenaLinebit/cloud.png"),
    ["04n"] = icons.getIcon("elenaLinebit/cloud.png"),
    ["09d"] = icons.getIcon("elenaLinebit/rain.png"),
    ["09n"] = icons.getIcon("elenaLinebit/rain.png"),
    ["10d"] = icons.getIcon("elenaLinebit/rain.png"),
    ["10n"] = icons.getIcon("elenaLinebit/rain.png"),
    ["11d"] = icons.getIcon("elenaLinebit/storm.png"),
    ["11n"] = icons.getIcon("elenaLinebit/storm.png"),
    ["13d"] = icons.getIcon("elenaLinebit/snow.png"),
    ["13n"] = icons.getIcon("elenaLinebit/snow.png"),
    ["40d"] = icons.getIcon("elenaLinebit/mist.png"),
    ["40n"] = icons.getIcon("elenaLinebit/mist.png"),
    ["50d"] = icons.getIcon("elenaLinebit/mist.png"),
    ["50n"] = icons.getIcon("elenaLinebit/mist.png"),
    ["_"] = icons.getIcon("beautyline/apps/scalable/indicator-weather.svg"),
}

awesome.connect_signal("evil::weather", function(temperature, description, icon_code)
    if weather_icons[icon_code] then
        weather_icon.image = weather_icons[icon_code]
    else
        weather_icon.image = weather_icons['_']
    end

    weather_text.markup = description.." "..tostring(temperature)..weather_temperature_symbol
end)

return weather
