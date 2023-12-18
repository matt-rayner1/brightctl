# Brightness Control Script (brightctl)

## Overview
`brightctl` is a shell script for controlling the brightness of your display on Linux systems. 
It allows you to adjust the overall brightness as well as individual blue channel.

It was designed to integrate with polybar ("get" output).
I also invoke it with i3 keybinds, but that is up to the user as they see fit. 

## Requirements
- Linux Operating System
- `xgamma` tool installed

## Usage
The script supports the following commands:
- `up` - Increase brightness
- `down` - Decrease brightness
- `bup` - Increase blue channel brightness
- `bdown` - Decrease blue channel brightness
- `get` - Get the current brightness levels

### Syntax
```./brightctl [command] [value(%)]```

- `command`: Can be `up`, `down`, `bup`, `bdown`, or `get`.
- `value(%)`: The percentage to increase or decrease the brightness (only for `up`, `down`, `bup`, `bdown`).

### Examples
- Increase overall brightness by 5%:
```./brightctl up 5```

- Decrease blue channel brightness by 10%:
```./brightctl bdown 10```

- Get the current brightness levels:
```./brightctl get```

## Notes
- The script uses `xgamma` to adjust the gamma values of the screen, effectively controlling the brightness.
- Brightness values are treated as percentages and converted to decimal values for processing.
- The script includes safety checks to prevent setting the brightness outside the 10% to 100% range.
- Apart from that, it was just a hack job to get the functionality I needed for my system. 

## License
           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                   Version 2, December 2004
 
Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.
 
           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

 0. You just DO WHAT THE FUCK YOU WANT TO.
