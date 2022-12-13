-- wibar.lua
-- Wibar (top bar)
local awful = require("awful")
local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local icons = require("icons")
local keygrabber = require("awful.keygrabber")

local bling = require("modules.bling")
local rubato = require("modules.rubato")
-- Awesome Panel -----------------------------------------------------------

--[[ local unclicked = gears.surface.load_uncached(
                      gfs.get_configuration_dir() .. "icons/ghosts/awesome.png")

local clicked = gears.color.recolor_image(
                    gears.surface.load_uncached(
                        gfs.get_configuration_dir() ..
                            "icons/ghosts/awesome.png"), x.color8)

                            --]]

local awesome_icon = wibox.widget {
    {
        widget = wibox.widget.imagebox,
        image = icons.getIcon("beautyline/apps/scalable/distributor-logo-nixos.png"),
        -- image = icons.getIcon("candy-icons/apps/scalable/playonlinux.svg"),
        resize = true
    },
    margins = dpi(11),
    widget = wibox.container.margin
}

local awesome_icon_container = wibox.widget {
    awesome_icon,
    bg = colors.transparent,
    widget = wibox.container.background
}

awesome_icon_container:connect_signal("button::press", function()
    awesome_icon_container.bg = x.color0 .. "CC"
    awesome_icon.top = dpi(12)
    awesome_icon.left = dpi(12)
    awesome_icon.right = dpi(10)
    awesome_icon.bottom = dpi(10)
    dashboard_show()
end)

awesome_icon_container:connect_signal("button::release", function()
    awesome_icon.margins = dpi(11)
    awesome_icon_container.bg = colors.transparent
end)

-- Change cursor
helpers.add_hover_cursor(awesome_icon_container, "hand2")

-- Battery Bar Widget ---------------------------------------------------------

local battery_bar = wibox.widget {
    max_value = 100,
    value = 50,
    forced_width = dpi(100),
    shape = helpers.rrect(beautiful.border_radius - 3),
    bar_shape = helpers.rrect(beautiful.border_radius - 3),
    color = x.color10,
    background_color = x.color0,
    border_width = dpi(0),
    border_color = beautiful.border_color,
    widget = wibox.widget.progressbar
}

local chargingIcon = wibox.widget {
    {
        widget = wibox.widget.imagebox,
        image = icons.getIcon("elenaLinebit/battery_charging.png"),
        resize = true
    },
    margins = dpi(8),
    widget = wibox.container.margin
}

  local battery_bar_precentage = wibox.widget {
    font = beautiful.font,
    visible = true,
    align  = 'left',
    valign = 'center',
    widget = wibox.widget.textbox
  }
  battery_bar_precentage.markup = helpers.bold_text(helpers.colorize_text("50%", x.background))

  local batteryValue = 50
  local charging = false

  local function updateBatteryBar(value)
      battery_bar.value = value
      battery_bar.color = x.color10

    if (charging) then
          battery_bar.color = x.color4
      else
          if value >= 90 and value <= 100 then
              battery_bar.color = x.color10
          elseif value >= 70 and value < 90 then
              battery_bar.color = x.color10
          elseif value >= 60 and value < 70 then
              battery_bar.color = x.color10
          elseif value >= 50 and value < 60 then
              battery_bar.color = x.color11
          elseif value >= 30 and value < 50 then
              battery_bar.color = x.color11
          elseif value >= 15 and value < 30 then
              battery_bar.color = x.color9
          else
              battery_bar.color = x.color9
          end
      end
    battery_bar_precentage.markup = helpers.bold_text(helpers.colorize_text(value.."%", x.background))
  end

  awesome.connect_signal("evil::battery", function(value)
      batteryValue = value
      updateBatteryBar(batteryValue)
  end)

  awesome.connect_signal("evil::charger", function(plugged)
      charging = plugged
      updateBatteryBar(batteryValue)

  end)

  -- Tasklist Buttons -----------------------------------------------------------

  local tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
      if c == client.focus then
          c.minimized = true
      else
          c:emit_signal("request::activate", "tasklist", {
              raise = true
          })
      end
  end), awful.button({}, 3, function()
      awful.menu.client_list({
          theme = {
              width = 250
          }
      })
  end), awful.button({}, 4, function()
      awful.client.focus.byidx(1)
  end), awful.button({}, 5, function()
      awful.client.focus.byidx(-1)
  end))

  -- Clock Widget ---------------------------------------------------------------

  local hourtextbox = wibox.widget.textclock("%H", 3600)
  hourtextbox.markup = helpers.colorize_text(hourtextbox.text, x.color5)

  hourtextbox:connect_signal("widget::redraw_needed", function()
      hourtextbox.markup = helpers.colorize_text(hourtextbox.text, x.color5)
  end)

  local minutetextbox = wibox.widget.textclock("%M", 60)
  minutetextbox.markup = helpers.colorize_text(minutetextbox.text, x.color4)

  minutetextbox:connect_signal("widget::redraw_needed", function()
      minutetextbox.markup = helpers.colorize_text(minutetextbox.text, x.color4)
  end)

  local secondtextbox = wibox.widget.textclock("%S", 1)
  secondtextbox.markup = helpers.colorize_text(secondtextbox.text, x.foreground)

  secondtextbox:connect_signal("widget::redraw_needed", function()
      secondtextbox.markup = helpers.colorize_text(secondtextbox.text, x.foreground)
  end)


  -- Create the Wibar -----------------------------------------------------------
  local datetooltip = awful.tooltip {};
  datetooltip.preferred_alignments = { "middle", "front", "back" }
  datetooltip.mode = "outside"
  datetooltip.markup = helpers.colorize_text(os.date("%d"), x.color13) .. "/" ..
  helpers.colorize_text(os.date("%m"), x.color12) .. "/" ..
  helpers.colorize_text(os.date("%y"), x.color10)

  local mysystray = wibox.widget.systray()
  mysystray.base_size = beautiful.systray_icon_size

  screen.connect_signal("request::desktop_decoration", function(s)
      
      s.battery_bar_container = wibox.widget {
        {
          {
            battery_bar,
            {
              battery_bar_precentage,
              margins = {
                left = dpi(5)
              },
              widget = wibox.container.margin
            },
          layout = wibox.layout.stack, 
          widget = wibox.container.background
        },
            margins = {
                left = dpi(10),
                right = dpi(10),
                top = dpi(14),
                bottom = dpi(14)
            },
            widget = wibox.container.margin
        },
        bg = colors.transparent,
        widget = wibox.container.background
    }

    s.clock = wibox.widget {
        screen = s,
        {
            hourtextbox,
            minutetextbox,
            secondtextbox,
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal
        },
        margins = dpi(11),
        widget = wibox.container.margin
    
    }
    
    s.clock_container = wibox.widget {
        screen = s,
        s.clock,
        bg = colors.transparent,
        widget = wibox.container.background
    }
    

    datetooltip:add_to_object(s.clock_container)
    -- Change cursor
    helpers.add_hover_cursor(s.clock_container, "hand2")
    
    
    s.clock_container:connect_signal("button::press", function()
        control_center_toggle(s)
        s.clock_container.bg = x.color0 .. "CC"
        s.clock.top = dpi(12)
        s.clock.left = dpi(12)
        s.clock.right = dpi(10)
        s.clock.bottom = dpi(10)
    end)
    
    s.clock_container:connect_signal("button::release", function()
        s.clock_container.bg = colors.transparent
        s.clock.margins = dpi(11)
    end)
    
    -- bling: task preview
    bling.widget.tag_preview.enable {
        show_client_content = true,
        placement_fn = function(c)
            awful.placement.top(c, {
                margins = {
                    top = beautiful.wibar_height + beautiful.useless_gap
                }
            })
        end,
        scale = 0.5,
        honor_padding = true,
        honor_workarea = true,
        background_widget = wibox.widget { -- Set a background image (like a wallpaper) for the widget
            image                 = beautiful.wallpaper,
            horizontal_fit_policy = "fit",
            vertical_fit_policy   = "fit",
            widget                = wibox.widget.imagebox
        }
    }

    bling.widget.task_preview.enable {
        x = 20,                    -- The x-coord of the popup
        y = 20,                    -- The y-coord of the popup
        height = dpi(550),              -- The height of the popup
        width = dpi(450),               -- The width of the popup
        placement_fn = function(c)
            awful.placement.top_left(c, {
                margins = {
                    top = beautiful.wibar_height + beautiful.useless_gap,
                    left = beautiful.wibar_height + beautiful.useless_gap
                }
            })
        end,
        -- Your widget will automatically conform to the given size due to a constraint container.
        widget_structure = {
            {
                {
                    {
                        id = 'icon_role',
                        widget = awful.widget.clienticon, -- The client icon
                    },
                    {
                        id = 'name_role', -- The client name / title
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.flex.horizontal
                },
                widget = wibox.container.margin,
                margins = 5
            },
            {
                id = 'image_role', -- The client preview
                resize = true,
                valign = 'center',
                halign = 'center',
                widget = wibox.widget.imagebox,
            },
            layout = wibox.layout.fixed.vertical
        }
    }

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create layoutbox widget
    s.layoutPopup = awful.popup {
        screen = s,
        widget = wibox.widget {  
          awful.widget.layoutlist {
            screen = s,
            base_layout = wibox.layout.flex.vertical
          },  
          margins = dpi(5),
          widget = wibox.container.margin
        },
        maximum_height = #awful.layout.layouts * dpi(50),
        minimum_height = #awful.layout.layouts * dpi(50),
        maximum_width = dpi(175),
        placement = function(c)
            awful.placement.top_right(c, {
                margins = {
                    top = beautiful.wibar_height + dpi(10),
                    right = dpi(10)
                }
            })
        end,
        visible = false,
        ontop = true,
        opacity = beautiful.layoutPopup_opacity,
        bg = x.background,
        fg = x.foreground
    }

    s.layoutPopup_grabber = nil
    s.layoutPopup_timer = gears.timer {
      timeout = 0.15,
      single_shot = true,
      callback = function()
        s.layoutPopup.visible = false
      end
    }


    s.layoutPopup_fade_height = rubato.timed {
      pos = 0,
      rate = 60,
      intro = 0,
      outro = 0.05,
      duration = 0.15,
      easing = rubato.easing.quadratic,
      subscribed = function(pos)
          s.layoutPopup.maximum_height = pos
      end
    }

    s.layoutPopup_fade_width = rubato.timed {
      pos = 0,
      rate = 60,
      intro = 0,
      outro = 0.05,
      duration = 0.15,
      easing = rubato.easing.quadratic,
      subscribed = function(pos)
          s.layoutPopup.maximum_width = pos
      end
    }
  

    function layoutPopup_hide(s)
        s.layoutPopup_fade_height.target = 0
        s.layoutPopup_fade_width.target = 0
        s.layoutPopup_timer:start()
        awful.keygrabber.stop(s.layoutPopup_grabber)

    end

    function layoutPopup_show(s)

        -- naughty.notify({text = "starting the keygrabber"})
        s.layoutPopup_grabber = awful.keygrabber.run(function(_, key, event)
            if event == "release" then
                return
            end
            -- Press Escape or q or F1 to hide itf
            if key == 'Escape' or key == 'q' or key == 'F1' then
                layoutPopup_hide(s)
            end
        end)
        s.layoutPopup.visible = true
        s.layoutPopup_fade_height.target = #awful.layout.layouts * dpi(50)
        s.layoutPopup_fade_width.target = dpi(175)
    end

    s.mylayoutbox = wibox.widget {
        {
            widget = awful.widget.layoutbox {
                screen = s
            }
            --       image = gears.surface(beautiful.theme_assets.awesome_icon(512,
            --                                                                 x.color8,
            --                                                                x.background)),
        },
        margins = dpi(10),
        widget = wibox.container.margin
    }

    s.mylayoutboxContainer = wibox.widget {
        screen = s,
        s.mylayoutbox,
        bg = colors.transparent,
        widget = wibox.container.background
    }

    function layoutPopup_toggle(s)
        if s.layoutPopup.visible then
            layoutPopup_hide(s)
        else
            layoutPopup_show(s)
        end
    end

    s.mylayoutboxContainer:connect_signal("button::press", function()
        s.mylayoutbox.top = dpi(11)
        s.mylayoutbox.left = dpi(11)
        s.mylayoutbox.right = dpi(9)
        s.mylayoutbox.bottom = dpi(9)
        layoutPopup_toggle(s)
        s.mylayoutboxContainer.bg = x.color0 .. "CC"
    end)

    s.mylayoutboxContainer:connect_signal("button::release", function()
        s.mylayoutboxContainer.bg = colors.transparent
        s.mylayoutbox.margins = dpi(10)
    end)

    helpers.add_hover_cursor(s.mylayoutboxContainer, "hand2")

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = beautiful.wibar_position,
        screen = s
    })

    -- Remove wibar on full screen
    -- local function remove_wibar(c)
    --     if c.fullscreen or c.maximized then
    --         c.screen.mywibox.visible = false
    --     else
    --         c.screen.mywibox.visible = true
    --     end
    -- end

    -- Remove wibar on full screen
    -- local function add_wibar(c)
    --     if c.fullscreen or c.maximized then
    --         c.screen.mywibox.visible = true
    --     end
    -- end

    --[[
    -- Hide bar when a splash widget is visible
    awesome.connect_signal("widgets::splash::visibility", function(vis)
        screen.primary.mywibox.visible = not vis
    end)
    ]] --

    -- client.connect_signal("property::fullscreen", remove_wibar)

    -- client.connect_signal("request::unmanage", add_wibar)


    -- Create the taglist widget
    s.mytaglist = require("ui.widgets.tagsklist")(s)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            layout = wibox.layout.fixed.horizontal,
            awesome_icon_container,
            s.mytaglist,
            s.mypromptbox
        },
        s.clock_container,
        {
            {
                mysystray,
                top = dpi(12),
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            require("ui.widgets.volume_icon"),
            chargingIcon,
            s.battery_bar_container,
            {
                s.mylayoutboxContainer,
                -- top = dpi(9),
                -- bottom = dpi(9),
                -- right = dpi(11),
                -- left = dpi(11),
                widget = wibox.container.margin
            },
            layout = wibox.layout.fixed.horizontal
        }
    }
    awesome.connect_signal("elemental::dismiss", function()
        control_center_hide(s)
        layoutPopup_hide(s)
    end)
end)

-- EOF ------------------------------------------------------------------------
