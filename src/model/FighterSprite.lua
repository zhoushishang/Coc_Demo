
FighterSprite = class("FighterSprite", function (...)
	return HumanBaseSprite:create(...)
end)

function FighterSprite:moveInHome()
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

function FighterSprite:onEnter()
	self.anim = ccs.Armature:create(ANIM_NAME_FIGHTER)
	self.currentHP = GM:getHP("Fighter", GM:getLevel("Fighter"))
	self.fullHP = self.currentHP
	self:addChild(self.anim)
end

function FighterSprite:create()
	local fighterSprite = FighterSprite.new()
	--fighterSprite:setScale(0.7)

	fighterSprite:onEnter()

	return fighterSprite
end
