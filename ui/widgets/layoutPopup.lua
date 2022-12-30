local helpers = require("helpers")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("modules.rubato")

screen.connect_signal("request::desktop_decoration", function(s)
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
        shape = helpers.rrect(beautiful.border_radius),
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
        callback = function() s.layoutPopup.visible = false end
    }

    s.layoutPopup_fade_height = rubato.timed {
        pos = 0,
        intro = 0,
        outro = 0.18,
        duration = 0.35,
        easing = rubato.easing.bouncy,
        subscribed = function(pos) s.layoutPopup.maximum_height = pos end
    }

    s.layoutPopup_fade_width = rubato.timed {
        pos = 0,
        intro = 0,
        outro = 0.18,
        duration = 0.35,
        easing = rubato.easing.bouncy,
        subscribed = function(pos) s.layoutPopup.maximum_width = pos end
    }
end)

function layoutPopup_hide(s)
    s.layoutPopup_fade_height.target = 0
    s.layoutPopup_fade_width.target = 0
    s.layoutPopup_timer:start()
    awful.keygrabber.stop(s.layoutPopup_grabber)

end

function layoutPopup_show(s)

    -- naughty.notify({text = "starting the keygrabber"})
    s.layoutPopup_grabber = awful.keygrabber.run(
                                function(_, key, event)
            if event == "release" then return end
            -- Press Escape or q or F1 to hide itf
            if key == 'Escape' or key == 'q' or key == 'F1' then
                layoutPopup_hide(s)
            end
        end)
    s.layoutPopup.visible = true
    s.layoutPopup_fade_height.target = #awful.layout.layouts * dpi(50)
    s.layoutPopup_fade_width.target = dpi(175)
end

function layoutPopup_toggle(s)
    if s.layoutPopup.visible then
        layoutPopup_hide(s)
    else
        layoutPopup_show(s)
    end
end
