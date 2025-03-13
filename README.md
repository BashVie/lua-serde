A simple serialization library for arbitrary tables in Lua based on string.pack and string.unpack

Supports serializing and deserializing tables containing the following datatypes:
- nil
- string
- number
- boolean
- function
- table

Note that functions can't have reliance on variables outside of their immediate scope.

Output of test-serde.lua:
```
🟢 /V/C/lovegame #> lua test-serde.lua
Weapon name: Goblin Thrasher
Weapon damage: 10.0
Is ranged? false
Nested tables: Some Text
Testing Array: 30.0
Testing nil: nil
1	10.0
2	20.0
3	30.0
4	40.0
Enemy health: 30
Dealt 20.0 damage to Goblin!
Enemy health: 10.0
```
