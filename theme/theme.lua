local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme_name = "aether"
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local icons = require("icons")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local icon_path = os.getenv("HOME") .. "/.config/awesome/icons/"
local layout_icon_path = os.getenv("HOME") .. "/.config/awesome/theme/layout/"
local titlebar_icon_path = os.getenv("HOME") .. "/.config/awesome/theme/titlebar/"
local taglist_icon_path = os.getenv("HOME") .. "/.config/awesome/theme/taglist/"
local tip = titlebar_icon_path --alias to save time/space
local xrdb = xresources.get_current_theme()
-- local theme = dofile(themes_path.."default/theme.lua")
local theme = {}

-- Set theme wallpaper.
-- It won't change anything if you are using feh to set the wallpaper like I do.
theme.wallpaper = os.getenv("HOME") .. "/Pictures/Wallpaper/5bwdct0isf3a1.jpg"
-- Set the theme font. This is the font that will be used by default in menus, bars, titlebars etc.
theme.font_name = "CaskaydiaCove Nerd Font Mono"
theme.font      = theme.font_name .. " 11"
-- theme.font          = "monospace 11"

-- This is how to get other .Xresources values (beyond colors 0-15, or custom variables)
-- local cool_color = awesome.xrdb_get_value("", "color16")

theme.bg_dark     = x.background
theme.bg_normal   = x.background
theme.bg_focus    = x.color0
theme.bg_urgent   = x.color0
theme.bg_minimize = x.color0
theme.bg_systray  = x.background

theme.fg_normal   = x.color7
theme.fg_focus    = x.foreground
theme.fg_urgent   = x.color1
theme.fg_minimize = x.color8

-- Gaps
theme.useless_gap   = dpi(5)
-- This could be used to manually determine how far away from the
-- screen edge the bars / notifications should be.
theme.screen_margin = dpi(5)

-- Borders
theme.border_width  = dpi(0)
theme.border_color  = x.background
theme.border_normal = x.background
theme.border_focus  = x.background
-- Rounded corners
theme.border_radius = dpi(5)

-- Titlebars
-- (Titlebar items can be customized in titlebars.lua)
theme.titlebars_enabled = true
theme.titlebar_size = dpi(35)
theme.titlebar_title_enabled = true
theme.titlebar_font = theme_name.." bold 9"
-- Window title alignment: left, right, center
theme.titlebar_title_align = "center"
-- Titlebar position: top, bottom, left, right
theme.titlebar_position = "left"
theme.titlebar_bg = x.background.. "BF"
-- theme.titlebar_bg_focus = x.color12
-- theme.titlebar_bg_normal = x.color8
theme.titlebar_fg_focus = x.color7
theme.titlebar_fg_normal = x.color7
theme.titlebar_fg = x.color7

-- Notifications
-- ============================
-- Note: Some of these options are ignored by my custom
-- notification widget_template
-- ============================
-- Position: bottom_left, bottom_right, bottom_middle,
--         top_left, top_right, top_middle
theme.notification_position = "top_right"
theme.notification_border_width = dpi(0)
theme.notification_border_radius = theme.border_radius
theme.notification_border_color = x.color8
theme.notification_bg = x.background
theme.notification_fg = x.foreground
theme.notification_crit_bg = x.background
theme.notification_crit_fg = x.color1
theme.notification_icon_size = dpi(60)
-- theme.notification_height = dpi(80)
-- theme.notification_width = dpi(300)
theme.notification_margin = dpi(16)
theme.notification_opacity = 0.75
theme.notification_font = theme.font_name.." 11"
theme.notification_padding = theme.screen_margin * 2
theme.notification_spacing = theme.screen_margin * 4

theme.notification_osd_bg = x.background
theme.notification_osd_indicator_bg = x.color0
theme.notification_osd_fg = x.foreground
theme.notification_osd_opacity = 0.85


-- Notification Center
-- ============================
theme.clear_icon = icon_path .. "notif-center/clear.png"
theme.clear_grey_icon = icon_path .. "notif-center/clear_grey.png"
theme.delete_icon = icon_path .. "notif-center/delete.png"
theme.delete_grey_icon = icon_path .. "notif-center/delete_grey.png"


-- Edge snap
theme.snap_shape = gears.shape.rectangle
theme.snap_bg = x.foreground
theme.snap_border_width = dpi(3)

-- Tag names
theme.tagnames = {
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
}

-- Widget separator
theme.separator_text = " - "
--theme.separator_text = " :: "
--theme.separator_text = " • "
-- theme.separator_text = " •• "
theme.separator_fg = x.color8

-- Wibar(s)
-- Keep in mind that these settings could be ignored by the bar theme
theme.wibar_position = "top"
theme.wibar_height = dpi(45)
theme.wibar_fg = x.foreground
theme.wibar_bg = x.background
theme.wibar_opacity = 0.9
theme.wibar_border_color = x.color0
theme.wibar_border_width = dpi(0)
theme.wibar_border_radius = dpi(0)
theme.wibar_width = dpi(380)

theme.prefix_fg = x.color8

theme.systray_icon_spacing = dpi(10)
theme.systray_icon_size = dpi(20)
theme.systray_max_rows = 1

--There are other variable sets
--overriding the default one when
--defined, the sets are:
--taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
--tasklist_[bg|fg]_[focus|urgent]
--titlebar_[bg|fg]_[normal|focus]
--tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
--mouse_finder_[color|timeout|animate_timeout|radius|factor]
--prompt_[fg|bg|fg_cursor|bg_cursor|font]
--hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
--Example:
--theme.taglist_bg_focus = "#ff0000"

theme.hotkeys_bg = x.background
theme.hotkeys_fg = x.foreground
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_border_color = x.color5
theme.hotkeys_modifiers_fg = x.color7
theme.hotkeys_label_bg = x.color0
theme.hotkeys_label_fg = x.foreground
theme.hotkeys_font = theme.font
--Tasklist
theme.tasklist_font = "sans medium 8"
theme.tasklist_disable_icon = false
theme.tasklist_plain_task_name = true
theme.tasklist_bg_focus = x.background
theme.tasklist_fg_focus = x.foreground
theme.tasklist_bg_normal = x.background
theme.tasklist_fg_normal = x.foreground
theme.tasklist_bg_minimize = x.background
theme.tasklist_fg_minimize = x.color8
-- theme.tasklist_font_minimized = "sans italic 8"
theme.tasklist_bg_urgent = x.background
theme.tasklist_fg_urgent = x.color3
theme.tasklist_spacing = dpi(10)
theme.tasklist_align = "center"

theme.tasklist_shape_border_width = 2
theme.tasklist_shape_border_color = x.color4 .. "85"

theme.tasklist_shape_border_width_focus = 2
theme.tasklist_shape_border_color_focus = x.color4

theme.tasklist_shape_border_width_minimized = 2
theme.tasklist_shape_border_color_minimized = x.color2 .. "50"

theme.tasklist_shape_border_width_urgent = 2
theme.tasklist_shape_border_color_urgent = x.color1 .. "80"

-- Sidebar
-- (Sidebar items can be customized in sidebar.lua)
theme.sidebar_bg = x.background
theme.sidebar_fg = x.color15
theme.sidebar_opacity = 0.9
theme.sidebar_position = "left" -- left or right
theme.sidebar_width = dpi(300)
theme.sidebar_x = 0
theme.sidebar_y = 0
theme.sidebar_height_multip = 1 -- this value is multiplied with the screen height
theme.sidebar_border_radius = dpi(0) --theme.border_radius

-- Dashboard
theme.dashboard_bg = x.color0 .. "44"
theme.dashboard_fg = x.color15
theme.dashboard_opacity = 0.9

-- control center
theme.control_center_opacity = 0.9

-- app drawer
theme.app_drawer_opacity = 0.9

-- battery popup (wibar)
theme.battery_popup_opacity = 0.9

-- layout list (popup)
theme.layoutPopup_opacity = 0.9

-- Exit screen
theme.exit_screen_bg = x.color0 .. "44"
theme.exit_screen_fg = x.color7
theme.exit_screen_font = "sans 20"
theme.exit_screen_icon_size = dpi(180)

-- Lock screen
theme.lock_screen_bg = x.color0 .. "44"
theme.lock_screen_fg = x.color7

-- Prompt
theme.prompt_fg = x.color12

-- Text Taglist (default)
theme.taglist_font = "monospace bold 9"
theme.taglist_bg_focus = colors.transparent
theme.taglist_fg_focus = x.foreground
theme.taglist_bg_occupied = colors.transparent
theme.taglist_fg_occupied = x.color8
theme.taglist_bg_empty = colors.transparent
theme.taglist_fg_empty = x.background
theme.taglist_bg_urgent = colors.transparent
theme.taglist_fg_urgent = x.color3
theme.taglist_disable_icon = true
theme.taglist_spacing = dpi(0)


-- Variables set for theming the menu:
theme.menu_height       = dpi(40)
theme.menu_width        = dpi(180)
theme.menu_bg_normal    = x.background
theme.menu_fg_normal    = x.color7
theme.menu_bg_focus     = x.color0
theme.menu_fg_focus     = x.foreground
theme.menu_border_width = dpi(10)
theme.menu_border_color = x.background

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Titlebar buttons
-- Define the images to load
theme.titlebar_close_button_normal                    = tip .. "close_normal.svg"
theme.titlebar_close_button_focus                     = tip .. "close_focus.svg"
theme.titlebar_minimize_button_normal                 = tip .. "minimize_normal.svg"
theme.titlebar_minimize_button_focus                  = tip .. "minimize_focus.svg"
theme.titlebar_ontop_button_normal_inactive           = tip .. "ontop_normal_inactive.svg"
theme.titlebar_ontop_button_focus_inactive            = tip .. "ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_active             = tip .. "ontop_normal_active.svg"
theme.titlebar_ontop_button_focus_active              = tip .. "ontop_focus_active.svg"
theme.titlebar_sticky_button_normal_inactive          = tip .. "sticky_normal_inactive.svg"
theme.titlebar_sticky_button_focus_inactive           = tip .. "sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_active            = tip .. "sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_active             = tip .. "sticky_focus_active.svg"
theme.titlebar_floating_button_normal_inactive        = tip .. "floating_normal_inactive.svg"
theme.titlebar_floating_button_focus_inactive         = tip .. "floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_active          = tip .. "floating_normal_active.svg"
theme.titlebar_floating_button_focus_active           = tip .. "floating_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive       = tip .. "maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive        = tip .. "maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active         = tip .. "maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active          = tip .. "maximized_focus_active.svg"
-- (hover)
theme.titlebar_close_button_normal_hover              = tip .. "close_normal_hover.svg"
theme.titlebar_close_button_focus_hover               = tip .. "close_focus_hover.svg"
theme.titlebar_minimize_button_normal_hover           = tip .. "minimize_normal_hover.svg"
theme.titlebar_minimize_button_focus_hover            = tip .. "minimize_focus_hover.svg"
theme.titlebar_ontop_button_normal_inactive_hover     = tip .. "ontop_normal_inactive_hover.svg"
theme.titlebar_ontop_button_focus_inactive_hover      = tip .. "ontop_focus_inactive_hover.svg"
theme.titlebar_ontop_button_normal_active_hover       = tip .. "ontop_normal_active_hover.svg"
theme.titlebar_ontop_button_focus_active_hover        = tip .. "ontop_focus_active_hover.svg"
theme.titlebar_sticky_button_normal_inactive_hover    = tip .. "sticky_normal_inactive_hover.svg"
theme.titlebar_sticky_button_focus_inactive_hover     = tip .. "sticky_focus_inactive_hover.svg"
theme.titlebar_sticky_button_normal_active_hover      = tip .. "sticky_normal_active_hover.svg"
theme.titlebar_sticky_button_focus_active_hover       = tip .. "sticky_focus_active_hover.svg"
theme.titlebar_floating_button_normal_inactive_hover  = tip .. "floating_normal_inactive_hover.svg"
theme.titlebar_floating_button_focus_inactive_hover   = tip .. "floating_focus_inactive_hover.svg"
theme.titlebar_floating_button_normal_active_hover    = tip .. "floating_normal_active_hover.svg"
theme.titlebar_floating_button_focus_active_hover     = tip .. "floating_focus_active_hover.svg"
theme.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = tip .. "maximized_focus_inactive_hover.svg"
theme.titlebar_maximized_button_normal_active_hover   = tip .. "maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_active_hover    = tip .. "maximized_focus_active_hover.svg"

-- You can use your own layout icons like this:
theme.layout_fairh      = layout_icon_path .. "fairh.png"
theme.layout_fairv      = layout_icon_path .. "fairv.png"
theme.layout_floating   = layout_icon_path .. "floating.png"
theme.layout_magnifier  = layout_icon_path .. "magnifier.png"
theme.layout_max        = layout_icon_path .. "max.png"
theme.layout_fullscreen = layout_icon_path .. "fullscreen.png"
theme.layout_tilebottom = layout_icon_path .. "tilebottom.png"
theme.layout_tileleft   = layout_icon_path .. "tileleft.png"
theme.layout_tile       = layout_icon_path .. "tile.png"
theme.layout_tiletop    = layout_icon_path .. "tiletop.png"
theme.layout_spiral     = layout_icon_path .. "spiral.png"
theme.layout_dwindle    = layout_icon_path .. "dwindle.png"
theme.layout_cornernw   = layout_icon_path .. "cornernw.png"
theme.layout_cornerne   = layout_icon_path .. "cornerne.png"
theme.layout_cornersw   = layout_icon_path .. "cornersw.png"
theme.layout_cornerse   = layout_icon_path .. "cornerse.png"
theme.layout_mstab      = layout_icon_path .. "mstab.png"
theme.layout_centered   = layout_icon_path .. "centered.png"
theme.layout_equalarea   = layout_icon_path .. "equalarea.png"
theme.layout_machi      =  layout_icon_path.."machi.png"

-- Recolor layout icons
-- theme = theme_assets.recolor_layout(theme, x.color1)

-- Noodle widgets customization --
-- Desktop mode widget variables
-- Symbols     
-- theme.desktop_mode_color_floating = x.color4
-- theme.desktop_mode_color_tile = x.color3
-- theme.desktop_mode_color_max = x.color1
-- theme.desktop_mode_text_floating = "f"
-- theme.desktop_mode_text_tile = "t"
-- theme.desktop_mode_text_max = "m"

-- Minimal tasklist widget variables
theme.minimal_tasklist_visible_clients_color = x.color4
theme.minimal_tasklist_visible_clients_text = ""
theme.minimal_tasklist_hidden_clients_color = x.color7
theme.minimal_tasklist_hidden_clients_text = ""

-- Mpd song
theme.mpd_song_title_color = x.color7
theme.mpd_song_artist_color = x.color7
theme.mpd_song_paused_color = x.color8

-- Volume bar
theme.volume_bar_active_color = x.color5
theme.volume_bar_active_background_color = x.color0
theme.volume_bar_muted_color = x.color8
theme.volume_bar_muted_background_color = x.color0

-- Temperature bar
theme.temperature_bar_active_color = x.color1
theme.temperature_bar_background_color = x.color0

-- Battery bar
theme.battery_bar_active_color = x.color6
theme.battery_bar_background_color = x.color0

-- CPU bar
theme.cpu_bar_active_color = x.color2
theme.cpu_bar_background_color = x.color0

-- RAM bar
theme.ram_bar_active_color = x.color4
theme.ram_bar_background_color = x.color0

-- Brightness bar
theme.brightness_bar_active_color = x.color3
theme.brightness_bar_background_color = x.color0

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = os.getenv("HOME").."/.icons/oomox-aesthetic-dark/"

-- Task Preview
theme.task_preview_widget_border_radius = 12 -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = x.background -- The bg color of the widget
theme.task_preview_widget_border_color = x.color5 -- The border color of the widget
theme.task_preview_widget_border_width = 1 -- The border width of the widget
theme.task_preview_widget_margin = 20 -- The margin of the widget
theme.bling_preview_bottom_margin = dpi(60)

theme.fade_duration = 250

-- Tag Preview
theme.tag_preview_widget_border_radius = theme.border_radius
theme.tag_preview_client_border_radius = theme.border_radius * 0.75
theme.tag_preview_client_opacity = 0.6
theme.tag_preview_client_bg = x.color0
theme.tag_preview_client_border_color = x.background
theme.tag_preview_client_border_width = theme.border_width
theme.tag_preview_widget_bg = x.background
theme.tag_preview_widget_border_color = theme.border_color
theme.tag_preview_widget_border_width = theme.border_width * 0
theme.tag_preview_widget_margin = dpi(10)

-- window switcher
theme.window_switcher_widget_bg = x.background .. "CC" -- The bg color of the widget
theme.window_switcher_widget_border_width = dpi(5) -- The border width of the widget
theme.window_switcher_widget_border_radius = theme.border_radius -- The border radius of the widget
theme.window_switcher_widget_border_color = x.background -- The border color of the widget
theme.window_switcher_clients_spacing = dpi(15) -- The space between each client item
theme.window_switcher_client_icon_horizontal_spacing = dpi(5) -- The space between client icon and text
theme.window_switcher_client_width = dpi(250) -- The width of one client widget
theme.window_switcher_client_height = dpi(350) -- The height of one client widget
theme.window_switcher_client_margins = dpi(20) -- The margin between the content and the border of the widget
theme.window_switcher_thumbnail_margins = dpi(10) -- The margin between one client thumbnail and the rest of the widget
theme.thumbnail_scale = false -- If set to true, the thumbnails fit policy will be set to "fit" instead of "auto"
theme.window_switcher_name_margins = dpi(10) -- The margin of one clients title to the rest of the widget
theme.window_switcher_name_valign = "center" -- How to vertically align one clients title
theme.window_switcher_name_forced_width = dpi(200) -- The width of one title
theme.window_switcher_name_font = theme.font_name.." 11" -- The font of all titles
theme.window_switcher_name_normal_color = x.foreground -- The color of one title if the client is unfocused
theme.window_switcher_name_focus_color = x.color5 -- The color of one title if the client is focused
theme.window_switcher_icon_valign = "center" -- How to vertially align the one icon
theme.window_switcher_icon_width = dpi(50) -- Thw width of one icon


-- tabbed
theme.tabbed_spawn_in_tab = true           -- whether a new client should spawn into the focused tabbing container

-- tabbar general
theme.tabbar_ontop  = false
theme.tabbar_radius = theme.border_radius                -- border radius of the tabbar
theme.tabbar_style = "modern"         -- style of the tabbar ("default", "boxes" or "modern")
theme.tabbar_font = theme.font          -- font of the tabbar
theme.tabbar_size = dpi(35)                 -- size of the tabbar
theme.tabbar_position = "bottom"          -- position of the tabbar
theme.tabbar_bg_normal = x.background     -- background color of the focused client on the tabbar
theme.tabbar_fg_normal = x.foreground   -- foreground color of the focused client on the tabbar
theme.tabbar_bg_focus  = x.color0     -- background color of unfocused clients on the tabbar
theme.tabbar_fg_focus  = x.foreground     -- foreground color of unfocused clients on the tabbar
theme.tabbar_bg_focus_inactive = nil   -- background color of the focused client on the tabbar when inactive
theme.tabbar_fg_focus_inactive = nil   -- foreground color of the focused client on the tabbar when inactive
theme.tabbar_bg_normal_inactive = nil  -- background color of unfocused clients on the tabbar when inactive
theme.tabbar_fg_normal_inactive = nil  -- foreground color of unfocused clients on the tabbar when inactive
theme.tabbar_disable = false           -- disable the tab bar entirely

-- mstab
theme.mstab_bar_disable = false             -- disable the tabbar
theme.mstab_bar_ontop = true               -- whether you want to allow the bar to be ontop of clients
theme.mstab_dont_resize_slaves = false      -- whether the tabbed stack windows should be smaller than the
                                            -- currently focused stack window (set it to true if you use
                                            -- transparent terminals. False if you use shadows on solid ones
theme.mstab_bar_padding = "default"         -- how much padding there should be between clients and your tabbar
                                            -- by default it will adjust based on your useless gaps.
                                            -- If you want a custom value. Set it to the number of pixels (int)
theme.mstab_border_radius = theme.border_radius               -- border radius of the tabbar
theme.mstab_bar_height = dpi(35)                 -- height of the tabbar
theme.mstab_tabbar_position = "bottom"         -- position of the tabbar (mstab currently does not support left,right)
theme.mstab_tabbar_style = "modern"        -- style of the tabbar ("default", "boxes" or "modern")
                                            -- defaults to the tabbar_style so only change if you want a
                                            -- different style for mstab and tabbed

-- the following variables are currently only for the "modern" tabbar style
theme.tabbar_color_close = x.color1        -- chnges the color of the close button
theme.tabbar_color_min   = x.color3        -- chnges the color of the minimize button
theme.tabbar_color_float = x.color5        -- chnges the color of the float button


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
