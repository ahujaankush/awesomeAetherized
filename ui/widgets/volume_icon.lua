local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local rubato = require("modules.rubato")
local colorMod = require("modules.color")
local currentIcon = "ﱝ"
local color = x.color15

local volume_slider = wibox.widget {
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
  subscribed = function(pos) volume_slider.forced_width = pos end
}

local timer = gears.timer {
  timeout = 0.3,
  single_shot = true,
  callback = function() volume_slider.visible = false end
}

local volume_slider_hide = function()
  anim.target = 0
  timer:start()
end

local volume_slider_show = function()
  volume_slider.visible = true
  anim.target = dpi(100)
end

local volume_slider_toggle = function()
  if volume_slider.visible then
    volume_slider_hide()
  else
    volume_slider_show()
  end
end

-- the icon itself
local volume_icon = wibox.widget {
  widget = wibox.widget.textbox,
  markup = helpers.colorize_text(currentIcon, color),
  font = "JetBrainsMono Nerd Font 12",
  align = 'center',
  valign = 'center',
  resize = true,
  buttons = {
    awful.button({}, 1, function() volume_slider_toggle() end),
    awful.button({}, 3, function() helpers.set_volume(tonumber(volume_slider:get_value())) end),
  }
}

-- arcchart with volume icon
local volume_arcchart = wibox.widget {
  volume_icon,
  max_value = 20,
  rounded_edge = true,
  thickness = dpi(4.5),
  start_angle = 4.71238898,
  bg = x.color0,
  widget = wibox.container.arcchart
}

-- container with the icon
local volume_icon_container = wibox.widget {
    {
      volume_arcchart,
      margins = {
        top = dpi(5),
        bottom = dpi(5),
        left = dpi(6),
      },
      widget = wibox.container.margin
    },
    {
      volume_slider,
      margins = {
        top = dpi(12),
        bottom = dpi(12)
      },
      widget = wibox.container.margin
    },
    widget = wibox.container.background,
    layout = wibox.layout.fixed.horizontal
}
-- tooltip
local volume_icon_tooltip = awful.tooltip {};
volume_icon_tooltip.preferred_alignments = { "middle", "front", "back" }
volume_icon_tooltip.mode = "outside"
volume_icon_tooltip:add_to_object(volume_icon_container)
volume_icon_tooltip.markup = helpers.colorize_text("0", color)

local color1 = colorMod.color({ hex = x.color1 })
local color2 = colorMod.color({ hex = x.color10 })
local transitionFunc = colorMod.transition(color1, color2)
local currentColor = color1
local colorCounter = 0

local function setArcchart(value, counter)
  if tonumber(value) > 20 then
    value = value - 20
    counter = counter + 1
    setArcchart(value, counter)
  else
    volume_arcchart:set_value(value)
    colorCounter = counter
    return
  end
end

awesome.connect_signal("evil::volume", function(value, muted)

  if muted then
    currentIcon = "ﱝ"
  else
    if value <= 10 then
      currentIcon = ""
    elseif value <= 30 then
      currentIcon = ""
    elseif value <= 60 then
      currentIcon = "墳"
    elseif value <= 90 then
      currentIcon = ""
    else
      currentIcon = ""
    end
  end
  volume_slider:set_value(value)
  setArcchart(value, 0)
  currentColor = transitionFunc(colorCounter/4)
  volume_arcchart.colors = {currentColor.hex}
  volume_icon.markup = helpers.colorize_text(currentIcon, color)
  volume_icon_tooltip.markup = helpers.colorize_text(value, color)

end)

return volume_icon_container
