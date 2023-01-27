local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local apps = require("apps")
local helpers = require("helpers")
local awful = require("awful")
local colorMod = require("modules.color")
local rubato = require("modules.rubato")

-- define colors for smooth fading
local bg_active = colorMod.color({ hex = x.color0 })
local bg_inactive = colorMod.color({ hex = x.color0 })
local bg_hover = colorMod.color({ hex = x.color8 })
local fg_active = colorMod.color({ hex = x.foreground })
local fg_inactive = colorMod.color({ hex = x.color7 })
local fg_hover = colorMod.color({ hex = x.foreground })

local btn_widget = function(args)
	local btn_widget = {}
	function btn_widget:new()
		self.bg = args.bg
		self.bg_hover = args.bg_hover
		self.bg_active = args.bg_active
		self.bg_inactive = args.bg_inactive
		self.fg = args.fg
		self.fg_hover = args.fg_hover
		self.fg_active = args.fg_active
		self.fg_inactive = args.fg_inactive
		self.icon_font = args.icon_font
		self.text_font = args.text_font
		self.icon = args.icon
		self.icon_active = helpers.colorize_text(args.icon_active, self.fg_active.hex)
		self.icon_inactive = helpers.colorize_text(args.icon_inactive, self.fg_inactive.hex)
		self.text = helpers.colorize_text(args.text, self.fg.hex)
		self.press_func = args.press_func
		self.transition = colorMod.transition(self.bg, bg_active, colorMod.transition.HSLA)

		self.inner = wibox.widget({
			{
				id = "icon",
				widget = wibox.widget.textbox,
				font = self.icon_font,
				markup = self.icon,
				halign = "center",
				align = "center",
				forced_height = dpi(85),
			},
			fg = self.fg.hex,
			bg = self.bg.hex,
			shape = helpers.rrect(beautiful.border_radius),
			widget = wibox.container.background,
		})

		self.container = wibox.widget({
			self.inner,
			{
				markup = self.text,
				font = self.text_font,
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox,
			},
			spacing = dpi(6),
			layout = wibox.layout.fixed.vertical,
		})

		function self:fade(from, to)
			self.transition = colorMod.transition(from, to)
			self.transitionFunc = rubato.timed({
				pos = 0,
				duration = 0.2,
				rate = user.animation_rate,
				intro = 0,
				outro = 0,
				easing = rubato.easing.zero,
				subscribed = function(pos)
					self.inner:set_bg(self.transition(pos).hex)
				end,
			})
			self.transitionFunc.target = 1
		end

		function self:set_icon(markup)
			self.inner:get_children_by_id("icon")[1]:set_markup_silently(markup)
		end

		self.inner:connect_signal("mouse::enter", function()
			self:fade(self.bg, self.bg_hover)
		end)

		self.inner:connect_signal("mouse::leave", function()
			self:fade(self.bg_hover, self.bg)
		end)

		self.inner:connect_signal("button::press", function()
			self.press_func(self)
		end)
	end

	btn_widget:new()
	return btn_widget
end
local network_status = true
local network_btn = btn_widget({
	bg = bg_active,
	bg_hover = bg_hover,
	bg_active = bg_active,
	bg_inactive = bg_inactive,
	fg = fg_active,
	fg_hover = fg_hover,
	fg_active = fg_active,
	fg_inactive = fg_inactive,
	icon_font = "JetBrainsMono Nerd Font 26",
	text_font = beautiful.font,
	icon = "",
	icon_active = "",
	icon_inactive = "睊",
	text = "Network",
	press_func = function(self)
		network_status = not network_status
		if network_status then
			awful.spawn.with_shell("nmcli radio wifi on")
			self:set_icon(self.icon_active)
			self.bg = bg_active
		else
			awful.spawn.with_shell("nmcli radio wifi off")
			self:set_icon(self.icon_inactive)
			self.bg = bg_inactive
		end
	end,
})

local bluetooth_status = true
local bluetooth_btn = btn_widget({
	bg = bg_active,
	bg_hover = bg_hover,
	bg_active = bg_active,
	bg_inactive = bg_inactive,
	fg = fg_active,
	fg_hover = fg_hover,
	fg_active = fg_active,
	fg_inactive = fg_inactive,
	icon_font = "JetBrainsMono Nerd Font 26",
	text_font = beautiful.font,
	icon = "",
	icon_active = "",
	icon_inactive = "",
	text = "Bluetooth",
	press_func = function(self)
		bluetooth_status = not bluetooth_status
		if bluetooth_status then
			awful.spawn.with_shell("bluetoothctl power on")
		else
			awful.spawn.with_shell("bluetoothctl power off")
		end
	end,
})

awesome.connect_signal("evil::bluetooth", function(status)
	if status then
		bluetooth_btn:set_icon(bluetooth_btn.icon_active)
		bluetooth_btn.bg = bg_active
	else
		bluetooth_btn:set_icon(bluetooth_btn.icon_inactive)
		bluetooth_btn.bg = bg_inactive
	end
	bluetooth_status = status
end)

local audio_btn = btn_widget({
	bg = bg_active,
	bg_hover = bg_hover,
	bg_active = bg_active,
	bg_inactive = bg_inactive,
	fg = fg_active,
	fg_hover = fg_hover,
	fg_active = fg_active,
	fg_inactive = fg_inactive,
	icon_font = "JetBrainsMono Nerd Font 26",
	text_font = beautiful.font,
	icon = "墳",
	icon_active = "墳",
	icon_inactive = "ﱝ",
	text = "Audio",
	press_func = function()
		helpers.volume_control(0)
	end,
})

awesome.connect_signal("evil::volume", function(value, muted)
	if muted then
		audio_btn:set_icon(audio_btn.icon_inactive)
		audio_btn.bg = bg_inactive
	else
		audio_btn:set_icon(audio_btn.icon_active)
		audio_btn.bg = bg_active
	end
end)

local notifications_btn = btn_widget({
	bg = bg_active,
	bg_hover = bg_hover,
	bg_active = bg_active,
	bg_inactive = bg_inactive,
	fg = fg_active,
	fg_hover = fg_hover,
	fg_active = fg_active,
	fg_inactive = fg_inactive,
	icon_font = "JetBrainsMono Nerd Font 26",
	text_font = beautiful.font,
	icon = naughty.suspende and "" or "",
	icon_active = "",
	icon_inactive = "",
	text = "Notifications",
	press_func = function(self)
		naughty.suspended = not naughty.suspended
		if naughty.suspended then
			self:set_icon(self.icon_inactive)
			audio_btn.bg = bg_inactive
		else
			self:set_icon(self.icon_active)
			audio_btn.bg = bg_active
		end
	end,
})

local screenshot_btn = btn_widget({
	bg = bg_active,
	bg_hover = bg_hover,
	bg_active = bg_active,
	bg_inactive = bg_inactive,
	fg = fg_active,
	fg_hover = fg_hover,
	fg_active = fg_active,
	fg_inactive = fg_inactive,
	icon_font = "JetBrainsMono Nerd Font 26",
	text_font = beautiful.font,
	icon = "",
	icon_active = "",
	icon_inactive = "",
	text = "Screenshot",
	press_func = function()
		apps.screenshot("selection", 5)
	end,
})

local bluelight_status = false
local light_btn = btn_widget({
	bg = bg_active,
	bg_hover = bg_hover,
	bg_active = bg_active,
	bg_inactive = bg_inactive,
	fg = fg_active,
	fg_hover = fg_hover,
	fg_active = fg_active,
	fg_inactive = fg_inactive,
	icon_font = "JetBrainsMono Nerd Font 26",
	text_font = beautiful.font,
	icon = "",
	icon_active = "",
	icon_inactive = "",
	text = "Blue Light",
	press_func = function(self)
		bluelight_status = not bluelight_status
		if bluelight_status then
			self:set_icon(self.icon_active)
			self.bg = bg_active
			apps.night_mode("on")
		else
			self:set_icon(self.icon_inactive)
			self.bg = bg_inactive
			apps.night_mode("off")
		end
	end,
})

return wibox.widget({
	{
		network_btn.container,
		bluetooth_btn.container,
		audio_btn.container,
		notifications_btn.container,
		screenshot_btn.container,
		light_btn.container,
		homogeneous = true,
		expand = true,
		forced_num_cols = 3,
		forced_num_rows = 2,
		spacing = dpi(20),
		layout = wibox.layout.grid,
	},
	widget = wibox.container.margin,
	margins = {
		left = dpi(20),
		right = dpi(20),
	},
})
