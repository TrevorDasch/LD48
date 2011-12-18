enemy = {}

enemy.prototype = {posX = 0, posY = 0, lookX = 0, lookY = 0, health = 100, 
			lastshot = 1, cooldown = 1, destroyed = false, deleteReady = false, destroyedTime=0}

enemy.mt = {}

function enemy:new(o)
	setmetatable(o, self.mt)
	return o
end


enemy.mt.__index = enemy.prototype

function enemy.prototype:update(dt)
	if self.posX > 830 or self.posY > 630 or self.posX < -30 or self.posY < -30 then
		self.deleteReady=true
	end
	
	
	if not self.destroyed then
		local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2
	
		self.engine:setPosition(self.posX, self.posY)
		self.engine:setRotation(r)
		self.engine:setDirection(r+math.pi/2)	
		self.engine:update(dt)
	else
		self.destroyedTime = self.destroyedTime+dt
		
		self.engine:setPosition(self.posX, self.posY)

		self.explosion:update(dt)
		if(self.destroyedTime > 1) then
			self.deleteReady = true
		end
	end
end

function enemy.prototype:draw()
	if not self.destroyed then
		local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2
		love.graphics.draw(self.engine)
	
		love.graphics.draw(self.image, self.posX, self.posY, r, 1, 1, 32, 32)
	else
		love.graphics.draw(self.explosion)	
	end
end

function enemy.prototype:detectionDraw()
	if not self.destroyed then
		local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2
		love.graphics.draw(self.picker, self.posX, self.posY, r, 1, 1, 32, 32)
	end
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

function enemy.prototype:createExplosion(pixel)
	self.explosion = love.graphics.newParticleSystem(pixel, 500)
    self.explosion:setEmissionRate          (500  )
    self.explosion:setLifetime              (.2)
    self.explosion:setParticleLife          (.3)
    self.explosion:setOffset                (0, -20)
    self.explosion:setDirection             (math.pi /2)
    self.explosion:setSpread                (math.pi*2)
    self.explosion:setSpeed                 (400, 400)
    self.explosion:setGravity               (0)
    self.explosion:setRadialAcceleration    (10)
    self.explosion:setTangentialAcceleration(0)
    self.explosion:setSize                  (1)
    self.explosion:setSizeVariation         (0.5)
    self.explosion:setRotation              (0)
    self.explosion:setSpin                  (0)
    self.explosion:setSpinVariation         (0)
    self.explosion:setColor                 (255, 180, 10, 240, 255, 255, 10, 50)
    self.explosion:stop();--this stop is to prevent any glitch that could happen after the particle system is created
	
end 

function enemy.prototype:damage(dam)
	if self.destroyed then
		return
	end
	self.health = self.health - dam
	if self.health <= 0 then
		self.destroyed = true
		score = score + 100
		enemyCount = enemyCount-1
		self.explosion:start()
	end
end
