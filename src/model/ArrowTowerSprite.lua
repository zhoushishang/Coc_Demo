
ArrowTowerSprite = class("ArrowTowerSprite", function (...)
	return BuildingBaseSprite:create(...)
end)

ArrowTowerSprite.TAG = nil
ArrowTowerSprite.subType = "ATKBuilding"

Temple:initBuildingHP(ArrowTowerSprite)

function ArrowTowerSprite:onEnter()
	self:adjustBarPosition(0, 23)
end

function ArrowTowerSprite:create()
	local arrowTowerSprite = ArrowTowerSprite.new(IMG_BUILDING_ARROWTOWER)

	arrowTowerSprite:onEnter()

	return arrowTowerSprite
end
