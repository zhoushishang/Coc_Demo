
GunnerSprite = class("GunnerSprite", function (...)
	return HumanBaseSprite:create(...)
end)

function GunnerSprite:moveInHome()
	self:runAction(cc.Place:create(size.width / 4, size.height / 3))
	self.anim:getAnimation():play("run6")
	local ac1 = cc.MoveBy:create(2, cc.p(size.width / 2, 0))
	local ac2 = act1:reverse()
	local function rightIdle(self)
		self.anim:getAnimation():play("idle6")
	end
	local acf1 = cc.CallFunc:create(rightIdle)
	local function leftIdle(self)
		self.anim:getAnimation():play("idle2")
	end
	local acf1 = cc.CallFunc:create(rightIdle)
end

function GunnerSprite:onEnter()
	self.anim = ccs.Armature:create(ANIM_NAME_GUNNER)
	self.currentHP = GM:getHP("Gunner", GM:getLevel("Gunner"))
	self.fullHP = self.currentHP
	self:addChild(self.anim)
end

function GunnerSprite:create()
	local gunnerSprite = GunnerSprite.new()
	--gunnerSprite:setScale(0.7)
	
	gunnerSprite:onEnter()

	return gunnerSprite
end
