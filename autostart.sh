killall firewall-applet
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
nm-applet &
blueman-applet &
firewall-applet &
picom &
xfce4-power-manager -d &
xsetroot -cursor_name left_ptr &
sh .config/conky/Fornax/start.sh
