enemy = {}

enemy.prototype = {posX = 0, posY = 0, lookX = 0, lookY = 0, health = 100}

enemy.mt = {}

function enemy:new(o)
	setmetatable(o, self.mt)
	
	
	return o
end


enemy.mt.__index = enemy.prototype

function enemy.prototype:update(dt)
	local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2

	self.engine:setPosition(self.posX, self.posY)
	self.engine:setRotation(r)
	self.engine:setDirection(r+math.pi/2)	
	self.engine:update(dt)
end

function enemy.prototype:draw()
	local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2
	love.graphics.draw(self.image, self.posX, self.posY, r, 1, 1, 32, 32)
end

function enemy.prototype:createEngine(pixel)
	self.engine = love.graphics.newParticleSystem(pixel, 500)
    self.engine:setEmissionRate          (100  )
    self.engine:setLifetime              (-1)
    self.engine:setParticleLife          (.2)
    self.engine:setOffset                (0, -20)
    self.engine:setDirection             (math.pi /2)
    self.engine:setSpread                (-math.pi/6)
    self.engine:setSpeed                 (400, 400)
    self.engine:setGravity               (0)
    self.engine:setRadialAcceleration    (10)
    self.engine:setTangentialAcceleration(0)
    self.engine:setSize                  (1)
    self.engine:setSizeVariation         (0.5)
    self.engine:setRotation              (0)
    self.engine:setSpin                  (0)
    self.engine:setSpinVariation         (0)
    self.engine:setColor                 (255, 10, 10, 240, 255, 100, 10, 50)
    self.engine:stop();--this stop is to prevent any glitch that could happen after the particle system is created
	
end
