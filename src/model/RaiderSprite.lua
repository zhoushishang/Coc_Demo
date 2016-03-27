
RaiderSprite = class("RaiderSprite", function (...)
	return BuildingBaseSprite:create(...)
end)

RaiderSprite.type = "UniqueBuilding"

Temple:initBuildingHP(RaiderSprite)

function RaiderSprite:onEnter()
	self:adjustBarPosition(0, 5)
end

function RaiderSprite:create()
	local raiderSprite = RaiderSprite.new(IMG_BUILDING_RAIDER)

	raiderSprite:onEnter()

	return raiderSprite
end