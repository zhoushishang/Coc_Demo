
FrighterSprite = class("FrighterSprite", function (...)
	return HumanBaseSprite:create(...)
end)

function FrighterSprite:moveInHome()
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

function FrighterSprite:onEnter()
	self.anim = ccs.Armature:create(ANIM_NAME_FIGHTER)
	self.currentHP = DM.HP.Frighter
	self.fullHP = DM.HP.Frighter
	self:addChild(self.anim)
end

function FrighterSprite:create()
	local fighterSprite = FrighterSprite.new()
	--fighterSprite:setScale(0.7)

	fighterSprite:onEnter()

	return fighterSprite
end
