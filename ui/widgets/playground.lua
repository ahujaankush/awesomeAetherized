local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("icons")
local helpers = require("helpers")

-- Button for settings shape to rectangle
local winshapeButtonRec = wibox.widget {
    {
        {
            text = "Rectangle",
            widget = wibox.widget.textbox
        },
        top = 4,
        bottom = 4,
        left = 8,
        right = 8,
        widget = wibox.container.margin
    },
    shape_border_width = 1,
    shape_border_color = x.color14, -- outline
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background
}
local old_cursor, old_wibox
winshapeButtonRec:connect_signal("mouse::enter", function(c)
    c.shape_border_color = x.color6 -- outline
    c:set_bg(x.color8 .. "6D")
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
winshapeButtonRec:connect_signal("mouse::leave", function(c)
    c.shape_border_color = x.color14 -- outline
    c:set_bg(x.color0)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)
winshapeButtonRec:connect_signal("button::press", function(c)
    client.focus.shape = function(cr, width, height)
        gears.shape.rectangle(cr, width, height)
    end, c:set_bg(x.color8)
end)
winshapeButtonRec:connect_signal("button::release", function(c)
    c:set_bg(x.color8 .. "6D")
end)
-- Button for settings shape to circle
local winshapeButtonCirc = wibox.widget {
    {
        {
            text = "Circle",
            widget = wibox.widget.textbox
        },
        top = 4,
        bottom = 4,
        left = 8,
        right = 8,
        widget = wibox.container.margin
    },
    shape_border_width = 1,
    shape_border_color = x.color4, -- outline
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background
}
winshapeButtonCirc:connect_signal("mouse::enter", function(c)
    c.shape_border_color = x.color12 -- outline
    c:set_bg(x.color8 .. "6D")
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
winshapeButtonCirc:connect_signal("mouse::leave", function(c)
    c.shape_border_color = x.color4 -- outline
    c:set_bg(x.color0)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)
winshapeButtonCirc:connect_signal("button::press", function(c)
    client.focus.shape = function(cr, width, height)
        gears.shape.circle(cr, width, height)
    end, c:set_bg(x.color8)
end)
winshapeButtonCirc:connect_signal("button::release", function(c)
    c:set_bg(x.color8 .. "6D")
end)

-- Button for settings shape to triangle
local winshapeButtonTri = wibox.widget {
    {
        {
            text = "Triangle",
            widget = wibox.widget.textbox
        },
        top = 4,
        bottom = 4,
        left = 8,
        right = 8,
        widget = wibox.container.margin
    },
    shape_border_width = 1,
    shape_border_color = x.color5, -- outline
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background
}
winshapeButtonTri:connect_signal("mouse::enter", function(c)
    c.shape_border_color = x.color13 -- outline
    c:set_bg(x.color8 .. "6D")
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
winshapeButtonTri:connect_signal("mouse::leave", function(c)
    c.shape_border_color = x.color5 -- outline
    c:set_bg(x.color0)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)
winshapeButtonTri:connect_signal("button::press", function(c)
    client.focus.shape = function(cr, width, height)
        gears.shape.isosceles_triangle(cr, width, height)
    end, c:set_bg(x.color8)
end)
winshapeButtonTri:connect_signal("button::release", function(c)
    c:set_bg(x.color8 .. "6D")
end)

local winshapeContainer = wibox.widget {
    winshapeButtonRec,
    winshapeButtonCirc,
    winshapeButtonTri,
    spacing = dpi(5),
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
}

local function setBlur(strength)
    awful.spawn.with_shell([[bash -c "sed -i 's/.*blur-strength = .*/blur-strength = ]] .. strength ..
        [[;/g' \$HOME/.config/picom/picom.conf"]])
end

blur_slider = wibox.widget {
    bar_shape = gears.shape.rounded_rect,
    bar_height = dpi(3),
    bar_color = x.background,
    bar_active_color = x.color13,
    handle_color = x.background,
    handle_shape = gears.shape.circle,
    handle_border_color = x.color5,
    handle_border_width = dpi(2),
    value = 25,
    widget = wibox.widget.slider
}

awful.spawn.easy_async_with_shell([[bash -c "
		grep -F 'blur-strength =' $HOME/.config/picom/picom.conf | 
		awk 'NR==1 {print $3}' | tr -d ';'
		"]], function(stdout, stderr)
    local strength = stdout:match('%d+')
    blur_slider:set_value(math.floor(tonumber(strength) / 20 * 100))
end)

local applyBlur = wibox.widget {
    {
        image = icons.getIcon("beautyline/actions/scalable/blurimage.svg"),
        resize = true,
        clip_shape = helpers.rrect(beautiful.border_radius - 3),
        widget = wibox.widget.imagebox
    },
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background
}
applyBlur:connect_signal("mouse::enter", function(c)
    c:set_bg(x.color8 .. "6D")
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
applyBlur:connect_signal("mouse::leave", function(c)
    c:set_bg(x.color0)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)
applyBlur:connect_signal("button::press", function(c)
    setBlur(math.floor(blur_slider:get_value() / 50 * 10))
    c:set_bg(x.color8)
end)
applyBlur:connect_signal("button::release", function(c)
    c:set_bg(x.color8 .. "6D")
end)

-- update container

local update = wibox.widget {
    {
        {
            text = "Rectangle",
            widget = wibox.widget.textbox
        },
        top = 4,
        bottom = 4,
        left = 8,
        right = 8,
        widget = wibox.container.margin
    },
    shape_border_width = 1,
    shape_border_color = x.color14, -- outline
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background
}
update:connect_signal("mouse::enter", function(c)
    c.shape_border_color = x.color6 -- outline
    c:set_bg(x.color8 .. "6D")
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
update:connect_signal("mouse::leave", function(c)
    c.shape_border_color = x.color14 -- outline
    c:set_bg(x.color0)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)
update:connect_signal("button::press", function(c)
    client.focus.shape = function(cr, width, height)
        gears.shape.rectangle(cr, width, height)
    end, c:set_bg(x.color8)
end)
update:connect_signal("button::release", function(c)
    c:set_bg(x.color8 .. "6D")
end)

local update = wibox.widget {
    {
        {
            text = "Update",
            widget = wibox.widget.textbox
        },
        top = 4,
        bottom = 4,
        left = 8,
        right = 8,
        widget = wibox.container.margin
    },
    shape_border_width = 1,
    shape_border_color = x.color14, -- outline
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background
}
update:connect_signal("mouse::enter", function(c)
    c.shape_border_color = x.color6 -- outline
    c:set_bg(x.color8 .. "6D")
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
update:connect_signal("mouse::leave", function(c)
    c.shape_border_color = x.color14 -- outline
    c:set_bg(x.color0)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)
update:connect_signal("button::press", function(c)
    client.focus.shape = function(cr, width, height)
        gears.shape.rectangle(cr, width, height)
    end, c:set_bg(x.color8)
end)
update:connect_signal("button::release", function(c)
    c:set_bg(x.color8 .. "6D")
end)

local changelog = wibox.widget {
    {
        {
            text = "Changelog",
            widget = wibox.widget.textbox
        },
        top = 4,
        bottom = 4,
        left = 8,
        right = 8,
        widget = wibox.container.margin
    },
    shape_border_width = 1,
    shape_border_color = x.color14, -- outline
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background
}
changelog:connect_signal("mouse::enter", function(c)
    c.shape_border_color = x.color6 -- outline
    c:set_bg(x.color8 .. "6D")
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
changelog:connect_signal("mouse::leave", function(c)
    c.shape_border_color = x.color14 -- outline
    c:set_bg(x.color0)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)
changelog:connect_signal("button::press", function(c)
    client.focus.shape = function(cr, width, height)
        gears.shape.rectangle(cr, width, height)
    end, c:set_bg(x.color8)
end)
changelog:connect_signal("button::release", function(c)
    c:set_bg(x.color8 .. "6D")
end)

local snapshot = wibox.widget {
    {
        {
            text = "Snapshot",
            widget = wibox.widget.textbox
        },
        top = 4,
        bottom = 4,
        left = 8,
        right = 8,
        widget = wibox.container.margin
    },
    shape_border_width = 1,
    shape_border_color = x.color14, -- outline
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background
}
snapshot:connect_signal("mouse::enter", function(c)
    c.shape_border_color = x.color6 -- outline
    c:set_bg(x.color8 .. "6D")
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "hand1"
end)
snapshot:connect_signal("mouse::leave", function(c)
    c.shape_border_color = x.color14 -- outline
    c:set_bg(x.color0)
    if old_wibox then
        old_wibox.cursor = old_cursor
        old_wibox = nil
    end
end)
snapshot:connect_signal("button::press", function(c)
    client.focus.shape = function(cr, width, height)
        gears.shape.rectangle(cr, width, height)
    end, c:set_bg(x.color8)
end)
snapshot:connect_signal("button::release", function(c)
    c:set_bg(x.color8 .. "6D")
end)

local updateContainer = wibox.widget {
    update,
    changelog,
    snapshot,
    spacing = dpi(5),
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
}

local playground = wibox.widget {
    {
        {
            {
                {
                    {
                        {

                            image = icons.getIcon("Miya-icon-theme/src/apps/scalable/3Depict.svg"),
                            resize = true,
                            clip_shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.widget.imagebox
                        },
                        strategy = 'exact',
                        height = dpi(33),
                        width = dpi(33),
                        widget = wibox.container.constraint
                    },
                    {
                        markup = helpers.bold_text(helpers.colorize_text("A", x.color1) ..
                            helpers.colorize_text("E", x.color2) ..
                            helpers.colorize_text("T", x.color3) ..
                            helpers.colorize_text("H", x.color4) ..
                            helpers.colorize_text("E", x.color5) ..
                            helpers.colorize_text("R", x.color6) ..
                            helpers.colorize_text("I", x.color7) ..
                            helpers.colorize_text("Z", x.color9) ..
                            helpers.colorize_text("E", x.color10) ..
                            helpers.colorize_text("D ", x.color11) ..
                            helpers.colorize_text("P", x.color12) ..
                            helpers.colorize_text("L", x.color13) ..
                            helpers.colorize_text("A", x.color14) ..
                            helpers.colorize_text("Y", x.color1) ..
                            helpers.colorize_text("G", x.color2) ..
                            helpers.colorize_text("R", x.color3) ..
                            helpers.colorize_text("O", x.color4) ..
                            helpers.colorize_text("U", x.color5) ..
                            helpers.colorize_text("N", x.color6) ..
                            helpers.colorize_text("D", x.color9)),
                        font = beautiful.font_name .. " 17",
                        align = "center",
                        widget = wibox.widget.textbox
                    },
                    layout = wibox.layout.align.horizontal,
                    widget = wibox.container.margin
                },
                left = dpi(15),
                right = dpi(15),
                top = dpi(7),
                bottom = dpi(7),
                widget = wibox.container.margin
            },
            nil,
            bg = x.color0,
            shape = helpers.rrect(beautiful.border_radius),
            widget = wibox.container.background
        },
        top = dpi(4),
        left = dpi(10),
        right = dpi(10),
        bottom = dpi(4),
        widget = wibox.container.margin
    },
    {
        {
            {
                {
                    {
                        {
                            {
                                image = icons.getIcon("beautyline/apps/scalable/applications-interfacedesign.svg"),
                                resize = true,
                                clip_shape = helpers.rrect(beautiful.border_radius - 3),
                                widget = wibox.widget.imagebox
                            },
                            strategy = 'exact',
                            height = dpi(30),
                            width = dpi(30),
                            widget = wibox.container.constraint
                        },
                        --{
                        --    markup = helpers.bold_text(helpers.colorize_text("WinShape", x.color7)),
                        --    font = beautiful.font_name .. " 17",
                        --    align = "center",
                        --    widget = wibox.widget.textbox
                        --},
                        winshapeContainer,
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(15),
                        widget = wibox.container.margin
                    },
                    left = dpi(15),
                    right = dpi(15),
                    top = dpi(7),
                    bottom = dpi(7),
                    widget = wibox.container.margin
                },
                nil,
                bg = x.color0,
                shape = helpers.rrect(beautiful.border_radius),
                widget = wibox.container.background
            },
            top = dpi(4),
            left = dpi(10),
            right = dpi(10),
            bottom = dpi(4),
            widget = wibox.container.margin
        },
        {
            {
                {
                    {
                        {
                            {

                                image = icons.getIcon("beautyline/apps/scalable/show-background.svg"),
                                resize = true,
                                clip_shape = helpers.rrect(beautiful.border_radius - 3),
                                widget = wibox.widget.imagebox
                            },
                            strategy = 'exact',
                            height = dpi(30),
                            width = dpi(30),
                            widget = wibox.container.constraint
                        },
                        --{
                        --    markup = helpers.bold_text(helpers.colorize_text("Wawesomepaper", x.color7)),
                        --    font = beautiful.font_name .. " 17",
                        --    align = "center",
                        --    widget = wibox.widget.textbox
                        --},
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(15),
                        widget = wibox.container.margin
                    },
                    left = dpi(15),
                    right = dpi(15),
                    top = dpi(7),
                    bottom = dpi(7),
                    widget = wibox.container.margin
                },
                nil,
                bg = x.color0,
                shape = helpers.rrect(beautiful.border_radius),
                widget = wibox.container.background
            },
            top = dpi(4),
            left = dpi(10),
            right = dpi(10),
            bottom = dpi(4),
            widget = wibox.container.margin
        },
        {
            {
                {
                    {
                        {
                            {

                                image = icons.getIcon("Miya-icon-theme/src/apps/scalable/preferences-desktop-display.svg"),
                                resize = true,
                                clip_shape = helpers.rrect(beautiful.border_radius - 3),
                                widget = wibox.widget.imagebox
                            },
                            strategy = 'exact',
                            height = dpi(30),
                            width = dpi(30),
                            widget = wibox.container.constraint
                        },
                        --{
                        --    markup = helpers.bold_text(helpers.colorize_text("AetherizedWriter", x.color7)),
                        --    font = beautiful.font_name .. " 17",
                        --    align = "center",
                        --    widget = wibox.widget.textbox
                        --},
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(15),
                        widget = wibox.container.margin
                    },
                    left = dpi(15),
                    right = dpi(15),
                    top = dpi(7),
                    bottom = dpi(7),
                    widget = wibox.container.margin
                },
                nil,
                bg = x.color0,
                shape = helpers.rrect(beautiful.border_radius),
                widget = wibox.container.background
            },
            top = dpi(4),
            left = dpi(10),
            right = dpi(10),
            bottom = dpi(4),
            widget = wibox.container.margin
        },
        {
            {
                {
                    {
                        {
                            {

                                image = icons.getIcon("beautyline/actions/scalable/document-save-all.svg"),
                                resize = true,
                                clip_shape = helpers.rrect(beautiful.border_radius - 3),
                                widget = wibox.widget.imagebox
                            },
                            strategy = 'exact',
                            height = dpi(30),
                            width = dpi(30),
                            widget = wibox.container.constraint
                        },
                        --{
                        --    markup = helpers.bold_text(helpers.colorize_text("WriteCFG", x.color7)),
                        --    font = beautiful.font_name .. " 17",
                        --    align = "center",
                        --    widget = wibox.widget.textbox
                        --},
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(15),
                        widget = wibox.container.margin
                    },
                    left = dpi(15),
                    right = dpi(15),
                    top = dpi(7),
                    bottom = dpi(7),
                    widget = wibox.container.margin
                },
                nil,
                bg = x.color0,
                shape = helpers.rrect(beautiful.border_radius),
                widget = wibox.container.background
            },
            top = dpi(4),
            left = dpi(10),
            right = dpi(10),
            bottom = dpi(4),
            widget = wibox.container.margin
        },
        {
            {
                {
                    {
                        {
                            {

                                image = icons.getIcon("candy-icons/apps/scalable/system-software-install.svg"),
                                resize = true,
                                clip_shape = helpers.rrect(beautiful.border_radius - 3),
                                widget = wibox.widget.imagebox
                            },
                            strategy = 'exact',
                            height = dpi(30),
                            width = dpi(30),
                            widget = wibox.container.constraint
                        },
                        updateContainer,
                        --{
                        --    markup = helpers.bold_text(helpers.colorize_text("Update", x.color7)),
                        --    font = beautiful.font_name .. " 17",
                        --    align = "center",
                        --    widget = wibox.widget.textbox
                        --},
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(15),
                        widget = wibox.container.margin
                    },
                    left = dpi(15),
                    right = dpi(15),
                    top = dpi(7),
                    bottom = dpi(7),
                    widget = wibox.container.margin
                },
                nil,
                bg = x.color0,
                shape = helpers.rrect(beautiful.border_radius),
                widget = wibox.container.background
            },
            top = dpi(4),
            left = dpi(10),
            right = dpi(10),
            bottom = dpi(4),
            widget = wibox.container.margin
        },
        {
            {
                {
                    {
                        {
                            applyBlur,
                            strategy = 'exact',
                            height = dpi(30),
                            width = dpi(30),
                            widget = wibox.container.constraint
                        },
                        --{
                        --    markup = helpers.bold_text(helpers.colorize_text("Blurry", x.color7)),
                        --    font = beautiful.font_name .. " 17",
                        --    align = "center",
                        --    widget = wibox.widget.textbox
                        --},
                        blur_slider,
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(15),
                        widget = wibox.container.margin
                    },
                    left = dpi(15),
                    right = dpi(15),
                    top = dpi(7),
                    bottom = dpi(7),
                    widget = wibox.container.margin
                },
                nil,
                bg = x.color0,
                shape = helpers.rrect(beautiful.border_radius),
                widget = wibox.container.background
            },
            top = dpi(4),
            left = dpi(10),
            right = dpi(10),
            bottom = dpi(4),
            widget = wibox.container.margin
        },
        widget = wibox.container.background,
        layout = wibox.layout.fixed.vertical
    },
    {
        {

            {
                markup = helpers.bold_text(helpers.colorize_text("By Ankush AHUJA", x.color5)),
                font = beautiful.font_name .. " 6",
                align = "left",
                widget = wibox.widget.textbox
            },
            {
                markup = helpers.bold_text(helpers.colorize_text("Aetherized Beta Features", x.color6)),
                font = beautiful.font_name .. " 6",
                align = "right",
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.align.horizontal,
            widget = wibox.container.background
        },
        top = dpi(2),
        left = dpi(10),
        right = dpi(10),
        bottom = dpi(2),
        widget = wibox.container.margin
    },
    layout = wibox.layout.align.vertical,
    widget = wibox.container.background
}

return playground
