-- wibar.lua
-- Wibar (top bar)
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gcolor = require("gears.color")
local helpers = require("helpers")
local bling = require("modules.bling")

local awesome_icon = wibox.widget({
	{
		widget = wibox.widget.imagebox,
		image = gcolor.recolor_image(icondir .. "desk/awesomewm.svg", x.color5),
		resize = true,
	},
	margins = dpi(5),
	widget = wibox.container.margin,
})

local awesome_icon_container = wibox.widget({
	awesome_icon,
	bg = x.color0,
	shape = helpers.rrect(beautiful.border_radius),
	widget = wibox.container.background,
})

awesome_icon_container:connect_signal("button::press", function()
	awesome_icon_container.bg = x.color8
	awesome_icon.top = dpi(6)
	awesome_icon.left = dpi(6)
	awesome_icon.right = dpi(4)
	awesome_icon.bottom = dpi(4)
end)

awesome_icon_container:connect_signal("button::release", function()
	awesome_icon.margins = dpi(5)
	awesome_icon_container.bg = x.color0
end)

helpers.add_hover_cursor(awesome_icon_container, "hand2")

-- Clock Widget ---------------------------------------------------------------

local hourtextbox = wibox.widget.textclock("%H", 3600)
hourtextbox.markup = hourtextbox.text

hourtextbox:connect_signal("widget::redraw_needed", function()
	hourtextbox.markup = hourtextbox.text
end)

local minutetextbox = wibox.widget.textclock("%M", 60)
minutetextbox.markup = minutetextbox.text

minutetextbox:connect_signal("widget::redraw_needed", function()
	minutetextbox.markup = minutetextbox.text
end)

local secondtextbox = wibox.widget.textclock("%S", 1)
secondtextbox.markup = secondtextbox.text
secondtextbox:connect_signal("widget::redraw_needed", function()
	secondtextbox.markup = secondtextbox.text
end)

local datetooltip = awful.tooltip({})
datetooltip.preferred_alignments = { "middle", "front", "back" }
datetooltip.mode = "outside"
datetooltip.markup = os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%y")

local clock_sep = wibox.widget({
	markup = ":",
	widget = wibox.widget.textbox,
})

screen.connect_signal("request::desktop_decoration", function(s)
	s.clock = wibox.widget({
		screen = s,
		{
			hourtextbox,
			clock_sep,
			minutetextbox,
			clock_sep,
			secondtextbox,
			layout = wibox.layout.fixed.horizontal,
		},
		margins = dpi(5),
		widget = wibox.container.margin,
	})

	s.clock_container = wibox.widget({
		screen = s,
		s.clock,
		bg = x.color0,
		shape = helpers.rrect(beautiful.border_radius),
		widget = wibox.container.background,
	})

	datetooltip:add_to_object(s.clock_container)
	-- Change cursor
	helpers.add_hover_cursor(s.clock_container, "hand2")

	s.clock_container:connect_signal("button::press", function()
		dash_center_toggle(s)
		s.clock_container.bg = x.color8
		s.clock.top = dpi(6)
		s.clock.left = dpi(6)
		s.clock.right = dpi(4)
		s.clock.bottom = dpi(4)
	end)

	s.clock_container:connect_signal("button::release", function()
		s.clock_container.bg = x.color0
		s.clock.margins = dpi(5)
	end)

	-- bling: task preview
	bling.widget.tag_preview.enable({
		show_client_content = true,
		placement_fn = function(c)
			awful.placement.top(c, {
				margins = {
					top = beautiful.wibar_height + beautiful.useless_gap,
				},
			})
		end,
		scale = 0.5,
		honor_padding = true,
		honor_workarea = true,
		background_widget = wibox.widget({ -- Set a background image (like a wallpaper) for the widget
			image = beautiful.wallpaper,
			horizontal_fit_policy = "fit",
			vertical_fit_policy = "fit",
			widget = wibox.widget.imagebox,
		}),
	})

	bling.widget.task_preview.enable({
		height = dpi(750), -- The height of the popup
		width = dpi(650), -- The width of the popup
		placement_fn = function(c)
			awful.placement.top_left(c, {
				margins = {
					top = beautiful.wibar_height + beautiful.useless_gap,
					left = beautiful.wibar_height + beautiful.useless_gap,
				},
			})
		end,
		-- Your widget will automatically conform to the given size due to a constraint container.
		widget_structure = {
			{
				{
					{
						id = "icon_role",
						widget = awful.widget.clienticon, -- The client icon
					},
					{
						id = "name_role", -- The client name / title
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.flex.horizontal,
				},
				widget = wibox.container.margin,
				margins = dpi(10),
			},
			{
				id = "image_role", -- The client preview
				resize = true,
				valign = "center",
				halign = "center",
				widget = wibox.widget.imagebox,
			},
			layout = wibox.layout.fixed.vertical,
		},
	})

	-- Create a promptbox for each screen
	s.mylayoutbox = wibox.widget({
		{
			widget = awful.widget.layoutbox({
				screen = s,
			}),
			--       image = gears.surface(beautiful.theme_assets.awesome_icon(512,
			--                                                                 x.color8,
			--                                                                x.background)),
		},
		margins = dpi(4),
		widget = wibox.container.margin,
	})

	s.mylayoutboxContainer = wibox.widget({
		screen = s,
		s.mylayoutbox,
		bg = x.color0,
		shape = helpers.rrect(beautiful.border_radius),
		widget = wibox.container.background,
	})

	s.mylayoutboxContainer:connect_signal("button::press", function()
		s.mylayoutbox.top = dpi(5)
		s.mylayoutbox.left = dpi(5)
		s.mylayoutbox.right = dpi(3)
		s.mylayoutbox.bottom = dpi(3)
		s.mylayoutboxContainer.bg = x.color8
	end)

	s.mylayoutboxContainer:connect_signal("button::release", function()
		s.mylayoutboxContainer.bg = x.color0
		s.mylayoutbox.margins = dpi(4)
	end)

	helpers.add_hover_cursor(s.mylayoutboxContainer, "hand2")

	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = awful.util.table.join(
			awful.button({}, 1, function(c)
				if c == client.focus then
					c.minimized = true
				else
					-- Without this, the following
					-- :isvisible() makes no sense
					c.minimized = false
					if not c:isvisible() and c.first_tag then
						c.first_tag:view_only()
					end
					-- This will also un-minimize
					-- the client, if needed
					client.focus = c
					c:raise()
				end
			end),
			awful.button({}, 2, function(c)
				c.kill(c)
			end),
			awful.button({}, 4, function()
				awful.client.focus.byidx(1)
			end),
			awful.button({}, 5, function()
				awful.client.focus.byidx(-1)
			end)
		),
		layout = {
			spacing = 2,
			layout = wibox.layout.fixed.horizontal,
		},
		-- Notice that there is *NO* wibox.wibox prefix, it is a template,
		-- not a widget instance.
		widget_template = {
			{
				{
					{
						id = "clienticon",
						widget = awful.widget.clienticon,
					},
					margins = 5,
					widget = wibox.container.margin,
				},
				id = "background_role",
				widget = wibox.container.background,
			},
			nil,
			create_callback = function(self, c, index, objects) --luacheck: no unused args
				self:get_children_by_id("clienticon")[1].client = c

				-- BLING: Toggle the popup on hover and disable it off hover
				self:connect_signal("mouse::enter", function()
					awesome.emit_signal("bling::task_preview::visibility", s, true, c)
				end)
				self:connect_signal("mouse::leave", function()
					awesome.emit_signal("bling::task_preview::visibility", s, false, c)
				end)
			end,
			layout = wibox.layout.align.vertical,
		},
	})

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = beautiful.wibar_position,
		screen = s,
	})

	-- Create the taglist widget
	s.mytaglist = require("ui.widgets.panel.taglist")(s)
	-- Add widgets to the wibox
	s.mywibox:setup({
		{
			layout = wibox.layout.align.horizontal,
			expand = "none",
			{
				awesome_icon_container,
				require("ui.widgets.panel.music"),
				s.mytasklist,
				layout = wibox.layout.fixed.horizontal,
				spacing = beautiful.wibar_elements_gap,
			},
			s.mytaglist,
			{
				require("ui.widgets.panel.systray"),
				s.clock_container,
				s.mylayoutboxContainer,
				spacing = beautiful.wibar_elements_gap,
				layout = wibox.layout.fixed.horizontal,
			},
		},
		widget = wibox.container.margin,
		margins = beautiful.wibar_elements_gap,
	})
	awesome.connect_signal("elemental::dismiss", function()
		dash_center_hide(s)
	end)
end)

-- EOF ------------------------------------------------------------------------
