local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")
local rubato = require("modules.rubato")

local notify_cont = wibox.widget({
	{
		require("ui.components.notif-center"),
    margins = dpi(11),
	  widget = wibox.container.margin,
	},
	forced_width = dpi(500),
	forced_height = dpi(790),
  bg = x.background,
  widget = wibox.container.background,

})

local customCalendarWidget = require("ui.widgets.calendar")
customCalendarWidget.spacing = dpi(20)

local emptyNotifbox = require("ui.components.notif-center.build-notifbox.empty-notifbox") 

local user_cont = wibox.widget({
	{
    nil,
    {
      require("ui.widgets.control_center.user"),
      customCalendarWidget,
      layout = wibox.layout.fixed.vertical
    },
		forced_width = dpi(500),
		margins = dpi(11),
    expand = "none",
    layout = wibox.layout.align.horizontal,
		widget = wibox.container.margin,
	},
	shape = helpers.rrect(beautiful.border_radius),
	bg = x.background,
	minimum_width = notify_cont.width,
	widget = wibox.container.background,
})

local control_center_setup = wibox.widget({
	{
		user_cont,
		notify_cont,
		spacing = dpi(12),
		layout = wibox.layout.fixed.horizontal,
		bg = x.background,
	},
	margins = dpi(12),
	widget = wibox.container.margin,
})

screen.connect_signal("request::desktop_decoration", function(s)
	s.control_center = awful.popup({
		screen = s,
		widget = control_center_setup,
		placement = function(c)
			awful.placement.top(c, {
				margins = {
					top = beautiful.wibar_height + beautiful.useless_gap,
				},
			})
		end,
		ontop = true,
		visible = false,
		bg = x.color0,
		fg = x.foreground,
		shape = helpers.rrect(beautiful.border_radius),
		opacity = beautiful.control_center_opacity,
	})

	s.control_center_slide = rubato.timed({
		pos = s.geometry.y - s.control_center.height,
		intro = 0.25,
		clamp_position = true,
		outro = 0.25,
		duration = 0.5,
		easing = rubato.easing.quadratic,
		subscribed = function(pos)
			s.control_center.y = s.geometry.y + pos
		end,
	})

	s.control_center_timer = gears.timer({
		timeout = 0.5,
		single_shot = true,
		callback = function()
			s.control_center.visible = false
		end,
	})

	s.control_center_grabber = nil
	function control_center_hide(s)
		s.control_center_slide.target = s.geometry.y - s.control_center.height
		s.control_center_timer:start()
		awful.keygrabber.stop(s.control_center_grabber)
	end

	function control_center_show(s)
		-- naughty.notify({text = "starting the keygrabber"})
		s.control_center_grabber = awful.keygrabber.run(function(_, key, event)
			if event == "release" then
				return
			end
			-- Press Escape or q or F1 to hide itf
			if key == "Escape" or key == "q" or key == "F1" then
				control_center_hide(s)
			end
		end)
		s.control_center.visible = true
		s.control_center_slide.target = s.geometry.y + beautiful.wibar_height + beautiful.useless_gap
		customCalendarWidget.date = os.date("*t")
	end

	function control_center_toggle(s)
		if s.control_center.visible then
			control_center_hide(s)
		else
			control_center_show(s)
		end
	end
end)
