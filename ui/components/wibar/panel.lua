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
        -- image = gears.surface(beautiful.theme_assets.awesome_icon(512,
        --                                                           x.color6,
        --                                                          x.background)),
        image = icons.getIcon("beautyline/apps/scalable/distributor-logo-arch.svg"),
        -- image = icons.getIcon("candy-icons/apps/scalable/playonlinux.svg"),
        resize = true
    },
    margins = dpi(10),
    widget = wibox.container.margin
}

local awesome_icon_container = wibox.widget {
    awesome_icon,
    bg = x.background,
    widget = wibox.container.background
}

awesome_icon_container:connect_signal("button::press", function()
    awesome_icon_container.bg = x.color0
    awesome_icon.top = dpi(11)
    awesome_icon.left = dpi(11)
    awesome_icon.right = dpi(9)
    awesome_icon.bottom = dpi(9)
    dashboard_show()
end)

awesome_icon_container:connect_signal("button::release", function()
    awesome_icon.margins = dpi(10)
    awesome_icon_container.bg = x.background
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

local battery_bar_container = wibox.widget {
    {
        battery_bar,
        margins = {
            left = dpi(10),
            right = dpi(10),
            top = dpi(14),
            bottom = dpi(14)
        },
        widget = wibox.container.margin
    },
    bg = x.background,
    widget = wibox.container.background
}

local pgcharg = wibox.widget.imagebox(icons.getIcon("elenaLinebit/battery_popup_charging.png"), true)

local p20 = wibox.widget.imagebox(icons.getIcon("elenaLinebit/battery_20.png"), true)

local p30 = wibox.widget.imagebox(icons.getIcon("elenaLinebit/battery_30.png"), true)

local p50 = wibox.widget.imagebox(icons.getIcon("elenaLinebit/battery_50.png"), true)

local p70 = wibox.widget.imagebox(icons.getIcon("elenaLinebit/battery_70.png"), true)

local p90 = wibox.widget.imagebox(icons.getIcon("elenaLinebit/battery_90.png"), true)

local p100 = wibox.widget.imagebox(icons.getIcon("elenaLinebit/battery_100.png"), true)
pgcharg.visible = true
p20.visible = false
p30.visible = false
p50.visible = false
p70.visible = false
p90.visible = false
p100.visible = false
local battery_image = wibox.widget {
    {
        widget = pgcharg
    },
    {
        widget = p20
    },
    {
        widget = p30
    },
    {
        widget = p50
    },
    {
        widget = p70
    },
    {
        widget = p90
    },
    {
        widget = p100
    },
    layout = wibox.layout.stack
}

local battery_text = wibox.widget {
    markup = "No data available",
    widget = wibox.widget.textbox
}

local acpi_text = wibox.widget {
    markup = "No data available",
    widget = wibox.widget.textbox
}
local battery_title = wibox.widget {
    markup = helpers.bold_text(helpers.colorize_text("Power Manager", x.color15)),
    widget = wibox.widget.textbox
}
local a = wibox.widget {
    {
        battery_image,
        left = dpi(20),
        right = dpi(20),
        widget = wibox.container.margin
    },
    {
        helpers.vertical_pad(dpi(10)),
        battery_title,
        helpers.vertical_pad(dpi(10)),
        battery_text,
        helpers.vertical_pad(dpi(10)),
        acpi_text,
        helpers.vertical_pad(dpi(10)),
        layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.align.horizontal
}

battery_bar_container:connect_signal("button::press", function()
    battery_bar_container.bg = x.color0
end)

battery_bar_container:connect_signal("button::release", function()
    battery_popup_toggle(mouse.screen)
    battery_bar_container.bg = x.background
end)

-- Change cursor
helpers.add_hover_cursor(battery_bar_container, "hand2")

local batteryValue = 50
local charging = false

local function updateBatteryBar(value)
    battery_bar.value = value
    battery_bar.color = x.color10
    local battery_title_color = x.color4

    pgcharg.visible = false
    p20.visible = false
    p30.visible = false
    p50.visible = false
    p70.visible = false
    p90.visible = false
    p100.visible = false

    if (charging) then
        battery_bar.color = x.color4
        battery_title_color = x.color6
        awful.spawn.easy_async("acpi", function(value)
            acpi_text.markup = helpers.colorize_text(value, x.color6)
        end)
        pgcharg.visible = true
    else
        if value >= 90 and value <= 100 then
            p100.visible = true
            battery_bar.color = x.color10
            battery_title_color = x.color2
            awful.spawn.easy_async("acpi", function(value)
                acpi_text.markup = helpers.colorize_text(value, x.color2)
            end)
        elseif value >= 70 and value < 90 then
            p90.visible = true
            battery_bar.color = x.color10
            battery_title_color = x.color2
            awful.spawn.easy_async("acpi", function(value)
                acpi_text.markup = helpers.colorize_text(value, x.color2)
            end)
        elseif value >= 60 and value < 70 then
            p70.visible = true
            battery_bar.color = x.color10
            battery_title_color = x.color2
            awful.spawn.easy_async("acpi", function(value)
                acpi_text.markup = helpers.colorize_text(value, x.color2)
            end)
        elseif value >= 50 and value < 60 then
            p50.visible = true
            battery_bar.color = x.color11
            battery_title_color = x.color3
            awful.spawn.easy_async("acpi", function(value)
                acpi_text.markup = helpers.colorize_text(value, x.color3)
            end)
        elseif value >= 30 and value < 50 then
            p30.visible = true
            battery_bar.color = x.color11
            battery_title_color = x.color3
            awful.spawn.easy_async("acpi", function(value)
                acpi_text.markup = helpers.colorize_text(value, x.color3)
            end)
        elseif value >= 15 and value < 30 then
            p20.visible = true
            battery_bar.color = x.color9
            battery_title_color = x.color1
            awful.spawn.easy_async("acpi", function(value)
                acpi_text.markup = helpers.colorize_text(value, x.color1)
            end)
        else
            p20.visible = true
            battery_bar.color = x.color9
            battery_title_color = x.color1
            awful.spawn.easy_async("acpi", function(value)
                acpi_text.markup = helpers.colorize_text(value, x.color1)
            end)
        end
    end
    battery_title.markup = helpers.bold_text(helpers.colorize_text("Power Manager", battery_title_color))
    battery_text.markup = helpers.colorize_text("Battery level: " .. value .. "%", battery_bar.color)
end

awesome.connect_signal("evil::battery", function(value)
    batteryValue = value
    updateBatteryBar(batteryValue)
end)

awesome.connect_signal("evil::charger", function(plugged)
    charging = plugged
    chargingIcon.visible = charging
    --    if plugged then
    --        charging_text.markup = helpers.colorize_text('Charging: ' .. tostring(charging), x.color2)
    --    else
    --        charging_text.markup = helpers.colorize_text('Charging: ' .. tostring(charging), x.color1)
    --    end

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

local clock_container = wibox.widget {
    {
        {
            hourtextbox,
            minutetextbox,
            secondtextbox,
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal
        },
        margins = {
            top = dpi(9),
            bottom = dpi(9),
            left = dpi(11),
            right = dpi(11)
        },
        widget = wibox.container.margin
    },
    bg = x.background,
    widget = wibox.container.background
}

local datetooltip = awful.tooltip {};
datetooltip.preferred_alignments = { "middle", "front", "back" }
datetooltip.mode = "outside"
datetooltip:add_to_object(clock_container)
datetooltip.markup = helpers.colorize_text(os.date("%d"), x.color13) .. "/" ..
    helpers.colorize_text(os.date("%m"), x.color12) .. "/" ..
    helpers.colorize_text(os.date("%y"), x.color10)

clock_container:connect_signal("button::press", function()
    control_center_toggle(mouse.screen)
    clock_container.bg = x.color0
end)

clock_container:connect_signal("button::release", function()
    clock_container.bg = x.background
end)

-- Change cursor
helpers.add_hover_cursor(clock_container, "hand2")
-- Create the Wibar -----------------------------------------------------------

local mysystray = wibox.widget.systray()
mysystray.base_size = beautiful.systray_icon_size

screen.connect_signal("request::desktop_decoration", function(s)
    -- battery popup
    s.battery_popup = awful.popup {
        screen = s,
        widget = {
            a,
            margins = dpi(10),
            maximum_height = dpi(75),
            widget = wibox.container.margin
        },
        visible = false,
        ontop = true,
        maximum_height = dpi(150),
        maximum_width = dpi(450),
        placement = function(c)
            awful.placement.top_right(c, {
                margins = {
                    top = beautiful.wibar_height + dpi(10),
                    right = dpi(10)
                }
            })
        end,
        border_color = beautiful.border_color,
        border_width = beautiful.border_width,
    }

    local battery_popup_grabber
    function battery_popup_hide(s)
        s.battery_popup.visible = false
        awful.keygrabber.stop(battery_popup_grabber)

    end

    function battery_popup_show(s)

        -- naughty.notify({text = "starting the keygrabber"})
        battery_popup_grabber = awful.keygrabber.run(function(_, key, event)
            if event == "release" then
                return
            end
            -- Press Escape or q or F1 to hide itf
            if key == 'Escape' or key == 'q' or key == 'F1' then
                battery_popup_hide(s)
            end
        end)
        s.battery_popup.visible = true
    end

    function battery_popup_toggle(s)
        if s.battery_popup.visible then
            battery_popup_hide(s)
        else
            battery_popup_show(s)
        end
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create layoutbox widget
    s.layoutPopup = awful.popup {
        screen = s,
        widget = awful.widget.layoutlist {
            screen = s,
            base_layout = wibox.layout.flex.vertical

        },

        maximum_height = #awful.layout.layouts * 24,
        minimum_height = #awful.layout.layouts * 24,
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
        bg = x.background,
        fg = x.foreground
    }

    local layoutPopup_grabber
    function layoutPopup_hide(s)
        s.layoutPopup.visible = false
        awful.keygrabber.stop(layoutPopup_grabber)

    end

    function layoutPopup_show(s)

        -- naughty.notify({text = "starting the keygrabber"})
        layoutPopup_grabber = awful.keygrabber.run(function(_, key, event)
            if event == "release" then
                return
            end
            -- Press Escape or q or F1 to hide itf
            if key == 'Escape' or key == 'q' or key == 'F1' then
                layoutPopup_hide(s)
            end
        end)
        s.layoutPopup.visible = true
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
        bg = x.background,
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
        s.mylayoutboxContainer.bg = x.color0
    end)

    s.mylayoutboxContainer:connect_signal("button::release", function()
        s.mylayoutboxContainer.bg = x.background
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
        honor_workarea = true
    }

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
        clock_container,
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
            battery_bar_container,
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
    awesome.connect_signal("elemental::dismiss", function ()
        control_center_hide(s)
        battery_popup_hide(s)
        layoutPopup_hide(s)
    end)
end)

-- EOF ------------------------------------------------------------------------
