require "enemy"

enemyList = {{},{},{},{},{}}
deletedEnemyList = {}

function enemyList:addEnemy(o)
	local en = enemies[o.etype]:new(o)

	en.engine:start()
	table.insert(self[o.etype],en);
end


function enemyList:draw()

	for i=1,5 do
		for key, val in pairs(self[i]) do
			val:draw()
		end
	end

end

function enemyList:update(dt)
	for i=1,5 do
		local deletequeue = {}
		for key, val in pairs(self[i]) do
			val:update(dt)
			if val.deleteReady then
				table.insert(deletequeue, 1, key)
			end
		end
		
		for key, val in pairs(deletequeue) do
			if not self[i][val].destroyed then
				table.insert(deletedEnemyList,self[i][val])
			end
			table.remove(self[i],val)
		end
	end
end

function enemyList:moveAllToList()
	local list = {}
	for i=1,5 do
		for key, val in pairs(self[i]) do
			if not val.destroyed then
				table.insert(list,val.proto)
			end
		end
	end
	return list
end

function enemyList:detectionDraw()
	for i=1,5 do
		for key, val in pairs(self[i]) do
			val:detectionDraw()
		end
	end
end



enemies = {}

--First Enemy: moves in a sine wave
enemy1 = enemy:new{}

function enemy1:new(o)
	setmetatable(o, { __index = enemy1})
	enemy.prototype.createEngine(o,pixel)
	enemy.prototype.createExplosion(o,pixel)
	return o
end

function enemy1:update(dt)
	enemy.prototype.update(self,dt)

	if not self.destroyed then
		self.posX= self.posX - 80*dt
		self.posY = self.offsetY + self.amp * math.sin(self.freq*(self.posX+self.offsetX))
		self.lookX = self.posX-1
		self.lookY =self.offsetY + self.amp * math.sin(self.freq*(self.lookX+self.offsetX))

		self.lastshot=self.lastshot + dt
		if self.lastshot > self.cooldown then
			self.lastshot = 0
			local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2

			enemyBulletList:addBullet(self.posX,self.posY,r)
			enemyBulletList:addBullet(self.posX,self.posY,r-math.pi)
		end
	end
end

enemies[1] = enemy1

--Second Enemy: zips across the screen
enemy2 = enemy:new{}


function enemy2:new(o)
	setmetatable(o, { __index = enemy2})
	enemy.prototype.createEngine(o,pixel)
	enemy.prototype.createExplosion(o,pixel)
	return o
end

function enemy2:update(dt)
	enemy.prototype.update(self,dt)

	if not self.destroyed then
	
		self.posX = self.posX + math.cos(self.rot) * 500 * dt
		self.posY = self.posY + math.sin(self.rot) * 500 * dt

		self.lookX = self.posX + math.cos(self.rot) * 500 * dt
		self.lookY = self.posY + math.sin(self.rot) * 500 * dt


		self.lastshot=self.lastshot + dt
		if self.lastshot > self.cooldown then
			self.lastshot = 0
			enemyBulletList:addBullet(self.posX,self.posY,math.random()*math.pi*2)
		end
	end
end

enemies[2] = enemy2


--Third Enemy: moves to a series of random points
enemy3 = enemy:new{}

function enemy3:new(o)
	setmetatable(o, { __index = enemy3})
	enemy.prototype.createEngine(o,pixel)
	enemy.prototype.createExplosion(o,pixel)
	return o
end

function enemy3:update(dt)
	enemy.prototype.update(self,dt)

	if not self.destroyed then

		if((self.posX-self.lookX)*(self.posX-self.lookX)+(self.posY-self.lookY)*(self.posY-self.lookY))<5 then
			if self.nextp > table.getn(self.point) then
				self.lookX = -1000
				self.lookY = -1000
			else
			
				self.lookX = self.point[self.nextp].x
				self.lookY = self.point[self.nextp].y
				self.nextp = self.nextp + 1
			end
		end
		
		local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2


		self.posX = self.posX + math.sin(r) * 200 * dt
		self.posY = self.posY - math.cos(r) * 200 * dt

		self.lastshot=self.lastshot + dt
		if self.lastshot > self.cooldown then
			self.lastshot = 0
			enemyBulletList:addBullet(self.posX,self.posY,r-math.pi/2)

		end
	end
end

enemies[3] = enemy3


--Fourth Enemy: moves to a point, aims a the player, then shoots
enemy4 = enemy:new{}

function enemy4:new(o)
	setmetatable(o, { __index = enemy4})
	enemy.prototype.createEngine(o,pixel)
	enemy.prototype.createExplosion(o,pixel)
	return o
end

function enemy4:update(dt)
	enemy.prototype.update(self,dt)

	if not self.destroyed then

		if self.aiming and not self.fired then
			self.lookX = player.posX
			self.lookY = player.posY
		end
		
		if self.fired then
			self.lookX = -100
			self.lookY = player.posY
		end
		local r = math.atan2(self.lookY-self.posY,self.lookX-self.posX) + math.pi /2
		if not self.aiming then			

			self.posX = self.posX + math.sin(r) * 100 * dt
			self.posY = self.posY - math.cos(r) * 100 * dt
			if((self.posX-self.lookX)*(self.posX-self.lookX)+(self.posY-self.lookY)*(self.posY-self.lookY))<90 then
				self.aiming = true
			end
		end


		self.lastshot=self.lastshot + dt
		if self.lastshot > self.cooldown then
			self.lastshot = 0
			enemyBulletList:addBullet(self.posX,self.posY,r-math.pi/2)
			self.fired = true
			self.aiming = false
		end
	end
end

enemies[4] = enemy4

--Fifth Enemy: moves across the screen
enemy5 = enemy:new{}

function enemy5:new(o)
	setmetatable(o, { __index = enemy5})
	enemy.prototype.createEngine(o,pixel)
	enemy.prototype.createExplosion(o,pixel)
	return o
end

function enemy5:update(dt)
	enemy.prototype.update(self,dt)
	
	if not self.destroyed then
		
		self.posX = self.posX + math.cos(self.rot) * 200 * dt
		self.posY = self.posY + math.sin(self.rot) * 200 * dt

		self.lookX = self.posX + math.cos(self.rot) * 200 * dt
		self.lookY = self.posY + math.sin(self.rot) * 200 * dt


		self.lastshot=self.lastshot + dt
		if self.lastshot > self.cooldown then
			self.lastshot = 0
			enemyBulletList:addBullet(self.posX,self.posY,self.rot)
			enemyBulletList:addBullet(self.posX,self.posY,self.rot+math.pi/2)
			enemyBulletList:addBullet(self.posX,self.posY,self.rot+math.pi)
			enemyBulletList:addBullet(self.posX,self.posY,self.rot-math.pi/2)
		end
	end
end

enemies[5] = enemy5

