
SoldierInfoDialogLayer = class("SoldierInfoDialogLayer", function ( )
	return cc.Layer:create()
end)

SoldierInfoDialogLayer._scheduleEntry = nil
SoldierInfoDialogLayer.isUpgradeInfo  = nil

function SoldierInfoDialogLayer:showInfo(id)
	local key = nil
	local anim = nil
	if id == 1 then
		key = "FighterInfo"
		anim = ccs.Armature:create(ANIM_NAME_FIGHTER)
	elseif id == 2 then
		key = "BowmanInfo"
		anim = ccs.Armature:create(ANIM_NAME_BOWMAN)
	elseif id == 3 then	
		key = "GunnerInfo"
		anim = ccs.Armature:create(ANIM_NAME_GUNNER)
	elseif id == 4 then
		key = "MeatShieldInfo"
		anim = ccs.Armature:create(ANIM_NAME_MEATSHIELD)
	end
	local ui = self:getChildByName("UI")
	local title = ccui.Helper:seekWidgetByName(ui, "Title")
	local description = ccui.Helper:seekWidgetByName(ui, "Description")
	local healthPoint = ccui.Helper:seekWidgetByName(ui, "HealthPoint")
	local damage = ccui.Helper:seekWidgetByName(ui, "Damage")
	local atkGap = ccui.Helper:seekWidgetByName(ui, "AttackGap")
	local shootRange = ccui.Helper:seekWidgetByName(ui, "ShootRange")
	local level = GM:getLevel(string.sub(key, 1, -5))
	local titleTex = DM[key].name .. " Lv." .. level
	title:setString(titleTex)
	description:setString(DM[key].description)
	healthPoint:setString(DM[key].healthPoint[level])
	damage:setString(DM[key].damage[level])
	atkGap:setString(DM[key].AttackGap .."s")
	shootRange:setString(DM[key].ShootRange)
	-- 显示升级信息
	if self.isUpgradeInfo then
		local hpGap = DM[key].healthPoint[level + 1] - DM[key].healthPoint[level]
		local damageGap = DM[key].damage[level + 1] - DM[key].damage[level]
		local labelHpGap = cc.LabelTTF:create("+ " .. hpGap, "微软雅黑", 26)
		labelHpGap:setColor(cc.c3b(255, 0, 0))
		labelHpGap:setPosition(80, 12)
		labelHpGap:setAnchorPoint(0, 0.5)
		healthPoint:addChild(labelHpGap)
		local labelDamageGape = cc.LabelTTF:create("+ " .. damageGap, "微软雅黑", 26)
		labelDamageGape:setColor(cc.c3b(255, 0, 0))
		labelDamageGape:setPosition(80, 12)
		labelDamageGape:setAnchorPoint(0, 0.5)
		damage:addChild(labelDamageGape)
		local titleTex = DM[key].name .. " Lv." .. level .. " -> Lv." .. (level + 1)
		title:setString(titleTex)
	end

	-- 士兵动画
	anim:setPosition(250, 360)
	anim:setScale(3)
	ui:addChild(anim)
	anim:getAnimation():play("run0")
	local scheduleEntry = nil
	local function animRandom()
		if scene._dialogLayer ~= self then
			if scheduleEntry then
				scheduler:unscheduleScriptEntry(scheduleEntry)
				scheduleEntry = nil
			end
			return
		end
		local num = math.random(0, 16)
		num = math.floor(num)
		if num < 8 then
			anim:getAnimation():play("run" .. num)
		elseif num ~= 16 then
			anim:getAnimation():play("atk" .. (num - 8))
		else
			anim:getAnimation():play("atk7")
		end
	end
	scheduleEntry = scheduler:scheduleScriptFunc(animRandom, 3, false)
end

function SoldierInfoDialogLayer:showDialog(ID)
	-- Action
	local scale = cc.ScaleTo:create(0.3, 1)
	local act   = cc.EaseBackOut:create(scale)
	self:runAction(act)
	
	local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_SOILDER_INFO)
	self:addChild(ui, ORD_TOP, "UI")
	-- 关闭按钮
	local btnClose = ccui.Helper:seekWidgetByName(ui, "CloseButton")
	btnClose:addClickEventListener(function()
		GM:closeDialogLayer()
		local campDialogLayer = scene:getChildByName("CampDialogLayer")
		local researchLabDialogLayer = scene:getChildByName("ResearchLabDialogLayer")
		if campDialogLayer then
			scene._dialogLayer = campDialogLayer
		else
			scene._dialogLayer = researchLabDialogLayer
		end
	end)
end

function SoldierInfoDialogLayer:onEnter(ID)
	self:setScale(0)
	self:showDialog()
	self:showInfo(ID)
end

function SoldierInfoDialogLayer:create(ID, isUpgradeInfo)
	local soldierInfoDialogLayer = SoldierInfoDialogLayer.new()

	self.isUpgradeInfo = isUpgradeInfo
	soldierInfoDialogLayer:onEnter(ID)

	return soldierInfoDialogLayer
end