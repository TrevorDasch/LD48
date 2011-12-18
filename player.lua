require "bullets"


player = {}
	
player.posX = 300
player.posY = 300

player.lookX = 300
player.lookY = 300

player.firing = false
player.moving = false

player.health = 100

player.cooldown = .2
player.lastshot = 1

player.destoryed = false


player.move = function(v,h,x,y)
	player.posX= player.posX+200*h
	player.posY= player.posY+200*v
	
	if player.posX < 0 then
		player.posX = 0
	end
	if player.posY < 0 then
		player.posY = 0
	end
	if player.posX > 800 then
		player.posX = 800
	end
	if player.posY > 600 then
		player.posY = 600
	end
	
	player.lookX= x
	player.lookY= y
	if h ~= 0 or v ~= 0 then  
		if not player.moving then
			player.moving = true
			player.engine:start()
		end
	else 
		if player.moving then
			player.moving = false
			player.engine:stop()
		end
	end
end

player.update = function(dt)

	if not player.destroyed then
		local v = 0
		local h = 0
		if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
			v = v - dt
		end
		if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
			v = v + dt
		end
		if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
			h = h + dt
		end
		if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
			h = h - dt
		end
		
		local x = love.mouse.getX()
		local y = love.mouse.getY()
		
		
		player.move(v,h,x,y)

		local r = math.atan2(player.lookY-player.posY,player.lookX-player.posX) + math.pi /2


		player.lastshot=player.lastshot + dt
		if player.firing and player.lastshot > player.cooldown then
			player.lastshot = 0
			playerBulletList:addBullet(player.posX,player.posY,r-math.pi/2)
		end
		

		player.engine:setPosition(player.posX, player.posY)
		player.engine:setRotation(r)
		player.engine:setDirection(r+math.pi/2)	
		player.engine:update(dt)
	else
		player.explosion:setPosition(player.posX, player.posY)
		player.explosion:update(dt)
	end
	
end


player.fire = function()
	player.firing = true
end

player.endfire = function()
	player.firing = false
end

player.draw = function()
	if not player.destroyed then
	
	local r = math.atan2(player.lookY-player.posY,player.lookX-player.posX) + math.pi /2

	love.graphics.draw(player.engine)
	love.graphics.draw(player.image, player.posX, player.posY, r, 1, 1, 32, 32)
	else
		love.graphics.draw(player.explosion)
	end
end


player.detectionDraw = function()
	if not player.destroyed then
		local r = math.atan2(player.lookY-player.posY,player.lookX-player.posX) + math.pi /2

		love.graphics.draw(player.picker, player.posX, player.posY, r, 1, 1, 32, 32)
	end
end


function player:createEngine(pixel)
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
    self.engine:setColor                 (255, 100, 10, 240, 255, 255, 10, 50)
    self.engine:stop();--this stop is to prevent any glitch that could happen after the particle system is created
	
end

function player:createExplosion(pixel)
	self.explosion = love.graphics.newParticleSystem(pixel, 500)
    self.explosion:setEmissionRate          (500  )
    self.explosion:setLifetime              (.5)
    self.explosion:setParticleLife          (.5)
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
    self.explosion:setColor                 (255, 100, 10, 240, 255, 255, 10, 50)
    self.explosion:stop();--this stop is to prevent any glitch that could happen after the particle system is created
	
end 


function player:damage(dam)
	if self.destroyed then
		return
	end
	self.health = self.health - dam
	if self.health <= 0 then
		self.destroyed = true
		
		love.graphics.setFont(60)
		self.explosion:start()
	end
end
