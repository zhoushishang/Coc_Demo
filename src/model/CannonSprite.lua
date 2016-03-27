
CannonSprite = class("CannonSprite", function (...)
	return BuildingBaseSprite:create(...)
end)

CannonSprite.TAG = nil
CannonSprite.subType = "ATKBuilding"

Temple:initBuildingHP(CannonSprite)

function CannonSprite:onEnter()
	self:adjustBarPosition(0, 20)
end

function CannonSprite:create()
	local cannonSprite = CannonSprite.new(IMG_BUILDING_CANNON)

	cannonSprite:onEnter()

	return cannonSprite
end
