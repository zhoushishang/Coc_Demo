
MineFactorySprite = class("MineFactorySprite", function (...)
	return BuildingBaseSprite:create(...)
end)

MineFactorySprite.TAG = nil

Temple:initBuildingHP(MineFactorySprite)

function MineFactorySprite:onEnter()
	self:adjustBarPosition(-6, 5)
end

function MineFactorySprite:create()
	local mineFactorySprite = MineFactorySprite.new(IMG_BUILDING_MINEFACTORY)

	mineFactorySprite:onEnter()

	return mineFactorySprite
end
