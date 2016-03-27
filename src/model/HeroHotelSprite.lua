
HeroHotelSprite = class("HeroHotelSprite", function (...)
	return BuildingBaseSprite:create(...)
end)

HeroHotelSprite.type = "UniqueBuilding"

Temple:initBuildingHP(HeroHotelSprite)

function HeroHotelSprite:onEnter()
	self:adjustBarPosition(0, 20)
end

function HeroHotelSprite:create()
	local heroHotelSprite = HeroHotelSprite.new(IMG_BUILDING_HEROHOTEL)

	heroHotelSprite:onEnter()

	return heroHotelSprite
end