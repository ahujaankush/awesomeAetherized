local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local icondir = gears.filesystem.get_configuration_dir() .. "icons/"

return wibox.widget {
  {
    {
      {
        image = icondir.."bells.png",
        resize = true,
        forced_height = dpi(120),
        halign = "center",
        valign = "center",
        widget = wibox.widget.imagebox,
      },
      {
        widget = wibox.widget.textbox,
        markup = helpers.colorize_text("You are completely caught up :)", x.foreground .. "4D"),
        font = beautiful.font .. " 14",
        valign = "center",
        align = "center"
      },
      spacing = dpi(20),
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.place,
    valign = 'center'
  },
  forced_height = dpi(500),
  margins = { top = dpi(15) },
  widget = wibox.container.margin

}
