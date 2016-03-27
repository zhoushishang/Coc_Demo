
WoodFactorySprite = class("WoodFactorySprite", function (...)
	return BuildingBaseSprite:create(...)
end)

WoodFactorySprite.TAG = nil

Temple:initBuildingHP(WoodFactorySprite)

function WoodFactorySprite:onEnter()
	self:adjustBarPosition(0, 5)
end

function WoodFactorySprite:create()
	local woodFactorySprite = WoodFactorySprite.new(IMG_BUILDING_WOODFACTORY)

	woodFactorySprite:onEnter()

	return woodFactorySprite
end
