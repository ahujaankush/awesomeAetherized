-------------------------------------------------
-- Battery Arc Widget for Awesome Window Manager
-- Shows the battery level of the laptop
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/batteryarc-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------
-- edit: Ankush Ahuja
-- changes: remove notifications, edit style and use signals to update widget
-------------------------------------------------

local wibox = require("wibox")

local batteryarc_widget = {}

local function worker(user_args)

  local args = user_args or {}

  local font = args.font or 'Play 6'
  local size = args.size or 18


  local enable_battery_warning = args.enable_battery_warning
  if enable_battery_warning == nil then
    enable_battery_warning = true
  end

  local text = wibox.widget {
    font = font,
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  local text_with_background = wibox.container.background(text)

  batteryarc_widget = wibox.widget {
    text_with_background,
    max_value = 100,
    rounded_edge = true,
    thickness = dpi(4),
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = size,
    forced_width = size,
    bg = x.background,
    paddings = 2,
    widget = wibox.container.arcchart
  }

  local charging = false

  awesome.connect_signal("evil::battery", function(value)
    -- Update bar
    batteryarc_widget.value = value
    local color
    -- Update face
    if charging then
      color = x.color4
    elseif value <= user.battery_threshold_low then
      color = x.color1
    elseif value <= user.battery_threshold_ok then
      color = x.color11
    else
      color = x.color10
    end
    batteryarc_widget.color = color
  end)

  awesome.connect_signal("evil::charger", function(plugged)
    local color
    if plugged then
      color = x.color4
    elseif batteryarc_widget.value <= user.battery_threshold_low then
      color = x.color1
    elseif batteryarc_widget.value <= user.battery_threshold_ok then
      color = x.color11
    else
      color = x.color10
    end
    batteryarc_widget.color = color
  end)

  return batteryarc_widget

end

return setmetatable(batteryarc_widget, { __call = function(_, ...)
  return worker(...)
end })
