
BulletSprite = class("BulletSprite", function(...)
		return cc.Sprite:create(...)
	end)

BulletSprite.attacker = nil
BulletSprite.target   = nil
BulletSprite.damage   = nil

function BulletSprite:shoot()
	self:setPosition(self.attacker:getPosition())
	local src = GM:getNodePosition(self.attacker)
	local des = GM:getNodePosition(self.target)
	local vec = cc.pSub(des, src)
	local ang = cc.pGetAngle(cc.p(1, 0), vec)
	self:setRotation(-ang*180/3.1416)  -- 顺时针方向
	local distance = cc.pGetDistance(src, des)
	local movTime = distance / DM.Speed.Bullet
	local act = cc.MoveTo:create(movTime, des)
	local function atk()
		-- 建筑物损坏时存在n颗子弹，hurt会被触发n次，从而run也会被触发n次
		if self.attacker.state == "running" then 
		-- 在running的时候不继续触发hurt函数，解决多颗子弹导致位移叠加bug
			return
		end
		self.target:hurt(self.damage)
		self:removeFromParent()
		self:setVisible(false)
	end
	local acf = cc.CallFunc:create(atk)
	local seq = cc.Sequence:create(act, acf)
	self:runAction(seq)
end

function BulletSprite:onEnter(attacker, target, damage)
	local effectNode = attacker:getParent().effectNode
	self.attacker = attacker
	self.target = target
	self.damage = damage
	self:setAnchorPoint(0.3, 0.5)
	self:setScale(0.5)
	effectNode:addChild(self)
end

function BulletSprite:create(attacker, target, damage)
	local bulletSprite = nil
	local cname = attacker.__cname
	if cname == "BowmanSprite" then
		bulletSprite = BulletSprite.new(IMG_BULLET_ARROW)
	elseif cname == "GunnerSprite" then
		bulletSprite = BulletSprite.new(IMG_BULLET_FIRE)
	elseif cname == "LaserSprite" then
		bulletSprite = BulletSprite.new(IMG_BULLET_LASER)
	elseif cname == "CannonSprite" then
		bulletSprite = BulletSprite.new(IMG_BULLET_SHELL_RED)
	else
		bulletSprite = BulletSprite.new(IMG_BULLET_SHELL)
	end

	bulletSprite:onEnter(attacker, target, damage, rotation)

	return bulletSprite
end