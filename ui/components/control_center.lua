local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")

local notify_cont = wibox.widget {
    screen = s,
    {
        {
            nil,
            require("ui.components.notif-center"),
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        forced_width = dpi(400),
        margins = 10,

        widget = wibox.container.margin
    },
    shape = helpers.rrect(dpi(8)),
    bg = x.background,
    widget = wibox.container.background
}

local customCalendarWidget = require("ui.widgets.calendar")
customCalendarWidget.spacing = dpi(10)

local calendar_cont = wibox.widget {
    screen = s,
    {
        {
            nil,
            customCalendarWidget,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        forced_width = dpi(400),
        forced_height = dpi(475),
        margins = 10,
        widget = wibox.container.margin
    },
    shape = helpers.rrect(dpi(8)),
    bg = x.background,
    minimum_width = notify_cont.width,
    widget = wibox.container.background
}

local control_center_setup = wibox.widget {
    screen = s,
    {
        calendar_cont,
        notify_cont,
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal,
        bg = x.background
    },
    margins = 10,
    forced_height = dpi(495),
    widget = wibox.container.margin
}


screen.connect_signal("request::desktop_decoration", function(s)

    s.control_center = awful.popup {
        screen    = s,
        widget    = control_center_setup,
        placement = function(c)
            awful.placement.top(c, {
                margins = {
                    top = beautiful.wibar_height + dpi(10),
                    right = dpi(10)
                }
            })
        end,
        ontop     = true,
        visible   = false,
        bg        = x.color0,
        fg        = x.foreground,
    }

    local control_center_grabber
    function control_center_hide(s)
        s.control_center.visible = false
        awful.keygrabber.stop(control_center_grabber)

    end

    if s.control_center.visble then
        customCalendarWidget.date = os.date('*t')
    end

    function control_center_show(s)

        -- naughty.notify({text = "starting the keygrabber"})
        control_center_grabber = awful.keygrabber.run(function(_, key, event)
            if event == "release" then
                return
            end
            -- Press Escape or q or F1 to hide itf
            if key == 'Escape' or key == 'q' or key == 'F1' then
                control_center_hide(s)
            end
        end)
        s.control_center.visible = true
    end

    function control_center_toggle(s)
        if s.control_center.visible then
            control_center_hide(s)
        else
            control_center_show(s)
        end
    end

end)
