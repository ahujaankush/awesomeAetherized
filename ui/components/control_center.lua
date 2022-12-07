local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")
local rubato = require("modules.rubato")

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
        opacity   = beautiful.control_center_opacity 
    }

    s.control_center_slide = rubato.timed {
        pos = s.geometry.y - s.control_center.height,
        rate = 60,
        duration = 0.3,
        easing = rubato.quadratic,
        subscribed = function(pos)
            s.control_center.y = s.geometry.y + pos
        end
    }


    s.control_center_fade = rubato.timed {
        pos = 0,
        rate = 60,
        intro = 0.1,
        duration = 0.3,
        easing = rubato.quadratic,
        subscribed = function(pos)
            s.control_center.opacity = pos
        end
    }

    s.control_center_timer = gears.timer {
        timeout = 0.5,
        single_shot = true,
        callback = function()
            s.control_center.visible = false
        end
    }

    s.control_center_grabber = nil
    function control_center_hide(s)
        s.control_center_slide.target = s.geometry.y - s.control_center.height
        s.control_center_fade.target = 0
        s.control_center_timer:start()
        awful.keygrabber.stop(s.control_center_grabber)
    end

    function control_center_show(s)

        -- naughty.notify({text = "starting the keygrabber"})
        s.control_center_grabber = awful.keygrabber.run(function(_, key, event)
            if event == "release" then
                return
            end
            -- Press Escape or q or F1 to hide itf
            if key == 'Escape' or key == 'q' or key == 'F1' then
                control_center_hide(s)
            end
        end)
        s.control_center.visible = true
        s.control_center_slide.target = s.geometry.y + beautiful.wibar_height + dpi(10)
        s.control_center_fade.target = beautiful.control_center_opacity
        customCalendarWidget.date = os.date('*t')
    end

    function control_center_toggle(s)
        if s.control_center.visible then
            control_center_hide(s)
        else
            control_center_show(s)
        end
    end

end)
