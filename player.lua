player = {}
	
player.posX = 300
player.posY = 300

player.lookX = 300
player.lookY = 300

player.firing = false
player.moving = false

player.health = 100


player.move = function(v,h,x,y)
	player.posX= player.posX+h
	player.posY= player.posY+v
	player.lookX= x
	player.lookY= y
	if h ~= 0 or v ~= 0 then
		player.moving = true
	else
		player.moving = false
	end
end

player.update = function()


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
