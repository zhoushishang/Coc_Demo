
BuildingUpgradeDialogLayer = class("BuildingUpgradeDialogLayer", function()
	return cc.Layer:create()
end)

BuildingUpgradeDialogLayer.instance = nil

function BuildingUpgradeDialogLayer:showRequire( )
	local key = string.sub(self.instance.__cname, 1, -7)
	local level = self.instance:getLevel()
	local ui = self:getChildByName("UI")
	local goldRequire = ccui.Helper:seekWidgetByName(ui, "GoldRequire")
	local woodRequire = ccui.Helper:seekWidgetByName(ui, "WoodRequire")
	local timeRequire = ccui.Helper:seekWidgetByName(ui, "TimeRequire")
	local upgradeGold = DM[key .. "Info"].upgradeGold[level + 1]
	local upgradeWood = DM[key .. "Info"].upgradeWood[level + 1]
	local upgradeTime = DM[key .. "Info"].upgradeTime[level + 1]
	goldRequire:setString(upgradeGold)
	woodRequire:setString(upgradeWood)
	timeRequire:setString(upgradeTime .. "s")
end

function BuildingUpgradeDialogLayer:showNextInfo( )
	local key = string.sub(self.instance.__cname, 1, -7)
	local level = GM:getLevel(key)
	local ui = self:getChildByName("UI")
	local healthPoint = ccui.Helper:seekWidgetByName(ui, "AddHealthPoint")
	local del = GM:getHP(key, level + 1) - GM:getHP(key, level)
	healthPoint:setString("+" .. del)
	if key == "ArrowTower" or
		key == "Cannon" or
		key == "Laser" then
        local damage = ccui.Helper:seekWidgetByName(ui, "AddDamage")
        local del = DM[key .. "Info"].damage[level + 1] - DM[key .. "Info"].damage[level]
		damage:setString("+" .. del)
	elseif key == "WoodFactory" then
		local woodProduct = ccui.Helper:seekWidgetByName(ui, "AddWoodProduct")
		local del = DM.WoodFactoryInfo.production[level + 1] - DM.WoodFactoryInfo.production[level]
		woodProduct:setString("+" .. del)
	elseif key == "MineFactory" then
		local goldProduct = ccui.Helper:seekWidgetByName(ui, "AddGoldProduct")
		local del = DM.MineFactoryInfo.production[level + 1] - DM.MineFactoryInfo.production[level]
		goldProduct:setString("+" .. del)
	elseif key == "BaseTower" then
		local goldCapacity   = ccui.Helper:seekWidgetByName(ui, "AddGoldCapacity")
		local woodCapacity   = ccui.Helper:seekWidgetByName(ui, "AddWoodCapacity")
		local delGold = DM.BaseTowerInfo.MineCapacity[level + 1] - DM.BaseTowerInfo.MineCapacity[level]
		local delWood = DM.BaseTowerInfo.WoodCapacity[level + 1] - DM.BaseTowerInfo.WoodCapacity[level]
		goldCapacity:setString("+" .. delGold)
		woodCapacity:setString("+" .. delWood)
		-- BuildingLimit
		local scrollView  = ccui.Helper:seekWidgetByName(ui, "ScrollView")
		local mineFactory = ccui.Helper:seekWidgetByName(ui, "MineFactoryLimit")
		local woodFactory = ccui.Helper:seekWidgetByName(ui, "WoodFactoryLimit")
		local arrowTower  = ccui.Helper:seekWidgetByName(ui, "ArrowTowerLimit")
		local cannon      = ccui.Helper:seekWidgetByName(ui, "CannonLimit")
		local laser       = ccui.Helper:seekWidgetByName(ui, "LaserLimit")
		scrollView:setVisible(true)
		woodFactory:setString("+" .. DM.BaseTowerInfo.WoodFactoryLimit[level + 1] - DM.BaseTowerInfo.WoodFactoryLimit[level])
		mineFactory:setString("+" .. DM.BaseTowerInfo.MineFactoryLimit[level + 1] - DM.BaseTowerInfo.MineFactoryLimit[level])
		arrowTower:setString("+" .. DM.BaseTowerInfo.ArrowTowerLimit[level + 1] - DM.BaseTowerInfo.ArrowTowerLimit[level])
		cannon:setString("+" .. DM.BaseTowerInfo.CannonLimit[level + 1] - DM.BaseTowerInfo.CannonLimit[level])
		laser:setString("+" .. DM.BaseTowerInfo.LaserLimit[level + 1] - DM.BaseTowerInfo.LaserLimit[level])
	end
end

function BuildingUpgradeDialogLayer:showNowInfo()
	local key = string.sub(self.instance.__cname, 1, -7)
	local level = self.instance:getLevel()
	local ui = self:getChildByName("UI")
	local title = ccui.Helper:seekWidgetByName(ui, "Title")
	local healthPoint = ccui.Helper:seekWidgetByName(ui, "HealthPoint")
	local buildingImg = ccui.Helper:seekWidgetByName(ui, "BuildingImage")
	local titleText = DM[key .. "Info"].name .. "(Lv." .. level .. " -> " .. "Lv.".. (level + 1) .. ")"
	title:setString(titleText)
	healthPoint:setString(DM[key .. "Info"].healthPoint[level])
	buildingImg:loadTexture(GM:getBuildingImg(self.instance))
	if key == "ArrowTower" or
		key == "Cannon" or
		key == "Laser" then
		local lbDamage      = ccui.Helper:seekWidgetByName(ui, "lbDamage")
        local lbAttackSpeed = ccui.Helper:seekWidgetByName(ui, "lbAttackSpeed")
        local lbShootRange  = ccui.Helper:seekWidgetByName(ui, "lbShootRange")
        local damage        = ccui.Helper:seekWidgetByName(ui, "Damage")
        local attackGap   = ccui.Helper:seekWidgetByName(ui, "AttackGap")
        local shootRange    = ccui.Helper:seekWidgetByName(ui, "ShootRange")
        lbDamage:setVisible(true)  
		lbAttackSpeed:setVisible(true)
		lbShootRange:setVisible(true)
		damage:setString(DM[key .. "Info"].damage[level])
		attackGap:setString(DM[key .. "Info"].AttackGap)
		shootRange:setString(DM[key .. "Info"].ShootRange)
	elseif key == "WoodFactory" then
		local lbWoodProduct = ccui.Helper:seekWidgetByName(ui, "lbWoodProduct")
		local woodProduct  = ccui.Helper:seekWidgetByName(ui, "WoodProduct")
		lbWoodProduct:setVisible(true)
		woodProduct:setString(DM.WoodFactoryInfo.production[level])
	elseif key == "MineFactory" then
		local lbGoldProduct = ccui.Helper:seekWidgetByName(ui, "lbGoldProduct")
		local goldProduct  = ccui.Helper:seekWidgetByName(ui, "GoldProduct")
		lbGoldProduct:setVisible(true)
		goldProduct:setString(DM.MineFactoryInfo.production[level])
	elseif key == "BaseTower" then
		local lbGoldCapacity = ccui.Helper:seekWidgetByName(ui, "lbGoldCapacity")
		local lbWoodCapacity  = ccui.Helper:seekWidgetByName(ui, "lbWoodCapacity")
		local goldCapacity   = ccui.Helper:seekWidgetByName(ui, "GoldCapacity")
		local woodCapacity   = ccui.Helper:seekWidgetByName(ui, "WoodCapacity")
		lbGoldCapacity:setVisible(true)
		lbWoodCapacity:setVisible(true)
		goldCapacity:setString(DM.BaseTowerInfo.MineCapacity[level])
		woodCapacity:setString(DM.BaseTowerInfo.WoodCapacity[level])
		-- BuildingLimit
		local scrollView  = ccui.Helper:seekWidgetByName(ui, "ScrollView")
		local mineFactory = ccui.Helper:seekWidgetByName(ui, "MineFactoryLimit")
		local woodFactory = ccui.Helper:seekWidgetByName(ui, "WoodFactoryLimit")
		local arrowTower  = ccui.Helper:seekWidgetByName(ui, "ArrowTowerLimit")
		local cannon      = ccui.Helper:seekWidgetByName(ui, "CannonLimit")
		local laser       = ccui.Helper:seekWidgetByName(ui, "LaserLimit")
		scrollView:setVisible(true)
		--scrollView:setContentSize(735, 130)
		woodFactory:setString("x" .. DM.BaseTowerInfo.WoodFactoryLimit[level])
		mineFactory:setString("x" .. DM.BaseTowerInfo.MineFactoryLimit[level])
		arrowTower:setString("x" .. DM.BaseTowerInfo.ArrowTowerLimit[level])
		cannon:setString("x" .. DM.BaseTowerInfo.CannonLimit[level])
		laser:setString("x" .. DM.BaseTowerInfo.LaserLimit[level])
	end
end

local function updateLevel(key, tag)
	if tag then -- 非UniqueBuilding
		DM.Player[key .. 's'].level[tag] = DM.Player[key .. 's'].level[tag] + 1
	else
		DM.Player[key].level = DM.Player[key].level + 1
	end
end

local function buildingUpgrade(self)
	-- 检测当前是否有正在升级的建筑
	if upgradingBuilding then
		GM:showNotice(upgradingBuilding .. " is upgrading ...", self)
		return
	end
	local key = string.sub(self.instance.__cname, 1, -7)
	local baseLevel = baseTowerSprite.level
	local buildingLevel = self.instance:getLevel()
	local currentGold = GM:getGoldCount()
	local currentWood = GM:getWoodCount()
	local requiredGold = GM:getUpgradeGold(key, self.instance.TAG)
	local requiredWood = GM:getUpgradeWood(key, self.instance.TAG)
	if buildingLevel >= baseLevel + 1 and
		key ~= "BaseTower" then
		GM:showNotice("请升级主基地。", self)
		return
	elseif key == "BaseTower" then
		local playerLevel = DM.Player.level
		if playerLevel < baseLevel + 1 then
			GM:showNotice("需要玩家等级" .. (baseLevel + 1), self)
			return
		end
	end
	if key == "ResearchLab" then
		if upgradingSoldier then
			GM:showNotice("正在升级兵种，请等待。", self)
			return
		end
		self.instance.upgradeBar:getChildByName("SoldierImgBg"):setVisible(false)
	end
	if currentGold < requiredGold then
		GM:showNotice("金币不足。", self)
		return
	elseif currentWood < requiredWood then
		GM:showNotice("木材不足。", self)
		return
	end
	-- 扣除升级费用
	GM:setGoldChange(-requiredGold)
	GM:setWoodChange(-requiredWood)
	-- 初始化升级进度条
	local upgradeBar = self.instance.upgradeBar
	upgradeBar:getParent():setVisible(true)
	upgradeBar:setPercent(0)
	-- 开始升级
	local upgradeTime = DM[key .. "Info"].upgradeTime[buildingLevel + 1]
	local upgradeScheduleEntry = nil
	local buildingUpgradeStartingTime = os.time()
	local instance = self.instance
	local tag = instance.TAG
	local upgradeBarIsExist = true
	local function upgradeSchedule()
		local currentTime = os.time()
		local percent = (currentTime - buildingUpgradeStartingTime)/upgradeTime * 100
		if DM.Layer.HomeMapLayer and
			upgradeBarIsExist == false then
			local children = DM.Layer.HomeMapLayer:getChildren()
			for i = 1, #children do
				if children[i].__cname == key .. "Sprite" and
				   tag == children[i].TAG then
				   	instance = children[i]
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
		if currentTime - buildingUpgradeStartingTime >= upgradeTime then
			print(key .. " upgrade finish")
			if upgradeBarIsExist then
				upgradeBar:getParent():setVisible(false)
			end
			updateLevel(key, tag)
			upgradingBuilding = nil
			-- 增加Player的经验值
			local exp = GM:getUpgradeEXP(key, GM:getLevel(key, tag))
			GM:setPlayerEXPIncrease(exp)
			local homeHudLayer = GM:getLayer("HomeHudLayer")
			if homeHudLayer then
				homeHudLayer:showEXP()
			end
			scheduler:unscheduleScriptEntry(upgradeScheduleEntry)
			upgradeScheduleEntry = nil
		end
	end
	upgradingBuilding = key
	upgradeScheduleEntry = scheduler:scheduleScriptFunc(upgradeSchedule, 1, false)
	-- 退出升级界面
	GM:closeDialogLayer()  -- 执行完之后self就不存在了，所以要放在所有需要用到self的函数之后
end

function BuildingUpgradeDialogLayer:showDialog()
	local scaleIn = cc.ScaleTo:create(0.3, 1)
	local act = cc.EaseBackOut:create(scaleIn)
	self:runAction(act)

	local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_BUILDING_UPGRADE)
	local bg = cc.Sprite:create(IMG_GRAY_BG)
	bg:setScale(size.width / 1000, size.height / 1000)
	bg:setOpacity(128)
	bg:setPosition(size.width / 2, size.height / 2)
	self:addChild(bg, ORD_BG)
	self:addChild(ui, ORD_BOTTOM, "UI")
	-- 关闭按钮
	local btnClose = ccui.Helper:seekWidgetByName(ui, "CloseButton")
	btnClose:addClickEventListener(GM.closeDialogLayer)
	-- 升级按钮
	local btnUpgrade = ccui.Helper:seekWidgetByName(ui, "UpgradeButton")
	local function upgradeCallback()
		buildingUpgrade(self)
	end
	btnUpgrade:addClickEventListener(upgradeCallback)
end

function BuildingUpgradeDialogLayer:onEnter()
	self:setScale(0)
	self:showDialog()
    self:showNowInfo()
    self:showNextInfo()
    self:showRequire()
end

function BuildingUpgradeDialogLayer:create(class)
	local upgradeDialogLayer = BuildingUpgradeDialogLayer.new()

	self.instance = class
	upgradeDialogLayer:onEnter(class)

	return upgradeDialogLayer
end