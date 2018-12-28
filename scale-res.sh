#!/bin/bash

gsettings set org.gnome.desktop.interface scaling-factor 2
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gdk/WindowScalingFactor': <2>}"
xrandr --output DP-0 --scale 1.5x1.5
xrandr --output DP-0 --panning 3840x2160
