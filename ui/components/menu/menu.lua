local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")

local submenu_awesome = {
  { "Refresh", awesome.restart },
  { "Logout", function() awesome.quit() end },
  { "PowerOff", function() awful.spawn.with_shell('loginctl poweroff') end },
  { "Restart", function() awful.spawn.with_shell('loginctl reboot') end },
}

menu = awful.menu {
  items = {
    {
      "Awesome",
      submenu_awesome,
    },
    { "Terminal", user.terminal },
    { "Browser", user.browser },
    { "Editor", user.nvim },
    { "Files", user.file_manager },
  }
}

