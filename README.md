# RedM Truck script - STANDALONE

## About

RedM Truck is the port of a truck model from Ploks FiveM Car pack, along with script to make it functional for RedM servers.

## Key Features

- **Synchronization**: Workarounds were discovered to keep the car visible upon new player join and for players to see eachother in the drivers seat
- **Sounds**: Using the PMMS resource by Kibook, https://github.com/kibook/pmms, the truck has sounds similar to a real truck (work in progress) 
- **Capablility**: From offroading to hillclimbs the truck is fun to drive around in the world of RedDead

## Important
- To prevent visibility de-sync between players - Player is teleported to Mexico then placed back if they leave truck and re-enter driver seat
- To prevent visibility de-sync for vehicle - The entire vehicle/horse becomes visible if vehicle touches water
- To prevent visibility de-sync for vehicle - it will explode if someone other than the player tries to sit in their drivers seat

## Installation

1. Drag and drop redm-truck into server resources
2. Install Pmms then drag and drop all mp3s into pmms/http/media
3. Ensure pmms and redm-truck

## Commands
Change select commands such as spawn command in the config.lua file

| Command | Description |
| --- | --- |
| `/spawn_truck` | Spawns the truck next to player |
| `/delete_truck` | Deletes truck |
| `/reset_truck` | Resets truck |
| `/fixme` | Manual fix for player visibility de-sync - Teleports player to Mexico and back |
| `/fixtruck` | Manual fix for object visibility de-sync - Toggles truck visibility |
| `/waterfix` | Manual fix for water visibility de-sync - Makes everything visible |
| `/lock` | Preliminary idea for locking - makes vehicle undriveable (wheels are likely to fall off/cannot be unlocked) |

# controls

Turn Engine on/off = Left Alt
Rev = R


## Screenshots

![screen2](https://github.com/Silonugget/redm-truck/assets/107784929/47ca92c6-ead6-4e62-af09-71ce80295afb)

![screen3](https://github.com/Silonugget/redm-truck/assets/107784929/ff2c9950-ab95-46b5-9e8a-7781a19477f1)

[Demo Video](https://silonugget.com)

## Credits
- PLOKMJNB for car models https://github.com/PLOKMJNB/FiveM-Civ-Car-Pack/tree/master
- Zelbeus for Script elements https://github.com/zelbeus/redm_car
- Kibook for PMMS resource 
- Thanks to Luman Studios for sharing knowledge that inspired the idea
