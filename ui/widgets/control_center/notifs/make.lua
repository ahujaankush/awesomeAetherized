-- the notification themselves
local helpers = require("helpers")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
return function(icon, notification, width)
  -- table of icons
  local icons = {
    ["firefox"] = { icon = "󰈹" },
    ["discord"] = { icon = "󰙯" },
    ["dunstify"] = { icon = "󱝁" },
  }

  local appicon
  if icons[string.lower(notification.app_name)] then
    appicon = icons[string.lower(notification.app_name)]
  else
    appicon = '󱝁'
  end

  local appiconbox = wibox.widget {
    {
      {
        font   = beautiful.font_name .. " 14",
        markup = "<span foreground='" .. x.color4 .. "'>" .. appicon .. "</span>",
        align  = "center",
        valign = "center",
        widget = wibox.widget.textbox
      },
      widget = wibox.container.margin,
      margins = dpi(10),
    },
    widget = wibox.container.background,
  }
  local message = wibox.widget {
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    speed = 50,
    {
      markup = helpers.colorize_text(notification.message, x.foreground),
      font = beautiful.font .. " 12",
      align = "left",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    widget = wibox.container.scroll.horizontal,

  }
  local title = wibox.widget {
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    speed = 50,
    {
      {
        markup = helpers.colorize_text(notification.title .. "  ", x.foreground),
        font = beautiful.font .. " 12",
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      layout = wibox.layout.align.horizontal,
    },
    widget = wibox.container.scroll.horizontal,
  }
  local image_width = 70
  local image_height = 70
  local image = wibox.widget {
    {
      image = icon,
      resize = true,
      halign = "center",
      opacity = 0.6,
      valign = "center",
      widget = wibox.widget.imagebox,
    },
    strategy = "exact",
    height = image_height,
    width = image_width,
    widget = wibox.container.constraint,
  }
  local close = wibox.widget {
    markup = helpers.colorize_text("󰅖", x.color1),
    font   = beautiful.font_name .. " 13",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox
  }
  local action_widget = {
    {
      {
        id = "text_role",
        align = "center",
        valign = "center",
        font = beautiful.font .. " 12",
        widget = wibox.widget.textbox
      },
      left = dpi(6),
      right = dpi(6),
      widget = wibox.container.margin
    },
    bg = x.color8 .. '33',
    forced_height = dpi(30),
    shape = helpers.rrect(4),
    widget = wibox.container.background
  }


  -- actions
  local actions = wibox.widget {
    notification = notification,
    base_layout = wibox.widget {
      spacing = dpi(8),
      layout = wibox.layout.flex.horizontal
    },
    widget_template = {
      action_widget,
      bottom = dpi(0),
      widget = wibox.container.margin
    },
    style = { underline_normal = false, underline_selected = true },
    widget = naughty.list.actions
  }

  local finalnotif = wibox.widget {
    {
      --top
      appiconbox,
      {
        {
          {
            title,
            nil,
            close,
            layout = wibox.layout.align.horizontal,
          },
          margins = {
            top = 5,
            bottom = 5,
            left = 10,
            right = 10,
          },
          widget = wibox.container.margin
        },
        bg = x.color8.. '0f',
        widget = wibox.container.background
      },
      nil,
      layout = wibox.layout.align.horizontal,
    },
    {
      {
        {
          {
            widget = wibox.container.margin,
            margins = { right = 30 },
            image,
          },
          {
            message,
            actions,
            spacing = 20,
            layout = wibox.layout.fixed.vertical,
          },
          nil,
          layout = wibox.layout.align.horizontal,
        },
        widget = wibox.container.margin,
        margins = 20,
      },
      bg = x.color8 .. '66',
      widget = wibox.container.background
    },
    forced_height = 150,
    shape = helpers.rrect(4),
    layout = wibox.layout.fixed.vertical,
  }

  close:buttons(gears.table.join(awful.button({}, 1, function()
    _G.notif_center_remove_notif(finalnotif)
  end)))

  return finalnotif
end
