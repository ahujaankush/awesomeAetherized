local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local icons = require("icons")

local helpers = require("helpers")

-- Note: This theme does not show image notification icons

-- For antialiasing
-- The real background color is set in the widget_template
beautiful.notification_bg = "#00000000"

local app_config = {
  ['NetworkManager'] = {
    icon = icons.getIcon("beautyline/devices/scalable/network-wireless.svg")
  },
  ['NetworkManager Applet'] = {
    icon = icons.getIcon("beautyline/devices/scalable/network-wireless.svg")
  },
  ['blueman'] = {
    icon = icons.getIcon("beautyline/apps/scalable/bluetooth.svg")
  }
}

-- Template
-- ===================================================================
naughty.connect_signal("request::display", function(n)
  if app_config[n.app_name] then
    n.icon = app_config[n.app_name].icon
  elseif n.icon == nil then
    n.icon = icons.getIcon("beautyline/apps/scalable/preferences-desktop-notification.svg")
  end

  local notify_icon = naughty.widget.icon

  local function returnIcon()
    return notify_icon
  end

  -- replace title with appname, used to create app_config
  -- n.title = n.app_name

  local actions = wibox.widget {
    notification = n,
    base_layout = wibox.widget {
      spacing = dpi(5),
      layout = wibox.layout.flex.horizontal
    },
    widget_template = {
      {
        {
          {
            id = 'text_role',
            font = beautiful.notification_font,
            widget = wibox.widget.textbox
          },
          left = dpi(6),
          right = dpi(6),
          widget = wibox.container.margin
        },
        widget = wibox.container.place
      },
      bg = x.color8 .. "32",
      forced_height = dpi(25),
      forced_width = dpi(70),
      widget = wibox.container.background
    },
    style = {
      underline_normal = false,
      underline_selected = true
    },
    widget = naughty.list.actions
  }

  naughty.layout.box {
    notification = n,
    type = "notification",
    -- For antialiasing: The real shape is set in widget_template
    shape = gears.shape.rectangle,
    border_width = beautiful.notification_border_width,
    border_color = beautiful.notification_border_color,
    position = beautiful.notification_position,
    widget_template = {
      {
        {
          {
            wibox.container.place(wibox.widget {
              nil,
              {
                align = "center",
                valign = "center",
                widget = wibox.widget {
                  {
                    widget = returnIcon(),
                    resize = true
                  },
                  margins = dpi(12),
                  widget = wibox.container.margin
                }
              },
              layout = wibox.layout.flex.vertical,
              widget = wibox.container.background
            }, 'center', 'center'),
            bg = x.background,
            widget = wibox.container.background
          },
          {
            {
              {
                align = "center",
                font = beautiful.notification_font,
                markup = "<b>" .. n.title .. "</b>",
                widget = wibox.widget.textbox
                -- widget = naughty.widget.title,
              },
              {
                align = "center",
                -- wrap = "char",
                widget = naughty.widget.message
              },
              {
                helpers.vertical_pad(dpi(10)),
                {
                  actions,
                  shape = helpers.rrect(dpi(4)),
                  widget = wibox.container.background
                },
                visible = n.actions and #n.actions > 0,
                layout = wibox.layout.fixed.vertical
              },
              layout = wibox.layout.align.vertical
            },
            margins = beautiful.notification_margin,
            widget = wibox.container.margin
          },
          layout = wibox.layout.fixed.horizontal
        },
        strategy = "max",
        width = beautiful.notification_max_width or dpi(350),
        height = beautiful.notification_max_height or dpi(180),
        widget = wibox.container.constraint
      },
      -- Anti-aliasing container
      shape = helpers.rrect(beautiful.notification_border_radius),
      bg = x.color0,
      widget = wibox.container.background
    }
  }
end)

-- naughty.disconnect_signal("request::display", naughty.default_notification_handler)
