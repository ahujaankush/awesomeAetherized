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

-- layout popup
require("ui.widgets.layoutPopup")

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

helpers.add_hover_cursor(awesome_icon_container, "hand2")

-- Battery Bar Widget ---------------------------------------------------------

local battery_bar = wibox.widget {
    max_value = 100,
    value = 50,
    forced_width = dpi(100),
    shape = helpers.rrect(beautiful.border_radius),
    bar_shape = helpers.rrect(beautiful.border_radius),
    color = x.color10,
    background_color = x.color2 .. "22",
    border_width = dpi(0),
    border_color = beautiful.border_color,
    widget = wibox.widget.progressbar
}

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

local datetooltip = awful.tooltip {};
datetooltip.preferred_alignments = { "middle", "front", "back" }
datetooltip.mode = "outside"
datetooltip.markup = helpers.colorize_text(os.date("%d"), x.color13) .. "/" ..
    helpers.colorize_text(os.date("%m"), x.color12) .. "/" ..
    helpers.colorize_text(os.date("%y"), x.color10)



screen.connect_signal("request::desktop_decoration", function(s)

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
        x = 20, -- The x-coord of the popup
        y = 20, -- The y-coord of the popup
        height = dpi(550), -- The height of the popup
        width = dpi(450), -- The width of the popup
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

    -- Create the taglist widget
    s.mytagsklist = require("ui.widgets.tagsklist")(s)
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            layout = wibox.layout.fixed.horizontal,
            awesome_icon_container,
            s.mytagsklist,
            s.mypromptbox
        },
        s.clock_container,
        {
            require("ui.widgets.systray"),
            require("ui.widgets.volume_icon"),
            require("ui.widgets.brightness_icon"),
            s.mylayoutboxContainer,
            layout = wibox.layout.fixed.horizontal
        }
    }
    awesome.connect_signal("elemental::dismiss", function()
        control_center_hide(s)
        layoutPopup_hide(s)
    end)
end)

-- EOF ------------------------------------------------------------------------
