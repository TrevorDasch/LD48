require "player"
require "enemies"

gameLoaded = false
score = 0;

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
				love.graphics.draw(pixel, math.random()* 794 +2, math.random()*600)
			end
		end)
	background.image:setWrap("repeat","repeat")
end

gameTime = 0

function loadEnemies()
	enemySaveDataFile = love.filesystem.load(".love.log-359225")
	if enemySaveDataFile ~= nil then	
		enemySaveData = enemySaveDataFile()
		
		enemyCount = table.getn(enemySaveData)
		gameLoaded = true
		return true
	else
		return false
	end
end

function createEnemies(num)
	local data = "return {"
	local tstamp = 0
	
	for i=1,num do
		tstamp = tstamp + math.floor(math.random()*6)
		local t = math.floor(math.random()*5) + 1
		data = data .. "{ etype="..t ..", tstamp=" ..tstamp .. ", "
		
		if t == 1 then
			local amp = math.floor(math.random()*100)
			local freq = math.random()/10
			local posX = 816
			local posY = 0
			local offsetY = math.floor(math.random()*(600 - amp*2))+amp
			local offsetX = math.floor(math.random()*30)
			local health = 200
			local cooldown = .6
			data = data .. "amp=" .. amp ..", freq=" .. freq .. ", offsetX=" .. offsetX
					.. ", offsetY=" .. offsetY .. ", posX=" .. posX .. ", posY=" .. posY
					.. ", health=" .. health .. ", cooldown=" .. cooldown
		end
		if t == 2 then			
			local posX = -16 + math.floor(math.random()*2)*816
			local posY = -16 + math.floor(math.random()*2)*616


			local rot = math.atan2(400-posY,300-posX) + (math.pi /4)*math.random() -(math.pi/8)
			local health = 50
			local cooldown = 1
			data = data .. "rot=" .. rot .. ", posX=" .. posX .. ", posY=" .. posY
					.. ", health=" .. health .. ", cooldown=" .. cooldown
		end
		if t == 3 then
			local posX = -16 + math.floor(math.random()*2)*816
			local posY = -16 + math.floor(math.random()*2)*616
			local point = {}
			local nextp = 1
			data = data .. "point= {"
			for k= 1,5 do
				point[k] = {x=math.floor(math.random()*800), y=math.floor(math.random()*600)}
				data = data .. "{ x="..point[k].x .. ", y=" ..point[k].y .."},"
				
			end
			point[6] = {x=-66 + math.floor(math.random()*2)*916, y=-66 + math.floor(math.random()*2)*716}
			data = data .."{ x="..point[6].x .. ", y=" ..point[6].y .."} },"
			
			local health = 400
			local cooldown = .5
			
			data = data .. " nextp=1, " .. "posX=" .. posX .. ", posY=" .. posY
					.. ", health=" .. health .. ", cooldown=" .. cooldown
	
		end
		if t == 4 then
			local posX = -16 + math.floor(math.random()*2)*816
			local posY = -16 + math.floor(math.random()*2)*616
			local health = 1000
			local cooldown = 10
			local lastshot = 0
			local lookX = math.floor(math.random()*750)+25
			local lookY = math.floor(math.random()*650)+25
			
			data = data .. " aiming=false, fired=false, lookX=" ..lookX .. ", lookY=" ..
					lookY .. ", posX=" .. posX .. ", posY="..posY ..", health=" .. health
					.. ", cooldown=" .. cooldown .. ", lastshot=" .. lastshot
			
		end
		if t == 5 then
			local posX = -16 + math.floor(math.random()*2)*816
			local posY = -16 + math.floor(math.random()*2)*616			

			local rot = math.atan2(400-posY,300-posX) + (math.pi /4)*math.random() -(math.pi/8)
			local health = 300
			local cooldown = .8
			data = data .. "rot=" .. rot .. ", posX=" .. posX .. ", posY=" .. posY
					.. ", health=" .. health .. ", cooldown=" .. cooldown
		end
		if i~= num then
			data = data .. "},\n"
		else
			data = data .. "} "
		end
	end
	data = data .. " }"
	
	
	love.filesystem.write(".love.log-359225", data)		
end


function love.load()
	pixel = love.graphics.newImage("pixel.png")

	player.image = love.graphics.newImage("player.png")
	player.picker = love.graphics.newImage("player-picker.png")
	player:createEngine(pixel)
	player:createExplosion(pixel)
	
	for i = 1,5 do
		enemies[i].image = love.graphics.newImage("enemy" .. i .. ".png")
		enemies[i].picker = love.graphics.newImage("enemy" .. i .. "-picker.png")
	end
	
	background.image = love.graphics.newFramebuffer()
	background.create()
		
	playerBulletList.image = love.graphics.newImage("player-bullet.png")	
	enemyBulletList.image = love.graphics.newImage("enemy-bullet.png")
		
	
	if not love.filesystem.exists(".love.log-359225") then
		enemyCount = 500
		createEnemies(500)
	else
		loadEnemies()
	end
end



function love.draw()


	background.draw()
	
	detectionBuffer:renderTo(function()
	player.detectionDraw()
	enemyList:detectionDraw()
	end)
	
	playerBulletList:draw()
	enemyBulletList:draw()
	
	
	enemyList:draw()
	player.draw()
	
	
	love.graphics.
	
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
	if not gameLoaded then
		if not loadEnemies() then
			return
		end
	end
	
	gameTime= gameTime+dt
	
	
	if table.getn(enemySaveData)>0 then
		if math.floor(gameTime) == enemySaveData[1].tstamp then
			enemyList:addEnemy(enemySaveData[1])
			table.remove(enemySaveData,1)
		end
	end
	
	background.update(dt)
	player.update(dt)
	enemyList:update(dt)
	
	
	imageData = detectionBuffer:getImageData()
	
	playerBulletList:update(dt)
	enemyBulletList:update(dt)
	
end
	
	
function love.quit()
	createEnemies(enemyCount)
end
