
ResearchLabSprite = class("ResearchLabSprite", function (...)
	return BuildingBaseSprite:create(...)
end)

ResearchLabSprite.type = "UniqueBuilding"

Temple:initBuildingHP(ResearchLabSprite)

function ResearchLabSprite:addSoldierImg()
	local bg = ccui.ImageView:create(IMG_BACK_UPGRADE)
	local img = ccui.ImageView:create()
	local barSize = self.upgradeBar:getContentSize()
	bg:setScale(40/bg:getContentSize().width)
	bg:setOpacity(128)
	bg:setPosition(-25, barSize.height/2)
	bg:addChild(img, ORD_TOP, "SoldierImg")
	img:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
	self.upgradeBar:addChild(bg, ORD_TOP, "SoldierImgBg")
end

function ResearchLabSprite:setSoldierImg(...)
	local img = self.upgradeBar:getChildByName("SoldierImgBg"):getChildByName("SoldierImg")
	img:loadTexture(...)
	local barSize = self.upgradeBar:getContentSize()
	img:setScale(45/img:getContentSize().width)
end

function ResearchLabSprite:onEnter()
	self:adjustBarPosition(-6, 10)
	self:addSoldierImg()
end

function ResearchLabSprite:create()
	researchLabSprite = ResearchLabSprite.new(IMG_BUILDING_RESEARCHLAB)

	researchLabSprite:onEnter()

	return researchLabSprite
end