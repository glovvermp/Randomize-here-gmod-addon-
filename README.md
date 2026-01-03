- [🇷🇺 Русская версия](README-RU.md)

# Garry's Mod Addon
## "Randomize here! – Spawn Point Randomizer"

> This addon allows you to create points on the map with random item spawning.  
> Supports weapons (SWEPs) and entities.

This is my own version of an addon for creating points with random spawn of specified items.

This is the first addon I’ve written. I learned GLua during development, and the entire addon was created in about one week.  
Updates and further support are planned.

> [!CAUTION]
> - **Bugs are possible.** The addon has not been fully tested and will be fixed over time.
> - **Spawn points have no limit! Be careful with the amount placed on a map.**
> - **Currently, all players can interact with all addon functionality.**
>   Admin-only access is planned in future updates.
> - **No save system temporarily**

> [!NOTE]
> To add an item, open the addon menu, create an item ID and click its name in the list.  
> A configuration menu will appear where you can specify:
> - items to spawn
> - spawn chance
> - maximum amount  
> _(the actual amount is randomized between 1 and the specified value)_
>
> #### How to get the item name:
> 1. Open the spawn menu (C or F1)
> 2. Right-click the desired item and select **"Copy to Clipboard"**
> 3. Paste the copied value into the addon menu
>
> Then click **Apply**, and the point IDs will appear in the tool menu list.

- ### [-> Addon Installation <-](#installation)
- #### [< Developer Contact >](#bug-reports)

---

## Spawnable item types

✅ – Allowed  
❌ – Not supported

| Type | Spawnable |
|------|-----------|
| Weapon / SWEP | ✅ |
| Entity | ✅ |
| Prop | ❌ |
| Vehicle | ❌ |
| NPC | ❌ |

> [!CAUTION]
> If you add an unsupported type (marked ❌) to a spawn point, it will most likely result in errors or the item not spawning.

---

## Installation

Copy or move the `spawn_tool` folder into:
GarrysMod/garrysmod/addons


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

---

## Bug reports

You can create an issue directly on GitHub:
https://github.com/glovvermp/Randomize-here-gmod-addon-/issues

## Addon authors

Heyzo — structure and code

> Discord: glover_mp

Pplane — addon concept and prototype version

> Contact information currently unavailable