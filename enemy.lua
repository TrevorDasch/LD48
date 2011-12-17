enemy = {}

enemy.prototype = {posX = 0, posY = 0, lookX = 0, lookY = 0, health = 100}

enemy.mt = {}

function enemy:new(o)
	setmetatable(o, self.mt)
	return o
end


enemy.mt.__index = enemy.prototype

function enemy.prototype:update(dt)
	
end

function enemy.prototype:draw()
	local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2
	love.graphics.draw(self.image, self.posX, self.posY, r, 1, 1, 32, 32)
end
