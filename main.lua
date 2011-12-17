require "player"
require "enemies"

background = {}
background.posX = 0
background.posY = 0

function background.update(dt)
	background.posX = background.posX - 100 * dt
	if background.posX < -800 then
		background.posX = background.posX+800
	end
end

function background.draw()
	love.graphics.draw(background.image,background.posX,background.posY)
	love.graphics.draw(background.image,background.posX+800,background.posY)
end

function background.create()
	background.image:renderTo(
		function()
			for i = 1,300 do
				love.graphics.draw(pixel, math.random()* 800, math.random()*600)
			end
		end)
	background.image:setWrap("repeat","repeat")
end


function love.load()
	pixel = love.graphics.newImage("pixel.png")

	player.image = love.graphics.newImage("player.png")
	player.picker = love.graphics.newImage("player-picker.png")
	player.createEngine(pixel)
	
	for i = 1,5 do
		enemies[i].image = love.graphics.newImage("enemy" .. i .. ".png")
		enemies[i].picker = love.graphics.newImage("enemy" .. i .. "-picker.png")
		enemies[i]:createEngine(pixel)
	end
	
	background.image = love.graphics.newFramebuffer()
	background.create()
		
		
end


function love.draw()


	background.draw()
	
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

function love.update(dt)
	
	background.update(dt)
	player.update(dt)
	
	
end
	
