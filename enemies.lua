require "enemy"

enemies = {}

for i = 1,5 do
	enemies[i] = enemy:new{}
end

enemy1 = enemies[1]


function enemy1:update(dt)
	mt.update(self,dt)

end

enemies[1] = enemy1
