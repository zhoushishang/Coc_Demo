function BuildingBaseSprite:addUpgradeBar()
	local bg = cc.Sprite:create(IMG_BUILD_PRO_BK)
	local upgradeBar = ccui.LoadingBar:create(IMG_BUILD_PRO, 0)
	local contentSize = self:getContentSize()
	upgradeBar:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
	bg:addChild(upgradeBar, ORD_TOP, "Bar")
	bg:setPosition(contentSize.width / 2 - 6, contentSize.height + 10)
	bg:setVisible(false)
	self:addChild(bg, ORD_TOP, "BarBg")
	self.upgradeBar = upgradeBar
end