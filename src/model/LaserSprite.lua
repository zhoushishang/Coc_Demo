
LaserSprite = class("LaserSprite", function (...)
	return BuildingBaseSprite:create(...)
end)

LaserSprite.TAG = nil
LaserSprite.subType = "ATKBuilding"

Temple:initBuildingHP(LaserSprite)

function LaserSprite:onEnter()
	self:adjustBarPosition(0, 0)
end

function LaserSprite:create()
	local laserSprite = LaserSprite.new(IMG_BUILDING_LASER)

	laserSprite:onEnter()

	return laserSprite
end
