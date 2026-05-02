# Lightbar FX GoldHEN Plugin
Animated DualShock 4 lightbar modes for PS4, fully configurable via INI.
## Installation
1. Copy `lightbar_fx.prx` to `/data/GoldHEN/plugins/` on your PS4.
2. Add the plugin to `/data/GoldHEN/plugins.ini`:
```ini
[default]
/data/GoldHEN/plugins/lightbar_fx.prx
```
3. (Optional) Create `/data/GoldHEN/lightbar.ini` to customize settings. The plugin works with defaults if no INI is present.
## Animation Modes
| Mode       | Description                                                    |
|------------|----------------------------------------------------------------|
| `rainbow`  | Smooth HSV hue cycle through the full color wheel              |
| `breathe`  | Single color fades in/out on a sine wave (min 5% brightness)   |
| `pulse`    | Like breathe but with a sharp gamma curve heartbeat effect     |
| `police`   | Alternating red/blue (or red/white) strobe with off gaps       |
| `ocean`    | Deep blue ↔ cyan oscillation with shimmering saturation        |
| `fire`     | Flickering red-orange with pseudo-random brightness variation   |
| `party`    | Steps through 2–8 user-defined colors                          |
| `solid`    | Fixed color, re-applied periodically                           |
| `off`      | Resets lightbar to system/game default                         |
## Hotkey
Press **L1 + R1 + L3** simultaneously to cycle to the next mode. An on-screen notification shows the new mode name.
Disable with `hotkey_enabled=false` in the INI.
## Configuration Reference
Create `/data/GoldHEN/lightbar.ini`:
```ini
[default]
; Animation mode: rainbow, breathe, pulse, police, ocean, fire, party, solid, off
mode=rainbow
; Animation speed: 1 (slowest) to 10 (fastest)
speed=5
; Global brightness: 0–255
brightness=255
; Solid mode color
solid_r=0
solid_g=0
solid_b=255
; Breathe/pulse mode color
breathe_color=blue
breathe_r=0
breathe_g=0
breathe_b=255
; Party mode: 2–8 custom colors
party_count=4
party_r1=255
party_g1=0
party_b1=0
party_r2=0
party_g2=255
party_b2=0
party_r3=0
party_g3=0
party_b3=255
party_r4=255
party_g4=255
party_b4=0
; Police pattern: red_blue, red_white
police_pattern=red_blue
; Show on-screen notification on load
show_notification=true
; Enable L1+R1+L3 hotkey to cycle modes
hotkey_enabled=true
```
## Building
Requires the GoldHEN Plugin SDK with `GOLDHEN_SDK` environment variable set.
```sh
cd plugin_src/lightbar_fx
make
```
Output: `bin/plugins/lightbar_fx.prx`
## Speed Reference
| Speed | Tick Rate |
|-------|-----------|
| 1     | 10 Hz     |
| 2     | 15 Hz     |
| 3     | 20 Hz     |
| 4     | 30 Hz     |
| 5     | 40 Hz     |
| 6     | 50 Hz     |
| 7     | 60 Hz     |
| 8     | 80 Hz     |
| 9     | 100 Hz    |
| 10    | 120 Hz    |
