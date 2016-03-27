
CampDialogLayer = class("CampDialogLayer", function ( )
	return cc.Layer:create()
end)

CampDialogLayer.instance = nil

local function buySoldierTemple(self, prefix)
	local goldCount = GM:getGoldCount()	
	local ui = self:getChildByName("UI")
	local campLevel = GM:getLevel("Camp")
	local cost = GM:getSoldierCost(prefix)
	local soldierNum   = GM:getSoldierNum(prefix)
	local soldierLimit = GM:getSoldierLimit(prefix)
	if soldierNum >= soldierLimit then
		GM:showNotice("请升级兵营。", self)
		return
	end
	if goldCount < cost then
		GM:showNotice("金币不足。", self)
		return
	end
	GM:setGoldChange(-cost)
	GM:setSoldierNum(prefix)
	local soldierCount = ccui.Helper:seekWidgetByName(ui, prefix .. "Count")
	soldierCount:setString((soldierNum + 1) .. "/" .. soldierLimit)
	local wgGoldCount = ccui.Helper:seekWidgetByName(ui, "GoldCount")
	wgGoldCount:setString(GM:getGoldCount())
end

function CampDialogLayer.buyCallback(self, sender)
	local labLevel = researchLabSprite.level
	local name = sender:getName()
	if name == "BuyFighterButton" then
		buySoldierTemple(self, "Fighter")
	elseif name == "BuyBowmanButton" then
		if labLevel < 2 then
			GM:showNotice("请升级研究所。", self)
			return
		end
		buySoldierTemple(self, "Bowman")
	elseif name == "BuyGunnerButton" then
		if labLevel < 3 then
			GM:showNotice("请升级研究所。", self)
			return
		end
		buySoldierTemple(self, "Gunner")
	elseif name == "BuyMeatShieldButton" then
		if labLevel < 4 then
			GM:showNotice("请升级研究所。", self)
			return
		end
		buySoldierTemple(self, "MeatShield")
	end		
end

function CampDialogLayer.infoCallback(sender)
	-- 设置当前Layer以便关闭SoldierInfoDialogLayer时，把scene._dialogLayer设置回来
	local campDialogLayer = scene._dialogLayer
	campDialogLayer:setName("CampDialogLayer")
	local name = sender:getName()
	if name == "FighterInfoButton" then
		GM:showDialogLayer(SoldierInfoDialogLayer, 1)
	elseif name == "BowmanInfoButton" then
		GM:showDialogLayer(SoldierInfoDialogLayer, 2)
	elseif name == "GunnerInfoButton" then
		GM:showDialogLayer(SoldierInfoDialogLayer, 3)
	elseif name == "MeatShieldInfoButton" then
		GM:showDialogLayer(SoldierInfoDialogLayer, 4)
	end
end

function CampDialogLayer:addListener( )
	local ui = self:getChildByName("UI")
	-- 关闭按钮
	local btnClose = ccui.Helper:seekWidgetByName(ui, "CloseButton")
	btnClose:addClickEventListener(GM.closeDialogLayer)
	-- 信息按钮
	local btnFighterInfo = ccui.Helper:seekWidgetByName(ui, "FighterInfoButton")
	local btnBowmanInfo  = ccui.Helper:seekWidgetByName(ui, "BowmanInfoButton")
	local btnGunnerInfo  = ccui.Helper:seekWidgetByName(ui, "GunnerInfoButton")
	local btnMeatInfo    = ccui.Helper:seekWidgetByName(ui, "MeatShieldInfoButton")
	btnFighterInfo:addClickEventListener(CampDialogLayer.infoCallback)	
	btnBowmanInfo:addClickEventListener(CampDialogLayer.infoCallback)	
	btnGunnerInfo:addClickEventListener(CampDialogLayer.infoCallback)	
	btnMeatInfo:addClickEventListener(CampDialogLayer.infoCallback)	
	-- 训练按钮
	local btnFighterBuy = ccui.Helper:seekWidgetByName(ui, "BuyFighterButton")
	local btnBowmanBuy  = ccui.Helper:seekWidgetByName(ui, "BuyBowmanButton")
	local btnGunnerBuy  = ccui.Helper:seekWidgetByName(ui, "BuyGunnerButton")
	local btnMeatBuy    = ccui.Helper:seekWidgetByName(ui, "BuyMeatShieldButton")
	btnFighterBuy:addClickEventListener(function (...)
		CampDialogLayer.buyCallback(self, ...)
	end)
	btnBowmanBuy:addClickEventListener(function (...)
		CampDialogLayer.buyCallback(self, ...)
	end)	
	btnGunnerBuy:addClickEventListener(function (...)
		CampDialogLayer.buyCallback(self, ...)
	end)
	btnMeatBuy:addClickEventListener(function (...)
		CampDialogLayer.buyCallback(self, ...)
	end)
end

local function showSoldierPanelTemple(ui, self, prefix, minLabLevel)
	local labLevel = researchLabSprite.level
	local wgCost  = ccui.Helper:seekWidgetByName(ui, prefix .. "GoldRequire")
	local soldierLevel = GM:getLevel(prefix)
	local cost    = DM[prefix .. "Info"].cost[soldierLevel]
	local wgLevel = ccui.Helper:seekWidgetByName(ui, prefix .. "Level")
	wgCost:setString(cost)
	wgLevel:setString(soldierLevel)
	if labLevel < minLabLevel then
		local soldier = ccui.Helper:seekWidgetByName(ui, "Soldier_" .. prefix)
		local btnInfo = ccui.Helper:seekWidgetByName(ui, prefix .. "InfoButton")
		local btnBuy  = ccui.Helper:seekWidgetByName(ui, "Buy" .. prefix .. "Button")
		local children = soldier:getChildren()
		for i = 1, #children do
			children[i]:setColor(cc.c3b(160, 160, 160))
		end
		btnBuy:setColor(cc.c3b(160, 160, 160))
		btnInfo:setColor(cc.c3b(160, 160, 160))
	else
		local wgCount = ccui.Helper:seekWidgetByName(ui, prefix .. "Count")
		local campLevel = self.instance:getLevel()
		wgCount:setString(GM:getSoldierNum(prefix) .. "/" .. GM:getSoldierLimit(prefix))
	end
end

function CampDialogLayer:showDialog( )
	-- Action
	local scale = cc.ScaleTo:create(0.3, 1)
	local act   = cc.EaseBackOut:create(scale)
	self:runAction(act)

	local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_CAMP)
	local bg = cc.Sprite:create(IMG_GRAY_BG)
	bg:setScale(size.width / 1000, size.height / 1000)
	bg:setOpacity(128)
	bg:setPosition(size.width / 2, size.height / 2)
	self:addChild(bg, ORD_BG)
	self:addChild(ui, ORD_BOTTOM, "UI")

	-- 资源数量
	local goldCount = ccui.Helper:seekWidgetByName(ui, "GoldCount")
	local woodCount = ccui.Helper:seekWidgetByName(ui, "WoodCount")
	goldCount:setString(GM:getGoldCount())
	woodCount:setString(DM.Resource.woodCount)

	-- 士兵数量
	showSoldierPanelTemple(ui, self, "Fighter", 1)
	showSoldierPanelTemple(ui, self, "Bowman",  2)
	showSoldierPanelTemple(ui, self, "Gunner",  3)
	showSoldierPanelTemple(ui, self, "MeatShield", 4)

end

function CampDialogLayer:onEnter()
	self:setScale(0)
	self:showDialog()
	self:addListener()
end

function CampDialogLayer:create(instance)
	local campDialogLayer = CampDialogLayer.new()
	self.instance = instance

	campDialogLayer:onEnter()

	return campDialogLayer
end