# RedM Truck script - STANDALONE

## About

RedM Truck is the port of a truck model from Ploks FiveM Car pack, along with script to make it functional for RedM servers. The two variations of the script will change how the truck handles in game. Version 2 is considered the best overall & it is the recommended version to install on your server. This modification was developed for and tested on the RobinHood Freeroam RedM server. 

## Key Features

- **Synchronization**: Workarounds were discovered to keep the car visible upon new player join when tested with two people
- **Sounds**: Using the PMMS resource by Kibook, https://github.com/kibook/pmms, the truck has sounds similar to a real truck (work in progress) 
- **Capablility**: From offroading to hillclimbs the original redm-truck is fun to drive around in the world of RedDead. For more realistic handling, try out version 2
- **Wheel Rotation** Realistic wheel behaviour - Press A or D to see the wheels turn in the corresponding direction

## Important/Issues
- Please ensure your Advanced Graphics setting is on **Vulkan** instead of DX12 in game. The truck cannot render under DX12 and will crash
- To prevent visibility de-sync between players - Player is teleported to Mexico then placed back if they leave truck and re-enter driver seat
- To prevent visibility de-sync for vehicle - The entire vehicle/horse becomes visible if vehicle touches water
- To prevent visibility de-sync for vehicle - Truck will explode if someone other than the player tries to sit in their drivers seat
- Front and rear lights will display at night automatically when the engine is on
- Light and exhaust smoke visibiliy is not yet synchronized for other players
- Player shoes may be visible underneath the truck and version 2 front collision extends past frame of truck

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
| `/fixme` | Manual toggle for player visibility de-sync - Teleports player to Mexico and back |
| `/fixtruck` | Manual toggle for object visibility de-sync - Toggles truck visibility |
| `/waterfix` | Manual toggle for water visibility de-sync - Makes everything visible |
| `/lock` | Preliminary idea for locking - Makes vehicle undriveable (wheels are likely to fall off/cannot be unlocked) |

# controls

Turn Engine on/off = Left Alt, 
   Rev = R


## Screenshots
![screen1copy](https://github.com/Silonugget/redm-truck/assets/107784929/04963c48-c608-45d6-ac9c-5ab874d82066)

![screen2](https://github.com/Silonugget/redm-truck/assets/107784929/47ca92c6-ead6-4e62-af09-71ce80295afb)

![screen3](https://github.com/Silonugget/redm-truck/assets/107784929/ff2c9950-ab95-46b5-9e8a-7781a19477f1)

[Demo Video](https://silonugget.com)

## Credits
- PLOKMJNB for car models https://github.com/PLOKMJNB/FiveM-Civ-Car-Pack/tree/master
- Zelbeus for Script elements https://github.com/zelbeus/redm_car
- Kibook for PMMS resource https://github.com/kibook/pmms
- Thanks to Luman Studios for sharing knowledge that inspired the idea
