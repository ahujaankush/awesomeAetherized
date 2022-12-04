local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local color = require("modules.color")
local rubato = require("modules.rubato")

local volumeColors = {
    color.color({ hex = x.color1 }), -- muted or 0
    color.color({ hex = x.color3 }), -- 1-10
    color.color({ hex = x.color4 }), -- 10-30
}
local currentIcon = "ﱝ"
local currentColor = x.color1;
-- the icon itself
local volume_icon = wibox.widget {
    widget = wibox.widget.textbox,
    markup = helpers.colorize_text(currentIcon, volumeColors[1].hex),
    font = beautiful.font_name .. " 20",
    resize = true
}

local currState = true;
local oldState = true;

-- container with the icon
local volume_icon_container = wibox.widget {
    {

        volume_icon,
        widget = wibox.container.margin,
        margins = dpi(12)
    },
    widget = wibox.container.background
}

-- tooltip
local volume_icon_tooltip = awful.tooltip {};
volume_icon_tooltip.preferred_alignments = { "middle", "front", "back" }
volume_icon_tooltip.mode = "outside"
volume_icon_tooltip:add_to_object(volume_icon_container)
volume_icon_tooltip.markup = helpers.colorize_text("0", volumeColors[1].hex)

-- set icon and color based on volume

awesome.connect_signal("evil::volume", function(value, muted)

    oldState = currState
    currState = muted

    if muted then
        local transition = color.transition(color.color({ hex = currentColor }), volumeColors[1], color.transition.hsl)
        currentIcon = "ﱝ"

        if currState ~= oldState then
            local transitionRubato = rubato.timed {
                pos = 0,
                rate = 60,
                intro = 0.1,
                duration = 1,
                easing = rubato.quadratic,
                subscribed = function(pos)
                    currentColor = transition(pos).hex
                    volume_icon.markup = helpers.colorize_text(currentIcon, currentColor)
                    volume_icon_tooltip.markup = helpers.colorize_text(value, currentColor)

                end
            }
            transitionRubato.target = 1
        end

        
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
        local transition = color.transition(volumeColors[2], volumeColors[3], color.transition.hsl)
        currentColor = transition(value / 100).hex

        if currState ~= oldState then
            local umuteTransition = color.transition(volumeColors[1], color.color({ hex = currentColor }), color.transition.hsl)
            local transitionRubato = rubato.timed {
                pos = 0,
                rate = 60,
                intro = 0.1,
                duration = 1,
                easing = rubato.quadratic,
                subscribed = function(pos)
                    currentColor = umuteTransition(pos).hex
                    volume_icon.markup = helpers.colorize_text(currentIcon, currentColor)
                    volume_icon_tooltip.markup = helpers.colorize_text(value, currentColor)

                end
            }
            transitionRubato.target = 1
        end
        volume_icon.markup = helpers.colorize_text(currentIcon, currentColor)
        volume_icon_tooltip.markup = helpers.colorize_text(value, currentColor)
    end

end)


-- toggle mute on button press

volume_icon_container:connect_signal("button::press", function()
    helpers.volume_control(0)
end)

return volume_icon_container
