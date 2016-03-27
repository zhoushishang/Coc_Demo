
BattleHudLayer = class("BattleHudLayer", function ()
	return ccs.GUIReader:getInstance():widgetFromJsonFile(UI_LAYER_BATTLEHUD)
end)

BattleHudLayer.btnSelected   = nil
BattleHudLayer.SelectItem    = nil
BattleHudLayer.FighterNum    = 0 
BattleHudLayer.BowmanNum     = 0 
BattleHudLayer.GunnerNum     = 0 
BattleHudLayer.MeatShieldNum = 0
BattleHudLayer.HeroNum       = 1
BattleHudLayer.btnEnemy      = nil

function BattleHudLayer:getSelectedSoldierNum()
	if self.SelectItem then
		local name = string.sub(self.SelectItem.__cname, 1, -7)
		return self[name .. "Num"]
	else
		return nil
	end
end

function BattleHudLayer:getSoldierNum(soldierName)
	return self.soldierNum
end

function BattleHudLayer:setSelectedSoldierNumGap(gap)
	local soldierName = string.sub(self.SelectItem.__cname, 1, -7)
	local num = self[soldierName .. "Num"]
	if num + gap >= 0 then
		self[soldierName .. "Num"] = num + gap
	else
		self[soldierName .. "Num"] = 0
	end
	self:updateUI()
end

function BattleHudLayer.selectCallback(self, widget)
	local name = widget:getName()
	-- 重置之前选中的按钮
	if self.btnSelected then
		self.btnSelected:setColor(cc.c3b(70, 70, 70))
	end
	self.btnSelected = widget
	widget:setColor(cc.c3b(255, 255, 255))
	if name == "Button0" then
		self.SelectItem = HeroSprite
	elseif name == "Button1" then
		self.SelectItem = FighterSprite
	elseif name == "Button2" then
		self.SelectItem = BowmanSprite
	elseif name == "Button3" then
		self.SelectItem = GunnerSprite
	elseif name == "Button4" then
		self.SelectItem = MeatShieldSprite
	end
end

function BattleHudLayer.retreatCallback(layer, widget)
	-- 停止所有计时器
	local mapLayer = layer:getParent():getChildByTag(TAG_LAYER_BATTLE_MAP)
	GM:stopBattleSchedule(mapLayer)
	GM:showWorldLayer()
end

function BattleHudLayer.skillCallback(widget)
	print(widget:getName())
end

function BattleHudLayer:registerButtons()
	-- 兵种按键
	for i = 0, 4 do
		local widgetName = string.format("Button%d", i)
		local button = ccui.Helper:seekWidgetByName(self, widgetName)
		button:setColor(cc.c3b(70, 70, 70))
		button:addClickEventListener(function ()
			return BattleHudLayer.selectCallback(self, button)
		end)
	end

	-- 撤退按键
	local retreatButton = ccui.Helper:seekWidgetByName(self, "RetreatButton")
	retreatButton:addClickEventListener(function ()
		return BattleHudLayer.retreatCallback(self, retreatButton)
	end)

	-- 技能按键
	for i = 1, 2 do
		local widgetName = string.format("Skill%d", i)
		local button = ccui.Helper:seekWidgetByName(self, widgetName)
		button:addClickEventListener(function ()
			return BattleHudLayer.skillCallback(button)
		end)
	end
end

function BattleHudLayer:updateUI()
	local fighterCount    = ccui.Helper:seekWidgetByName(self, "FighterCount")
	local bowmanCount     = ccui.Helper:seekWidgetByName(self, "BowmanCount")
	local gunnerCount     = ccui.Helper:seekWidgetByName(self, "GunnerCount")
	local meatShieldCount = ccui.Helper:seekWidgetByName(self, "MeatShieldCount")
	fighterCount:setString("x" .. self.FighterNum)
	bowmanCount:setString("x" .. self.BowmanNum)
	gunnerCount:setString("x" .. self.GunnerNum)
	meatShieldCount:setString("x" .. self.MeatShieldNum)
end

local function setSoldierNumTemple(self, prefix)
	local wgCount = ccui.Helper:seekWidgetByName(self, prefix .. "Count")
	local num = GM:getSoldierNum(prefix)
	wgCount:setString("x" .. num)
	self[prefix .. "Num"] = num
end

function BattleHudLayer:setSoldierNum()
	setSoldierNumTemple(self, "Fighter")
	setSoldierNumTemple(self, "Bowman")
	setSoldierNumTemple(self, "Gunner")
	setSoldierNumTemple(self, "MeatShield")
end

function BattleHudLayer:showEnemyInfo()
	local wgLevel = ccui.Helper:seekWidgetByName(self, "Level")
	local EnemyInfo = GM:getEnemyInfo(self.btnEnemy:getName())
	wgLevel:setString(EnemyInfo.level)
	local name = ccui.Helper:seekWidgetByName(self, "Name")
	name:setString(EnemyInfo.name)
	local goldReward = ccui.Helper:seekWidgetByName(self, "GoldReward")
	goldReward:setString(EnemyInfo.reward.Gold)
	local woodReward = ccui.Helper:seekWidgetByName(self, "WoodReward")
	woodReward:setString(EnemyInfo.reward.Wood)
	local ringReward = ccui.Helper:seekWidgetByName(self, "RingReward")
	ringReward:setString(EnemyInfo.reward.Ring)
end

function BattleHudLayer:onEnter()
	self:setSoldierNum()
	self:registerButtons()
	self:showEnemyInfo()
end

function BattleHudLayer:create(btnEnemy)
	local hudLayer = BattleHudLayer.new()

	hudLayer.btnEnemy = btnEnemy
	GM:saveLayer("BattleHudLayer", hudLayer)
	hudLayer:onEnter()

	return hudLayer
end