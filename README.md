### PLEASE NOTE

*This is the OG jailing script created by @Andyyy7666 for the original version of @ND-Framework for FiveM. This will not work with the current version without some serious work.*

---
# ND Jailing

ND Jailing is a resource for FiveM servers that allows you to jail players for a specific amount of time with configurable options.

## Features

- Jailing players for a specified time period
- Fine players upon jailing
- Configurable jail location and distance
- Integration with ND_Core resource for job-based access control
- Discord logging of jail events
- Support for ModernHUD notifications (optional)

## Requirements

- [ND_Core](https://github.com/ND-Framework/ND_Core) - Make sure to install and configure ND_Core before using this resource.
- [ND_Characters](https://github.com/ND-Framework/ND_Characters) - Make sure to install and configure ND_Characters before using this resource.

## Installation

1. Clone this repository into your server resources folder.
2. Add `ensure ND_Jailing` to your server.cfg file.
3. Configure the settings in the `config.lua` file to suit your server.

## Usage

To jail a player, use the `/jail` command followed by the player ID, time (in seconds), fine amount, and reason. For example:
`/jail 2 60 500 Speeding`

This will jail player with ID 2 for 60 seconds, fine them $500, and provide "Speeding" as the reason for the jail.

## Credits

- Author: https://github.com/Andyyy7666
