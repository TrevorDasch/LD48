require "player"


function love.load()
	player.image = love.graphics.newImage("player.png")
	--for i = 1,10 do
	--	enemies[i].image = love.graphics.newImage("enemy-"+i+".png")
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
	
	player.move(v,h,x,y)
	
end
	
