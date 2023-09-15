local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local helpers = require("helpers")
local naughty = require("naughty")
local gears = require("gears")
local empty = require("ui.widgets.control_center.notifs.empty")
local create = require("ui.widgets.control_center.notifs.make")

local clearButton = wibox.widget({
	font = beautiful.font_name.. " 22",
	markup = helpers.colorize_text("󰎟", x.color1),
	widget = wibox.widget.textbox,
	valign = "center",
	align = "center",
})
local title = wibox.widget({
	font = beautiful.font .. " 14",
	markup = "Notifications (0)",
	widget = wibox.widget.textbox,
	valign = "center",
	align = "center",
})
local header = wibox.widget({
	{
		{
			title,
			nil,
			clearButton,
			layout = wibox.layout.align.horizontal,
		},
		widget = wibox.container.margin,
		margins = 10,
	},
	bg = x.foreground .. "11",
	widget = wibox.container.background,
})
local finalcontent = wibox.widget({
	spacing = 20,
	scrollbar_width = 0,
	layout = require("modules.overflow").vertical,
})
local remove_notifs_empty = true

notif_center_reset_notifs_container = function()
	finalcontent:reset(finalcontent)
	finalcontent:insert(1, empty)
	remove_notifs_empty = true
	title.markup = "Notifications (0)"
end

notif_center_remove_notif = function(box)
	finalcontent:remove_widgets(box)

	if #finalcontent.children == 0 then
		finalcontent:insert(1, empty)
		title.markup = "Notifications (0)"
		remove_notifs_empty = true
	else
		title.markup = "Notifications (" .. #finalcontent.children .. ")"
	end
end
finalcontent:insert(1, empty)
naughty.connect_signal("request::display", function(n)
	if #finalcontent.children == 1 and remove_notifs_empty then
		finalcontent:reset(finalcontent)
		remove_notifs_empty = false
	end

	local appicon = n.icon or n.app_icon
	if not appicon then
		appicon = gears.filesystem.get_configuration_dir() .. "theme/icons/star.png"
	end
	title.markup = "Notifications (" .. #finalcontent.children + 1 .. ")"
	finalcontent:insert(1, create(appicon, n))
end)
local w
if beautiful.barDir == "top" or beautiful.barDir == "bottom" then
	w = 920
else
	w = 400
end

local finalwidget = wibox.widget({
	{
		header,
		{
			{
				finalcontent,
				spacing = dpi(20),
				widget = wibox.container.scroll.vertical,
				step_function = wibox.container.scroll,
				layout = wibox.layout.fixed.vertical,
			},
			margins = dpi(20),
			widget = wibox.container.margin,
		},
		spacing = 10,
		layout = wibox.layout.fixed.vertical,
	},
	forced_width = w,
	forced_height = 350,
	bg = x.color0 .. "cc",
	widget = wibox.container.background,
})

clearButton:buttons(gears.table.join(awful.button({}, 1, function()
	notif_center_reset_notifs_container()
end)))
return finalwidget
