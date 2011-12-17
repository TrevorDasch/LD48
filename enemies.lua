require "enemy"

enemies = {}

for i = 1,10 do
	enemies[i] = {}
	setmetatable( enemies[i] , { __index = enemy})
end

