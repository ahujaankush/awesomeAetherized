local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("apps")
-- local naughty = require("naughty")

local helpers = require("helpers")

-- Appearance
-- local button_size = beautiful.app_drawer_icon_size or dpi(100)
--
local keybinds = {}

-- Helper function that creates buttons given a text symbol, color, hover_color
-- and the command to run on click.
local function create_button(symbol, color, hover_color, cmd, key)
    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        align = "center",
        valign = "center",
        font = "JetBrainsMono Nerd Font 40",
        forced_width = dpi(180),
        forced_height = dpi(200),
        widget = wibox.widget.textbox
    }

    -- Press "animation"
    icon:connect_signal("button::press", function(_, _, __, button)
        if button == 3 then
            icon.markup = helpers.colorize_text(symbol, hover_color.."55")
        end
    end)
    icon:connect_signal("button::release", function ()
        icon.markup = helpers.colorize_text(symbol, hover_color)
    end)

    -- Hover "animation"
    icon:connect_signal("mouse::enter", function ()
        icon.markup = helpers.colorize_text(symbol, hover_color)
    end)
    icon:connect_signal("mouse::leave", function ()
        icon.markup = helpers.colorize_text(symbol, color)
    end)

    -- Change cursor on hover
    helpers.add_hover_cursor(icon, "hand1")

    -- Adds mousebinds if cmd is provided
    if cmd then
        icon:buttons(gears.table.join(
            awful.button({ }, 1, function ()
                cmd()
            end),
            awful.button({ }, 3, function ()
                cmd()
            end)
        ))
    end

    -- Add keybind to dict, if given
    if key then
        keybinds[key] = cmd
    end

    return icon
end

-- Create app buttons
local terminal = create_button("", x.color1, x.color9, function() awful.spawn.with_shell(user.terminal) end, "q")
local editor = create_button("﬏", x.color4, x.color12, apps.editor, "w")
local vim = create_button("", x.color2, x.color10, apps.nvim, "e")
local browser = create_button("爵", x.color5, x.color13, apps.browser, "r")
local mail = create_button("", x.color3, x.color11, apps.mail, "t")

local files = create_button("", x.color3, x.color11, apps.file_manager, "a")
local office = create_button("", x.color5, x.color13, apps.office, "s")
local okular = create_button("", x.color6, x.color14, apps.okular, "d")
local schedule = create_button("", x.color2, x.color10, apps.networks, "f")
local pyroWrite = create_button("", x.color1, x.color9, apps.editor, "g")

local resources = create_button("", x.color2, x.color10, function() awful.spawn.with_shell(user.file_manager.." "..user.dirs.resources) end, "z")
local workspace = create_button("", x.color1, x.color9, function() awful.spawn.with_shell(user.file_manager.." "..user.dirs.workspace) end, "x")
local student = create_button("拾", x.color5, x.color13, function() awful.spawn.with_shell(user.file_manager.." "..user.dirs.student) end, "c")
local books = create_button("", x.color3, x.color11, function() awful.spawn.with_shell(user.file_manager.." "..user.dirs.books) end, "v")
local toDO = create_button("", x.color6, x.color14, function() awful.spawn.with_shell(user.file_manager.." "..user.dirs.toDO) end, "b")

local night_mode = create_button("望", x.color4, x.color12, apps.night_mode, "y")
local keys = create_button("", x.color2, x.color10, apps.passwords, "u")
local compositor = create_button("", x.color3, x.color11, apps.compositor, "i")
local restart_awesome = create_button("ﰇ", x.color1, x.color9, awesome.restart, "o")
local quit_awesome = create_button("", x.color5, x.color13, awesome.quit, "p")


-- Create the widget
app_drawer = wibox({visible = false, ontop = true, type = "dock"})
awful.placement.maximize(app_drawer)

app_drawer.bg = "#00000000"
-- app_drawer.bg = beautiful.app_drawer_bg or x.background or "#111111"
app_drawer.fg = beautiful.app_drawer_fg or x.foreground or "#FEFEFE"

-- Add app drawer or mask to each screen
for s in screen do
    if s == screen.primary then
        s.app_drawer = app_drawer
    else
        s.app_drawer = helpers.screen_mask(s, beautiful.lock_screen_bg or beautiful.exit_screen_bg or x.background)
    end
end

local function set_visibility(v)
    for s in screen do
        s.app_drawer.visible = v
    end
end

local app_drawer_grabber
function app_drawer_hide()
    awful.keygrabber.stop(app_drawer_grabber)
    set_visibility(false)
end

function app_drawer_show()
    -- naughty.notify({text = "starting the keygrabber"})
    app_drawer_grabber = awful.keygrabber.run(function(_, key, event)
        local invalid_key = false

        -- Debug
        -- naughty.notify({ title = event, text = key })
        -- if event == "press" and key == "Alt_L" or key == "Alt_R" then
        --     naughty.notify({ title = "you pressed alt" })
        -- end
        -- if event == "release" and key == "Alt_L" or key == "Alt_R" then
        --     naughty.notify({ title = "you released alt" })
        -- end

        if event == "release" then return end

        if keybinds[key] then
            keybinds[key]()
        else
            invalid_key = true
        end

        if not invalid_key or key == 'Escape' then
            app_drawer_hide()
        end
    end)

    set_visibility(true)
end

app_drawer:buttons(gears.table.join(
    -- Left click - Hide app_drawer
    awful.button({ }, 1, function ()
        app_drawer_hide()
    end),
    -- Right click - Hide app_drawer
    awful.button({ }, 2, function ()
        app_drawer_hide()
    end),
    -- Middle click - Hide app_drawer
    awful.button({ }, 2, function ()
        app_drawer_hide()
    end)
))

local function create_stripe(widgets, bg)
    local buttons = wibox.widget {
        -- spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal
    }

    for _, widget in ipairs(widgets) do
        buttons:add(widget)
    end

    local stripe = wibox.widget {
        {
            nil,
            {
                nil,
                buttons,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            expand = "none",
            layout = wibox.layout.align.vertical
        },
        bg = bg,
        widget = wibox.container.background
    }

    return stripe
end

app_drawer:setup {
    -- Background
    {
        -- Stripes
        create_stripe({terminal, editor, vim, browser, mail}, "#00000000"),
        create_stripe({files, office, okular, schedule, pyroWrite}, x.color8.."20"),
        create_stripe({resources, workspace, student, books, toDO}, x.color8.."40"),
        create_stripe({night_mode, keys, compositor, restart_awesome, quit_awesome}, x.color8.."60"),
        layout = wibox.layout.flex.vertical
    },
    bg = x.background.."FF",
    -- bg = x.background,
    -- bg = "#00000000",
    opacity = beautiful.app_drawer_opacity,
    widget = wibox.container.background
}

