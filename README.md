Aerial
======

Take to the skies of your Minetest world with a fantastic array of wings! Wings grant players feather falling plus varying amounts of jump height and flight speed, ranging from basic wings that grant little or no flight to wings that will let you dart through the air at incredible speeds.

This mod can optionally integrate with the [Stamina](https://content.minetest.net/packages/sofar/stamina/) and [Player Monoids](https://content.minetest.net/packages/Byakuren/player_monoids/) mods for better game balance in survival worlds and better compatibility with other mods, respectively. See the relevant sections below for more information.

How To Craft
------------

Like most items in Minetest, wings are crafted from their component materials. Each pair of wings is crafted from seven of their component material arranged in the following pattern where `[M]` represents a material and `[ ]` represents an empty square in the crafting grid:

```
[M] [ ] [M]
[M] [M] [M]
[M] [ ] [M]
```

How To Use
----------

Wings are implemented as [3D Armor](https://content.minetest.net/packages/stu/3d_armor/) items which are placed into an equipment slot like any typical armor item. All equipped wings provide feather falling and prevent fall damage from any height. Additionally, wings may provide flight and jump boosts depending on the quality of the material used to make the wings.

Wings that grant flight allow players to toggle fly mode; by default, fly mode is toggled by pressing the `k` key. Flight speed is reduced when touching the ground. Flight is not possible while submerged in water or other liquids.

Wings Reference
---------------

The following wings are defined with the following attributes:

- **Wooden Wings**
  - Material: any wood
  - Flight: no
  - Jump boost: no
  - Can be used as furnace fuel
- **Cactus Wings**
  - Material: cactus
  - Flight: no
  - Jump boost: no
  - Can be used as furnace fuel
- **Bronze Wings**
  - Material: bronze ingot
  - Flight: yes, very slow speed
  - Jump boost: yes, small
- **Steel Wings**
  - Material: steel ingot
  - Flight: yes, average speed
  - Jump boost: yes, average
- **Golden Wings**
  - Material: gold ingot
  - Flight: yes, moderate speed
  - Jump boost: yes, moderate
- **Diamond Wings**
  - Material: diamond
  - Flight: yes, fast speed
  - Jump boost: yes, high

Mod Integration: Stamina
------------------------

If the [Stamina](https://content.minetest.net/packages/sofar/stamina/) mod is installed, Aerial will cause flight to exhaust players over time and will prevent flight for players who are below a certain threshold of hunger saturation. This can bring game balance to flight in a typical survival world as players will no longer be able to fly indefinitely without consequence.

Flight exhaustion will disable flight and jump boosts for affected players, but feather falling and fall damage prevention will still remain in effect despite low hunger levels. It is also possible to sprint while flying which can allow players to reach blistering speeds, but beware that sprinting while flying is *very* exhausting!

The Stamina-related settings are as follows:

- **Enable Stamina integration?**
  - Enabled by default
  - Toggling this setting off will cause Aerial to ignore the Stamina mod
- **Stamina loss per second of flying**
  - The amount of stamina drained per second of flying
  - Flight drains 16 stamina per second by default
  - Higher values will exhaust the player more rapidly while flying and vice-versa with smaller values
- **Minimum saturation needed to fly**
  - The minimum amount of hunger saturation required to be able to fly
  - Flight requires 4 points of saturation by default
  - Each point of saturation represents "one half bread" of a player's hunger/saturation meter

Mod Integration: Player Monoids
-------------------------------

If the [Player Monoids](https://content.minetest.net/packages/Byakuren/player_monoids/) mod is installed, Aerial will leverage it so that jump boosts and speed boosts during flight do not conflict with physics modifications from other mods. **It is generally recommended to use Player Monoids with Aerial in almost all cases** and especially if you use Stamina or other mods that modify players' speed and/or jump height. This mod makes a best effort to be as compatible as possible with the mods that it depends on, but Player Monoids offers the best compatibility solution available.

Other Notes
-----------

Some wings grant players a tremendous degree of mobility that may upset the balance of a typical survival experience. While costs introduced by the Stamina mod can help game balance by adding consequences to flight, you may wish to disable the more powerful wings if you're concerned about players being able to move too quickly. You can disable any individual wings via the 'Settings' tab of Minetest, under All Settings -> Content: Mods -> Aerial.

The other setting for this mod, 'milliseconds per flight tick', should be left at its default value unless you understand the implications of changing it.

Also note that wings enable and disable flight via automatic manipulation of a player's fly privilege. Any manual changes to fly privilege will be overridden and disregarded by this mod when wings are equipped.

This mod also manipulates a player's physics speed which may interact with other mods that do the same. While many measures are taken to ensure that the physics changes from Aerial, Stamina, and 3D Armor mesh well together, the use of Player Monoids will more thoroughly prevent any negative interactions and is highly recommended.

License
-------

All code and assets in this project are licensed under the MIT license as described in [the LICENSE file](https://github.com/EmptyStar/aerial/blob/main/LICENSE). Other licenses and credits are noted in [CREDITS.md](https://github.com/EmptyStar/aerial/blob/main/CREDITS.md).
