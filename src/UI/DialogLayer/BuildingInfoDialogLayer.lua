
BuildingInfoDialogLayer = class("BuildingInfoDialogLayer", function (...)
	return cc.Layer:create(...)
end)

BuildingInfoDialogLayer.instance = nil 

function BuildingInfoDialogLayer:showInfo()
	local key = string.sub(self.instance.__cname, 1, -7)
	local level = self.instance:getLevel()
	local ui = self:getChildByName("UI")
	local title = ccui.Helper:seekWidgetByName(ui, "Title")
	local description = ccui.Helper:seekWidgetByName(ui, "Description")
	local healthPoint = ccui.Helper:seekWidgetByName(ui, "HealthPoint")
	local buildingImg = ccui.Helper:seekWidgetByName(ui, "BuildingImage")
	local titleText = DM[key .. "Info"].name .. "(Lv." .. level .. ")"
	title:setString(titleText)
	description:setString(DM[key .. "Info"].description)
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

function BuildingInfoDialogLayer:showDialog()
	local scaleIn = cc.ScaleTo:create(0.3, 1)
	local act = cc.EaseBackOut:create(scaleIn)
	self:runAction(act)

	local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_BUILDING_INFO)
	local bg = cc.Sprite:create(IMG_GRAY_BG)
	bg:setScale(size.width / 1000, size.height / 1000)
	bg:setOpacity(128)
	bg:setPosition(size.width / 2, size.height / 2)
	self:addChild(bg, ORD_BG)
	self:addChild(ui, ORD_BOTTOM, "UI")
	-- 关闭按钮
	local btnClose = ccui.Helper:seekWidgetByName(ui, "CloseButton")
	btnClose:addClickEventListener(GM.closeDialogLayer)
end

function BuildingInfoDialogLayer:onEnter()
	self:setScale(0)
	self:showDialog()
	self:showInfo()
end

function BuildingInfoDialogLayer:create(instance)
	local infoLayer = BuildingInfoDialogLayer.new()
	infoLayer.instance = instance

	infoLayer:onEnter()

	return infoLayer
end