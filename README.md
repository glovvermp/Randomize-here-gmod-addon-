- [🇷🇺 Русская версия](README-RU.md)

# Garry's Mod Addon
## "Randomize here! – Spawn Point Randomizer"

> This addon allows you to create points on the map with random item spawning.  
> Supports weapons (SWEPs) and entities.

This is my own version of an addon for creating points with random spawn of specified items.

This is the first addon written by me. GLua was learned during development. Updates and support are planned.

> [!CAUTION]
> - **Bugs are possible.** The addon has not been fully tested and will be fixed over time.
> - **Spawn points have no limit! Be careful with the amount placed on a map.**
> - **Currently, all players can interact with all addon functionality.**
> - **The save system may work incorrectly.**

> [!NOTE]
> To add an item, open the addon menu, create an item ID and click its name in the list.  
> A configuration menu will appear where you can specify:
> - items to spawn
> - spawn chance
> - maximum amount  
>
> Then click **Apply**, and the point IDs will appear in the tool menu list.

- ### [-> Addon Installation <-](#installation)
- #### [< Developer Contact >](#bug-reports)


---
## Demonstration

### Visual point display options:
> ![point_visual_variants](https://github.com/user-attachments/assets/d30b3386-5448-4614-b568-e65b4d1e2e35)
> Points can be displayed not only for admins, but also for players.

### Menu configuration demonstration:
[Menu demonstration (video)](.github/assets/menu.mp4)

> ![menu](https://github.com/user-attachments/assets/cfd53f37-872b-4087-9b87-e6578dcaca3f)
>
> Convenient menu for quick point configuration.

### Spawn demonstration with different settings:

> ![spawn](https://github.com/user-attachments/assets/e825a406-8409-4853-9bd6-0bdf6d4f726f)

> [!NOTE]
> Возможно, не все GIF будут загружаться сразу.

---

## Spawnable item types

🟢 – Any type from this category
🔴 – Nothing from this category
🟡 – Will be available in the future

| Type | Spawnable |
|------|-----------|
| Weapon / SWEP | 🟢 |
| Entity | 🟢 |
| Prop | 🔴 |
| Vehicle | 🟡 |
| NPC | 🟡 |

> [!CAUTION]
> If you specify an unsupported type (🔴), there is a high probability of errors or the item will not spawn.

---

## Installation

Unzip the archive into the directory (only for the latest version):
GarrysMod\garrysmod\addons


### Steam version (if you are unsure how to install):

1. Open **Garry's Mod** in your Steam Library
2. Click the gear icon → **Manage** → **Browse local files**
3. Open the `garrysmod` folder, then the `addons` folder

> [!NOTE]
> Addons installed directly into the game folder usually do not appear in the in-game **Addons** menu.  
> This is normal — that menu only shows Workshop subscriptions.

---

## Bind command

You can activate all existing spawn points on the map using a keyboard button instead of the tool menu.

1. Open the game console (`~`)
2. Enter the command:
```txt
bind "N" "RH_activate_all"
```
3. To use a different key, replace "N" with another key
(e.g. "G", "CTRL", "F1", or "MOUSE4")

---

## Planned features status

- [x] Core addon functionality
- [x] Fixed spawn chance
- [x] Switching between different point types
- [x] User interface
- [ ] Spawn point limit
- [ ] Area-based spawn points
- [ ] Spawn point color selection
- [ ] Individual ID activation
- [ ] Point grouping
- [ ] Points with item limit in area
- [ ] Respawn chance configuration

---

## Bug reports

You can create an issue directly on GitHub:
https://github.com/glovvermp/Randomize-here-gmod-addon-/issues

> [!NOTE]
> A Discord server is planned.


## Addon authors

Heyzo — structure and code

> Discord: glover_mp

Pplane — addon concept and prototype version

> Preferred to remain anonymous