
HeroSprite = class("HeroSprite", function (...)
	return HumanBaseSprite:create(...)
end)

function HeroSprite:moveInHome()
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

function HeroSprite:onEnter()
	self.anim = ccs.Armature:create(ANIM_NAME_ARAGORN)
	self.anim:getAnimation():play("idle0")
	self.currentHP = GM:getHP("Hero", GM:getLevel("Hero"))
	self.fullHP = self.currentHP
	self:addChild(self.anim)
end

function HeroSprite:create()
	local heroSprite = HeroSprite.new(heroSize)

	heroSprite:onEnter()

	return heroSprite
end
