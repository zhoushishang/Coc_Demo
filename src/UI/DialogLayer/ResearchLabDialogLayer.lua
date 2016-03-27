
ResearchLabDialogLayer = class("ResearchLabDialogLayer", function (...)
	return cc.Layer:create(...)
end)

ResearchLabDialogLayer.researchLabSprite = nil

local function upSoldierTemple(self, prefix)
	-- 检测当前是否有正在升级的兵种
	if upgradingSoldier then
		GM:showNotice(upgradingSoldier .. " is upgrading ...", self)
		return
	end
	local labLevel = GM:getLevel("ResearchLab")
	local soldierLevel = GM:getLevel(prefix)
	local currentGold  = GM:getGoldCount()
	local requiredGold = GM:getSoldierUpgradeCost(prefix)
	if soldierLevel >= labLevel then
		GM:showNotice("请升级研究所。", self)
		return
	elseif currentGold < requiredGold then
		GM:showNotice("金币不足。", self)
		return
	elseif upgradingBuilding == "ResearchLab" then
		GM:showNotice("研究所正在升级，请稍后。", self)
		return
	end
	-- 扣除升级费用
	GM:setGoldChange(-requiredGold)
	-- 初始化升级进度条
	local upgradeBar = self.researchLabSprite.upgradeBar
	local barBg = upgradeBar:getParent()
	barBg:setVisible(true)
	upgradeBar:setPercent(0)
	-- 添加士兵图像
	local path = string.format("images/soilder/%s/%s_01.png", string.lower(prefix), string.lower(prefix))
	self.researchLabSprite:setSoldierImg(path)
	self.researchLabSprite.upgradeBar:getChildByName("SoldierImgBg"):setVisible(true)
	-- 开始升级
	local upgradeTime = GM:getUpgradeTime(prefix)
	local upgradeScheduleEntry = nil
	local soldierUpgradeStartingTime = os.time()

	local upgradeBarIsExist = true
	local function upgradeSchedule()
		local currentTime = os.time()
		local percent = (currentTime - soldierUpgradeStartingTime)/upgradeTime * 100
		if GM:getLayer("HomeMapLayer") and
			upgradeBarIsExist == false then
			local children = GM:getLayer("HomeMapLayer"):getChildren()
			for i = 1, #children do
				if children[i].__cname == "ResearchLabSprite" then
					upgradeBar = children[i].upgradeBar
					upgradeBar:getParent():setVisible(true)
					upgradeBarIsExist = true
					break
				end
			end
		end
		if upgradeBarIsExist then 
			if DM.Layer.HomeMapLayer then
				upgradeBar:setPercent(percent)
			else
				upgradeBarIsExist = false
			end
		end
		if currentTime - soldierUpgradeStartingTime >= upgradeTime then
			print(prefix .. " upgrade finish")
			if upgradeBarIsExist then
				upgradeBar:getParent():setVisible(false)
			end
			upgradingSoldier = nil
			GM:setLevel(prefix)
			scheduler:unscheduleScriptEntry(upgradeScheduleEntry)
			upgradeScheduleEntry = nil
		end
	end
	upgradingSoldier = prefix
	upgradeScheduleEntry = scheduler:scheduleScriptFunc(upgradeSchedule, 1, false)
	-- 退出升级界面
	GM:closeDialogLayer()  -- 执行完之后self就不存在了，所以要放在所有需要用到self的函数之后
end

function ResearchLabDialogLayer.upCallback(self, sender)
	local labLevel = researchLabSprite.level
	local name = sender:getName()
	if name == "UpFighterButton" then
		upSoldierTemple(self, "Fighter")
	elseif name == "UpBowmanButton" then
		if labLevel < 2 then
			GM:showNotice("请升级研究所。", self)
			return
		end
		upSoldierTemple(self, "Bowman")
	elseif name == "UpGunnerButton" then
		if labLevel < 3 then
			GM:showNotice("请升级研究所。", self)
			return
		end
		upSoldierTemple(self, "Gunner")
	elseif name == "UpMeatShieldButton" then
		if labLevel < 4 then
			GM:showNotice("请升级研究所。", self)
			return
		end
		upSoldierTemple(self, "MeatShield")
	end		
end

function ResearchLabDialogLayer.infoCallback(sender)
	-- 设置当前Layer以便关闭SoldierInfoDialogLayer时，把scene._dialogLayer设置回来
	local researchLabDialogLayer = scene._dialogLayer
	researchLabDialogLayer:setName("ResearchLabDialogLayer")
	local name = sender:getName()
	if name == "FighterInfoButton" then
		GM:showDialogLayer(SoldierInfoDialogLayer, 1, true)
	elseif name == "BowmanInfoButton" then
		GM:showDialogLayer(SoldierInfoDialogLayer, 2, true)
	elseif name == "GunnerInfoButton" then
		GM:showDialogLayer(SoldierInfoDialogLayer, 3, true)
	elseif name == "MeatShieldInfoButton" then
		GM:showDialogLayer(SoldierInfoDialogLayer, 4, true)
	end
end

function ResearchLabDialogLayer:addListener( )
	local ui = self:getChildByName("UI")

	-- 关闭按钮
	local btnClose = ccui.Helper:seekWidgetByName(ui, "CloseButton")
	btnClose:addClickEventListener(GM.closeDialogLayer)
	-- 信息按钮
	local btnFighterInfo = ccui.Helper:seekWidgetByName(ui, "FighterInfoButton")
	local btnBowmanInfo  = ccui.Helper:seekWidgetByName(ui, "BowmanInfoButton")
	local btnGunnerInfo  = ccui.Helper:seekWidgetByName(ui, "GunnerInfoButton")
	local btnMeatInfo    = ccui.Helper:seekWidgetByName(ui, "MeatShieldInfoButton")
	btnFighterInfo:addClickEventListener(ResearchLabDialogLayer.infoCallback)	
	btnBowmanInfo:addClickEventListener(ResearchLabDialogLayer.infoCallback)	
	btnGunnerInfo:addClickEventListener(ResearchLabDialogLayer.infoCallback)	
	btnMeatInfo:addClickEventListener(ResearchLabDialogLayer.infoCallback)	
	-- 升级按钮
	local btnFighterUp = ccui.Helper:seekWidgetByName(ui, "UpFighterButton")
	local btnBowmanUp  = ccui.Helper:seekWidgetByName(ui, "UpBowmanButton")
	local btnGunnerUp  = ccui.Helper:seekWidgetByName(ui, "UpGunnerButton")
	local btnMeatUp    = ccui.Helper:seekWidgetByName(ui, "UpMeatShieldButton")
	btnFighterUp:addClickEventListener(function (...)
		ResearchLabDialogLayer.upCallback(self, ...)
	end)
	btnBowmanUp:addClickEventListener(function (...)
		ResearchLabDialogLayer.upCallback(self, ...)
	end)	
	btnGunnerUp:addClickEventListener(function (...)
		ResearchLabDialogLayer.upCallback(self, ...)
	end)
	btnMeatUp:addClickEventListener(function (...)
		ResearchLabDialogLayer.upCallback(self, ...)
	end)
end

local function showSoldierPanelTemple(ui, prefix, minLabLevel)
	local labLevel = researchLabSprite.level
	local wgCost = ccui.Helper:seekWidgetByName(ui, prefix .. "GoldRequire")
	local soldierLevel = GM:getLevel(prefix)
	local cost = GM:getUpgradeGold(prefix)
	local wgLevel = ccui.Helper:seekWidgetByName(ui, prefix .. "Level")
	wgCost:setString(cost)
	wgLevel:setString(soldierLevel)
	if labLevel < minLabLevel then
		local soldier  = ccui.Helper:seekWidgetByName(ui, "Soldier_" .. prefix)
		local btnInfo  = ccui.Helper:seekWidgetByName(ui, prefix .. "InfoButton")
		local btnUp    = ccui.Helper:seekWidgetByName(ui, "Up" .. prefix .. "Button")
		local children = soldier:getChildren()
		for i = 1, #children do
			children[i]:setColor(cc.c3b(160, 160, 160))
		end
		btnUp:setColor(cc.c3b(160, 160, 160))
		btnInfo:setColor(cc.c3b(160, 160, 160))
	end
end

function ResearchLabDialogLayer:showDialog()
	-- Action
	local scale = cc.ScaleTo:create(0.3, 1)
	local act   = cc.EaseBackOut:create(scale)
	self:runAction(act)

	local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_LAB)
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
	woodCount:setString(GM:getWoodCount())

	-- 士兵信息
	showSoldierPanelTemple(ui, "Fighter", 1)
	showSoldierPanelTemple(ui, "Bowman",  2)
	showSoldierPanelTemple(ui, "Gunner",  3)
	showSoldierPanelTemple(ui, "MeatShield", 4)
end

function ResearchLabDialogLayer:onEnter()
	self:setScale(0)
	self:showDialog()
	self:addListener()
end

function ResearchLabDialogLayer:create(instance)
	local dialogLayer = ResearchLabDialogLayer.new()

	dialogLayer.researchLabSprite = instance
	dialogLayer:onEnter()

	return dialogLayer
end