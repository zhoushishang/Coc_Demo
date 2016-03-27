
BaseTowerSprite = class("BaseTowerSprite", function (...)
	return BuildingBaseSprite:create(...)
end)

BaseTowerSprite.type = "UniqueBuilding"

Temple:initBuildingHP(BaseTowerSprite)

function BaseTowerSprite:onEnter()
	self:adjustBarPosition(0, 5)
end

function BaseTowerSprite:create(...)
	baseTowerSprite = BaseTowerSprite.new(IMG_BUILDING_BASETOWER)

	baseTowerSprite:onEnter()

	return baseTowerSprite
end
