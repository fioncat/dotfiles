# Hyprland Configuration

Useful for non-HHKB keyboard:

```
input {
    kb_options = caps:ctrl_shifted_capslock,altwin:swap_alt_win
}
```

Multiple monitors configuration:

```
# The main monitor, on the left
monitorv2 {
	output = DP-2
	mode = 2560x1440@100.00
	position = 0x0
	scale = 1
}

# The secondary monitor, on the right
monitorv2 {
	output = HDMI-A-2
	mode = 2560x1440@59.95
	position = 2560x0
	scale = 1
}
```

Assign workspaces to monitors:

```
# Main workspaces
workspace = 1, monitor:DP-2
workspace = 2, monitor:DP-1
workspace = 3, monitor:DP-2

# Secondary workspaces
workspace = 4, monitor:HDMI-A-2
workspace = 5, monitor:HDMI-A-2
workspace = 6, monitor:HDMI-A-2
workspace = 7, monitor:HDMI-A-2
workspace = 8, monitor:HDMI-A-2
workspace = 9, monitor:HDMI-A-2
```
