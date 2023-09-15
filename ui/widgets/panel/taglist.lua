local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")
return function(s)
	local taglist = awful.widget.taglist({
		layout = {
			spacing = 15,
			layout = wibox.layout.fixed.horizontal,
		},
		style = {
			shape = helpers.rrect(50),
		},
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
		widget_template = {
			{
				{
					{
						markup = "",
						shape = helpers.rrect(3),
						widget = wibox.widget.textbox,
					},
					valign = "center",
					id = "background_role",
					shape = helpers.rrect(1),
					widget = wibox.container.background,
					forced_width = 10,
					forced_height = 11,
				},
				left = dpi(6),
				right = dpi(6),
				widget = wibox.container.margin,
			},
			widget = wibox.container.place,
			create_callback = function(self, tag)
				self.taganim = rubato.timed({
					duration = 0.12,
					easing = rubato.easing.linear,
					subscribed = function(pos)
						self:get_children_by_id("background_role")[1].forced_width = pos
					end,
				})
				self.update = function()
					if tag.selected then
						self.taganim.target = 30
					else
						self.taganim.target = 11
					end
				end

				self.update()

				self:connect_signal("mouse::enter", function()
					-- BLING: Only show widget when there are clients in the tag
					if #tag:clients() > 0 then
						-- BLING: Update the widget with the new tag
						awesome.emit_signal("bling::tag_preview::update", tag)
						-- BLING: Show the widget
						awesome.emit_signal("bling::tag_preview::visibility", s, true)
					end
				end)
				self:connect_signal("mouse::leave", function()
					-- BLING: Turn the widget off
					awesome.emit_signal("bling::tag_preview::visibility", s, false)

					if self.has_backup then
						self.bg = self.backup
					end
				end)
			end,
			update_callback = function(self)
				self.update()
			end,
		},
	})
	local taglist_container = wibox.widget({
		{
			taglist,
			left = dpi(6),
			right = dpi(6),
			widget = wibox.container.margin,
		},
		bg = x.color0,
		shape = helpers.rrect(beautiful.border_radius),
		buttons = {
			awful.button({}, 3, function(t)
				dashboard_toggle(awful.screen.focused())
			end),
		},
		widget = wibox.container.background,
	})
	return taglist_container
end
