Aerial
======

Take to the skies of your Minetest world with a fantastic array of wings! Wings grant players feather falling plus varying amounts of jump height and flight speed, ranging from basic wings that grant little or no flight to wings that will let you dart through the air at incredible speeds.

How To Craft
------------

Like most items in Minetest, wings are crafted from component materials. Each pair of wings is crafted from seven of their component material arranged in the following pattern where `[M]` represents a material and `[ ]` represents an empty square in the crafting grid:

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

Other Notes
-----------

Some wings grant players a tremendous degree of mobility that may upset the balance of a typical survival experience. You may wish to disable the more powerful wings if you're concerned about players being able to move too quickly. You can disable any individual wings via the 'Settings' tab of Minetest, under All Settings -> Content: Mods -> Aerial.

The other setting for this mod, 'milliseconds per flight tick', should be left at its default value unless you understand the implications of changing it.

Also note that wings enable and disable flight via automatic manipulation of a player's fly privilege. Any manual changes to fly privilege will be overridden and disregarded by this mod when wings are equipped. This mod also manipulates a player's physics speed which may interact with other mods that do the same.

License
-------

All code and assets in this project are licensed under the MIT license as described in [the LICENSE file](https://github.com/EmptyStar/aerial/blob/main/LICENSE). Other licenses and credits are noted in [CREDITS.md](https://github.com/EmptyStar/aerial/blob/main/CREDITS.md).
