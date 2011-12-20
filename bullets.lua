

function hitEnemy(i,x,y)
	local correct = nil
	local mindist = 50
	for key,val in pairs(enemyList[i]) do
		local dist = math.sqrt((x-val.posX)*(x-val.posX)+(y-val.posY)*(y-val.posY))
		if dist < mindist then
			mindist = dist
			correct = val
		end
	end
	if correct then
		correct:damage(50)
	else
		--print("didn't hit?")
	end
	
end


function hitTarget(x,y,r,g,b,a, bullet)
	if g == 0xFF then
		player:damage(3)
	end
	
	if r == 0xFF then
		hitEnemy(1,x,y)
	end
	if r == 0x88 then
		hitEnemy(2,x,y)
	end
	if r == 0xDD then
		hitEnemy(3,x,y)
	end
	if r == 0xBB then
		hitEnemy(4,x,y)
	end
	if r == 0x77 then
		hitEnemy(5,x,y)
	end
	
	bullet:impact()
end


bullet = {}

bullet.prototype = {posX = 0, posY = 0, rot = 0, destroyed = false, timedestroyed = 0,deleteReady = false}

bullet.mt = {}

function bullet:new(o)
	setmetatable(o, self.mt)
	o:createExplosion(pixel)
	return o
end

bullet.mt.__index = bullet.prototype

function bullet.prototype:createExplosion(pixel)
	self.explosion = love.graphics.newParticleSystem(pixel, 500)
    self.explosion:setEmissionRate          (500  )
    self.explosion:setLifetime              (.1)
    self.explosion:setParticleLife          (.2)
    self.explosion:setOffset                (0, 0)
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

function bullet.prototype:setExplosionColor(r1,g1,b1,a1,r2,g2,b2,a2)
    self.explosion:setColor(r1,g1,b1,a1,r2,g2,b2,a2)
end


function bullet.prototype:impact()
	self.destroyed = true
	self.explosion:start()
end

function bullet.prototype:update(dt)
	if not self.destroyed then
		self.posX = self.posX + math.cos(self.rot) * 500 * dt
		self.posY = self.posY + math.sin(self.rot) * 500 * dt
		if self.posX > 830 or self.posX < -30 or self.posY > 630 or self.posY < -30 then
			self.deleteReady = true
		end
	else
		self.explosion:setPosition(self.posX, self.posY)
		self.explosion:update(dt)
		self.timedestroyed=self.timedestroyed+dt
		if self.timedestroyed > 1 then
			self.deleteReady = true
		end
	end
end

function bullet.prototype:detect(imageData,rl,rh,gl,gh,bl,bh,al,ah)
	
	
	
	if self.destroyed then
		return
	end

	for i= -2,2 do
		local x = self.posX + math.cos(self.rot)*4*i
		local y = self.posY + math.sin(self.rot)*4*i
		
		if x < 800 and x >= 0 and y < 600 and y >= 0 then
		
			local r,g,b,a = imageData:getPixel(math.floor(x),math.floor(y))
			if r ~= nil and g ~= nil and b ~= nil and a ~= nil then
				if rl <= r and r <= rh and gl <= g and g <= gh and bl <= b and b <= bh and al <= a and a <= ah then
					hitTarget(x,y,r,g,b,a,self)
					break
				end
			end
		end 
	end
end

function bullet.prototype:draw(image)
	if not self.destroyed then
		love.graphics.draw(image,self.posX,self.posY,self.rot, 1, 1, 8, 8)
	else
		love.graphics.draw(self.explosion, 0,0)
	end
end





BulletList = {}

BulletList.prototype = {}
BulletList.prototype.bullets = {}

BulletList.mt = {}

function BulletList:new(o)
	setmetatable(o, self.mt)
	o.bullets = {}
	return o
end

BulletList.mt.__index = BulletList.prototype

BulletList.prototype.targetColorRange = {rl = 0, rh = 255, gl = 0, gh = 255, bl = 0, bh = 255, al = 0, ah = 255}
BulletList.prototype.explosionColors = {r1 = 0xFF, g1 = 0xFF, b1 = 0xFF, a1 = 0xFF, r2 = 0xFF, g2 = 0xFF, b2 = 0xFF, a2 = 0x88}


function BulletList.prototype:update(dt, imageData)
	local deletequeue = {}
	for key, val in pairs(self.bullets) do
	
		val:detect(imageData, 
				   self.targetColorRange.rl,
				   self.targetColorRange.rh,
				   self.targetColorRange.gl,
				   self.targetColorRange.gh,
				   self.targetColorRange.bl,
				   self.targetColorRange.bh,
				   self.targetColorRange.al,
				   self.targetColorRange.ah)
				   
		val:update(dt)
		if val.deleteReady then
			table.insert(deletequeue, 1, key)
		end
	end
	for key, val in pairs(deletequeue) do
		self.bullets[val] = nil
		table.remove(self.bullets,val)
	end
end

function BulletList.prototype:draw()
	for key, val in pairs(self.bullets) do
		val:draw(self.image)
		--love.graphics.print( "bullet still exists", 100, 15*key)
	end
end

function BulletList.prototype:addBullet(posX,posY,rot)
	local b = bullet:new{posX = posX, posY = posY, rot = rot}
	b:setExplosionColor(self.explosionColors.r1,
						self.explosionColors.g1,
						self.explosionColors.b1,
						self.explosionColors.a1,
						self.explosionColors.r2,
						self.explosionColors.g2,
						self.explosionColors.b2,
						self.explosionColors.a2)
	
	table.insert(self.bullets,b)

end




playerBulletList = BulletList:new{}

playerBulletList.targetColorRange = {rl = 0x77, rh = 0xFF, gl = 0, gh = 0, bl= 0, bh = 0, al = 0, ah = 0xFF}
playerBulletList.explosionColors = {r1 = 0, g1 = 0xFF, b1 = 0, a1 = 0xFF, r2 = 0xFF, g2 = 0xFF, b2 = 0, a2 = 0x88}


enemyBulletList = BulletList:new{}
enemyBulletList.targetColorRange = {rl = 0, rh = 0, gl = 0xFF, gh = 0xFF, bl= 0, bh = 0, al = 0, ah = 0xFF}
enemyBulletList.explosionColors = {r1 = 0xFF, g1 = 0, b1 = 0, a1 = 0xFF, r2 = 0xFF, g2 = 0xFF, b2 = 0, a2 = 0x88}



