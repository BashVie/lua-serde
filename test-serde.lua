-- test-serde.lua

local serde = require('serde')

local my_resource = {
    weapon_name = 'Goblin Thrasher',
    damage = 10,
    is_ranged = false,
    my_table = {
        my_data = 'Some Text'
    },
    test_nil = nil,
    attack = function(self, enemy)
        local dmg = 0
        if enemy.name == 'Goblin' then
            dmg = self.damage * 2
        else
            dmg = self.damage
        end
        enemy.hp = enemy.hp - dmg
        print('Dealt ' .. dmg .. ' damage to ' .. enemy.name .. '!')
    end
}

local packed_res = serde.ser(my_resource)
local res = serde.de(packed_res)

print('Weapon name: ' .. res.weapon_name)
print('Weapon damage: ' .. res.damage)
print('Is ranged? ' .. tostring(res.is_ranged))
print('Nested tables: ' .. res.my_table.my_data)
print('Testing nil: ' .. tostring(res.test_nil))

local nme = {
    name = 'Goblin',
    hp = 30
}

print('Enemy health: ' .. nme.hp)
res:attack(nme)
print('Enemy health: ' .. nme.hp)
