local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")
local bling = require("modules.bling")
local rubato = require("modules.rubato")

local args = {
    apps_per_column = 3,
    apps_per_row = 4,
    sort_alphabetically = false,
    reverse_sort_alphabetically = true,
    background = x.background,
    app_normal_color = x.color0,
    app_normal_hover_color = x.color8,
    app_selected_color = x.color8,
    app_selected_hover_color = x.color8,
    shape = helpers.rrect(beautiful.border_radius),
    app_shape = helpers.rrect(beautiful.border_radius),
    pp_name_halign = "center",
    app_name_font = beautiful.font,
    prompt_font = beautiful.font,
    app_name_normal_color = x.color7,
    app_name_selected_color = x.foreground,
    app_show_generic_name = false,
    prompt_color = {
        type = 'linear',
        from = {0},
        to = {dpi(2000)},
        stops = {{0, x.color6}, {0.50, x.color4}}
    },
    opacity = 0.9
}

app_launcher = bling.widget.app_launcher(args)