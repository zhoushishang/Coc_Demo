
CampSprite = class("CampSprite", function (...)
	return BuildingBaseSprite:create(...)
end)

CampSprite.type = "UniqueBuilding"

Temple:initBuildingHP(CampSprite)

function CampSprite:onEnter()
	self:adjustBarPosition(0, 10)
end

function CampSprite:create(...)
	campSprite = CampSprite.new(IMG_BUILDING_CAMP)

	campSprite:onEnter()

	return campSprite
end