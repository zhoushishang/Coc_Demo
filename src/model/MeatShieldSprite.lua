
MeatShieldSprite = class("MeatShieldSprite", function (...)
	return HumanBaseSprite:create(...)
end)

function MeatShieldSprite:moveInHome()
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

function MeatShieldSprite:onEnter()
	self.anim = ccs.Armature:create(ANIM_NAME_MEATSHIELD)
	self.currentHP = GM:getHP("MeatShield", GM:getLevel("MeatShield"))
	self.fullHP = self.currentHP
	self:addChild(self.anim)
end

function MeatShieldSprite:create()
	local meatShieldSprite = MeatShieldSprite.new()
	meatShieldSprite:setScale(0.7)

	meatShieldSprite:onEnter()

	return meatShieldSprite
end
