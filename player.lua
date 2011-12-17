player = {}
	
player.posX = 300
player.posY = 300

player.lookX = 300
player.lookY = 300

player.firing = false
player.moving = false

player.health = 100





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
	local r = math.atan2(player.lookY-player.posY,player.lookX-player.posX) + math.pi /2

	player.engine:setPosition(player.posX, player.posY)
	player.engine:setRotation(r)
	player.engine:setDirection(r+math.pi/2)	
	player.engine:update(dt)
end


player.fire = function()
	player.firing = true
end

player.endfire = function()
	player.firing = false
end

player.draw = function()
	
	local r = math.atan2(player.lookY-player.posY,player.lookX-player.posX) + math.pi /2

	love.graphics.draw(player.engine, 0, 0, 0, 1, 1, 0, 0)
	love.graphics.draw(player.image, player.posX, player.posY, r, 1, 1, 32, 32)
	
end

function player.createEngine(pixel)
	player.engine = love.graphics.newParticleSystem(pixel, 500)
    player.engine:setEmissionRate          (100  )
    player.engine:setLifetime              (-1)
    player.engine:setParticleLife          (.2)
    player.engine:setOffset                (0, -20)
    player.engine:setDirection             (math.pi /2)
    player.engine:setSpread                (-math.pi/6)
    player.engine:setSpeed                 (400, 400)
    player.engine:setGravity               (0)
    player.engine:setRadialAcceleration    (10)
    player.engine:setTangentialAcceleration(0)
    player.engine:setSize                  (1)
    player.engine:setSizeVariation         (0.5)
    player.engine:setRotation              (0)
    player.engine:setSpin                  (0)
    player.engine:setSpinVariation         (0)
    player.engine:setColor                 (255, 100, 10, 240, 255, 255, 10, 50)
    player.engine:stop();--this stop is to prevent any glitch that could happen after the particle system is created
	
end
