player = {}
	
player.posX = 300
player.posY = 300

player.lookX = 300
player.lookY = 300

player.firing = false

player.health = 100

player.update = function(v,h,x,y)
	player.posX= player.posX+h
	player.posY= player.posY+v
	player.lookX= x
	player.lookY= y
end

player.fire = function()
	player.firing = true
end

player.endfire = function()
	player.firing = false
end

player.draw = function()
	
	local r = math.atan2(player.lookY-player.posY,player.lookX-player.posX) + math.pi /2
	love.graphics.draw(player.image, player.posX, player.posY, r, 1, 1, 32, 32)
	
end


function love.load()
	player.image = love.graphics.newImage("player.png")
	--enemyImages = {}
	--for i = 1,10 do
	--	enemyImages[i] = love.graphics.newImage("enemy-"+i+".png")
	--end
end





function love.draw()
	if player.firing then
		love.graphics.print("firing", 400,300)
	else
		love.graphics.print("not firing", 400,300)
	end
	player.draw()
end

function love.mousepressed(x, y, button)
	if button == 'l' then
		player.fire()
	end
end

function love.mousereleased(x, y, button)
	if button == 'l' then
		player.endfire()
	end
end

function love.update()
	local v = 0
	local h = 0
	if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		v = v - 4
	end
	if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
		v = v + 4
	end
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		h = h + 4
	end
	if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		h = h - 4
	end
	
	local x = love.mouse.getX()
	local y = love.mouse.getY()
	
	player.update(v,h,x,y)
	
end
	
