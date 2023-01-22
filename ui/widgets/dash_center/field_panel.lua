local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local apps = require("apps")
local helpers = require("helpers")
local colorMod = require("modules.color")
local rubato = require("modules.rubato")

-- define colors for smooth fading
local bg_active = colorMod.color({ hex = x.color0 })
local bg_inactive = colorMod.color({ hex = x.color0 })
local bg_hover = colorMod.color({ hex = x.color8 })
local fg_active = colorMod.color({ hex = x.foreground })
local fg_inactive = colorMod.color({ hex = x.foreground })
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
		self.icon_active = args.icon_active
		self.icon_inactive = args.icon_inactive
		self.text = args.text
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
	press_func = function()
		helpers.volume_control(0)
	end,
})

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
	press_func = function()
		helpers.volume_control(0)
	end,
})

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
		audio_btn:set_icon(helpers.colorize_text(audio_btn.icon_inactive, x.color7))
		audio_btn.bg = bg_inactive
	else
		audio_btn:set_icon(helpers.colorize_text(audio_btn.icon_active, x.foreground))
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
			self:set_icon(helpers.colorize_text("", x.color7))
			audio_btn.bg = bg_inactive
		else
			self:set_icon(helpers.colorize_text("", x.foreground))
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
		helpers.volume_control(0)
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
	icon_active = "",
	icon_inactive = "",
	text = "Blue Light",
	press_func = function(self)
		if bluelight_status then
			self:set_icon(helpers.colorize_text("", x.color7))
			apps.night_mode("off")
		else
			self:set_icon(helpers.colorize_text("", x.foreground))
			apps.night_mode("on")
		end
		bluelight_status = not bluelight_status
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
