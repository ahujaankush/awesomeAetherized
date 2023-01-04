local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local rubato = require("modules.rubato")
local colorMod = require("modules.color")
local currentIcon = ""
local color = x.color15

local brightness_slider = wibox.widget {
  forced_width = dpi(100),
  bar_shape = gears.shape.rounded_rect,
  bar_height = dpi(3),
  bar_width = dpi(30),
  bar_color = x.color0,
  bar_active_color = color,
  handle_color = x.color0,
  handle_shape = gears.shape.circle,
  handle_border_color = color,
  handle_border_width = dpi(2),
  value = 0,
  minimum = 0,
  maximum = 100,
  widget = wibox.widget.slider
}

-- rubato sidebar slide
local anim = rubato.timed {
  pos = 0,
  intro = 0.1,
  outro = 0,
  duration = 0.3,
  easing = rubato.easing.quadratic,
  subscribed = function(pos) brightness_slider.forced_width = pos end
}

local timer = gears.timer {
  timeout = 0.3,
  single_shot = true,
  callback = function() brightness_slider.visible = false end
}

local brightness_slider_hide = function()
  anim.target = 0
  timer:start()
end

local brightness_slider_show = function()
  brightness_slider.visible = true
  anim.target = dpi(100)
end

local brightness_slider_toggle = function()
  if brightness_slider.visible then
    brightness_slider_hide()
  else
    brightness_slider_show()
  end
end

-- the icon itself
local brightness_icon = wibox.widget {
  widget = wibox.widget.textbox,
  markup = helpers.colorize_text(currentIcon, color),
  font = "JetBrainsMono Nerd Font 12",
  align = 'center',
  valign = 'center',
  resize = true,
  buttons = {
    awful.button({}, 1, function() brightness_slider_toggle() end),
    awful.button({}, 3, function() helpers.set_brightness(tonumber(brightness_slider:get_value())) end),
  }
}

-- arcchart with brightness icon
local brightness_arcchart = wibox.widget {
  brightness_icon,
  max_value = 100,
  rounded_edge = true,
  thickness = dpi(4.5),
  start_angle = 4.71238898,
  bg = x.color0,
  widget = wibox.container.arcchart
}

-- container with the icon
local brightness_icon_container = wibox.widget {
    {
      brightness_arcchart,
      margins = {
        top = dpi(5),
        bottom = dpi(5),
        left = dpi(6)
      },
      widget = wibox.container.margin
    },
    {
      brightness_slider,
      margins = {
        top = dpi(12),
        bottom = dpi(12),
        left = dpi(6),
      },
      widget = wibox.container.margin
    },
  widget = wibox.container.background,
  layout = wibox.layout.fixed.horizontal
}

-- tooltip
local brightness_icon_tooltip = awful.tooltip {};
brightness_icon_tooltip.preferred_alignments = { "middle", "front", "back" }
brightness_icon_tooltip.mode = "outside"
brightness_icon_tooltip:add_to_object(brightness_icon_container)
brightness_icon_tooltip.markup = helpers.colorize_text("0", color)

local color1 = colorMod.color({ hex = x.color3 })
local color2 = colorMod.color({ hex = x.color11 })
local transitionFunc = colorMod.transition(color1, color2)
local currentColor = color1

awesome.connect_signal("evil::brightness", function(value, muted)

  if muted then
    currentIcon = ""
  else
    if value <= 30 then
      currentIcon = ""
    elseif value <= 50 then
      currentIcon = ""
    elseif value <= 80 then
      currentIcon = ""
    else
      currentIcon = ""
    end
  end
  brightness_slider:set_value(value)
  brightness_arcchart:set_value(value)
  currentColor = transitionFunc(value/100)
  brightness_arcchart.colors = {currentColor.hex}
  brightness_icon.markup = helpers.colorize_text(currentIcon, color)
  brightness_icon_tooltip.markup = helpers.colorize_text(value, color)

end)

return brightness_icon_container
