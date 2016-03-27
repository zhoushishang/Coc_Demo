
NewBuildDialogLayer = class("NewBuildDialogLayer", function ()
	return ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_NEWBUILD)
end)

NewBuildDialogLayer.goldCount = nil
NewBuildDialogLayer.woodCount = nil
NewBuildDialogLayer.MineFactoryCount = nil
NewBuildDialogLayer.WoodFactoryCount = nil
NewBuildDialogLayer.ArrowTowerCount  = nil
NewBuildDialogLayer.CannonCount      = nil
NewBuildDialogLayer.LaserCount       = nil

function NewBuildDialogLayer:closeCallback()
	GlobalManager:closeDialogLayer()
end

local function addBuildingTemple(class, pos, layer, self, prefix)
	local sprite = class:create()
	local buildingNum = #DM.Player[prefix .. "s"].level
	sprite.TAG = buildingNum + 1
	local contentSize = sprite:getContentSize()
	local count = GM:getBuildingCount(prefix .. "Sprite")
	local limit = GM:getBuildingLimit(prefix .. "Sprite")
	local chost = DM[prefix .. "Info"].upgradeGold[1]
	local gold = GM:getGoldCount()
	if count >= limit then
		GM:showNotice("升级司令部等级，可建造更多建筑", self)
		return
	end
	if chost > gold then
		GM:showNotice("金币不足", self)
		return
	end

	-- 添加取消和确认按钮
	local okBtn = ccui.Button:create(IMG_BUTTON_OK)
	local cancleBtn = ccui.Button:create(IMG_BUTTON_CANCLE)
	local tag = sprite.TAG
	local function okCallback()
		GM:setGoldChange(-chost)
		sprite.isSelected = false
		sprite:unselectedAction()
		sprite:setLevel(1)
		sprite:storePos(GM:getNodePosition(sprite))
		-- 增加Player的经验值
		local exp = GM:getUpgradeEXP(prefix, 1)
		GM:setPlayerEXPIncrease(exp)
		local homeHudLayer = GM:getLayer("HomeHudLayer")
		if homeHudLayer then
			homeHudLayer:showEXP()
		end
		okBtn:removeFromParent()
		cancleBtn:removeFromParent()
		local name = string.sub(sprite.__cname, 1, -7)
	end
	local function cancelCallback()
		okBtn:removeFromParent()
		cancleBtn:removeFromParent()
		sprite:removeFromParent()
	end
	okBtn:addClickEventListener(okCallback)
	cancleBtn:addClickEventListener(cancelCallback)
	okBtn:setPosition(contentSize.width * 2 / 3 + 10, contentSize.height + 20)
	cancleBtn:setPosition(contentSize.width / 3 - 10, contentSize.height + 20)
	sprite:addChild(okBtn)
	sprite:addChild(cancleBtn)
	-- 把建筑设为选中状态
	sprite.tipImg:setOpacity(255)
	sprite.isSelected = true
	sprite:selectedAction()
	sprite:setPosition(pos)
	sprite:removeHPBar()
	layer:addChild(sprite, layer.PRIORITY_BUILDIND)
	GlobalManager:closeDialogLayer()
end

function NewBuildDialogLayer:newBuildingCallback(widget)
	local buttonName = widget:getName()
	local homeMapLayer = scene:getChildByTag(TAG_LAYER_HOME):getChildByTag(TAG_LAYER_HOME_MAP)
	if buttonName == "MineFactoryButton" then
		local pos = cc.p(size.width / 4 , size.height / 2)
		addBuildingTemple(MineFactorySprite, pos, homeMapLayer, self, "MineFactory")
	elseif buttonName == "WoodFactoryButton" then
		local pos = cc.p(size.width / 2, size.height / 4)
		addBuildingTemple(WoodFactorySprite, pos, homeMapLayer, self, "WoodFactory")
	elseif buttonName == "ArrowTowerButton" then
		local pos = cc.p(size.width * 3 / 4, size.height / 2)
		addBuildingTemple(ArrowTowerSprite, pos, homeMapLayer, self, "ArrowTower")	
	elseif buttonName == "CannonButton" then
		local pos = cc.p(size.width / 2, size.height * 3 / 4)
		addBuildingTemple(CannonSprite, pos, homeMapLayer, self, "Cannon")	
	elseif buttonName == "LaserButton" then
		local pos = cc.p(size.width * 3 / 4, size.height * 3 / 4)
		addBuildingTemple(LaserSprite, pos, homeMapLayer, self, "Laser")	
	end
end

local function addEventTemple(layer, prefix)
	local button = ccui.Helper:seekWidgetByName(layer, prefix .. "Button")
	button:addClickEventListener(function ()
		return layer:newBuildingCallback(button)
	end)
end

function NewBuildDialogLayer:addEvents()
	local closeButton = ccui.Helper:seekWidgetByName(self, "CloseButton")
	closeButton:addClickEventListener(self.closeCallback)

	addEventTemple(self, "MineFactory")
	addEventTemple(self, "WoodFactory")
	addEventTemple(self, "ArrowTower")
	addEventTemple(self, "Cannon")
	addEventTemple(self, "Laser")
end

local function initPanelTemple(self, prefix)
	local count = GM:getBuildingCount(prefix .. "Sprite")
	local limit = GM:getBuildingLimit(prefix .. "Sprite")
	local wgCost = ccui.Helper:seekWidgetByName(self, prefix .. "Require")
	local cost = DM[prefix .. "Info"].upgradeGold[1]
	wgCost:setString(cost)
	self[prefix .. "Count"] = ccui.Helper:seekWidgetByName(self, prefix .. "Count")
	self[prefix .. "Count"]:setString(count .. "/" .. limit)
	if count >= limit then
        local btn = ccui.Helper:seekWidgetByName(self, prefix .. "Button");
        local img = ccui.Helper:seekWidgetByName(self, "Building_" .. prefix);
        btn:setBright(false)
    end
end

function NewBuildDialogLayer:init()
	self.goldCount = ccui.Helper:seekWidgetByName(self, "GoldCount")
	self.goldCount:setString(GM:getGoldCount())
	self.woodCount = ccui.Helper:seekWidgetByName(self, "WoodCount")
	self.woodCount:setString(DM.Resource.woodCount)

	initPanelTemple(self, "MineFactory")
	initPanelTemple(self, "WoodFactory")
	initPanelTemple(self, "ArrowTower")
	initPanelTemple(self, "Cannon")
	initPanelTemple(self, "Laser")
end

function NewBuildDialogLayer:onEnter()
	self:addEvents()
	self:init()
end

function NewBuildDialogLayer:create()
	local NewBuildDialogLayer = NewBuildDialogLayer.new()

	NewBuildDialogLayer:onEnter()

	return NewBuildDialogLayer
end