
HomeHudLayer = class("HomeHudLayer", function ()
	return ccs.GUIReader:getInstance():widgetFromJsonFile(UI_LAYER_HOMEHUD)
end)

function HomeHudLayer:eventClickCallback(widget)
	local name = widget:getName()
	if name == "WorldButton" then
		GlobalManager:showWorldLayer()
	elseif name == "BuildButton" then
		-- 先关闭别的对话窗口，及重置建筑选中状态
		GM:resetSelectedState()
		GM:closeDialogLayer()
		GM:showDialogLayer(NewBuildDialogLayer)
	end
end

function HomeHudLayer:showPlayerName()
	local name = DM.Player.name
	if name then
		local playerName = ccui.Helper:seekWidgetByName(self, "PlayerName")
    	playerName:setString(name)
    	playerName:enableShadow(cc.c4b(0, 0, 0, 255))
    end
end

function HomeHudLayer:showEXP()
	local playerBar  = ccui.Helper:seekWidgetByName(self, "PlayerBar")
	local playerLevel = ccui.Helper:seekWidgetByName(self, "PlayerLevel")
	local level = GM:getLevel("Player")
	local currentEXP  = GM:getPlayerCurrentEXP()
	local capacityEXP = GM:getPlayerEXPLimit()
	playerBar:setPercent(currentEXP / capacityEXP * 100)
	playerLevel:setString(level)
end

function HomeHudLayer:showRing()
	local ringCount = ccui.Helper:seekWidgetByName(self, "RingCount")
	ringCount:setString(DM.Player.ringCount)
end

function HomeHudLayer:showGold()
	local goldCount = ccui.Helper:seekWidgetByName(self, "GoldCount")
    local goldBar = ccui.Helper:seekWidgetByName(self, "GoldBar")
    local goldCapacity = ccui.Helper:seekWidgetByName(self, "GoldCapacity")
    local sum = GM:getGoldCount()
    local baseLevel = baseTowerSprite.level
	local capacity  = DM.BaseTowerInfo.MineCapacity[baseLevel]
    goldCount:setString(sum)
	goldBar:setPercent(100 * sum / capacity)
	goldCapacity:setString(capacity)
end

function HomeHudLayer:showWood()
	local woodCount = ccui.Helper:seekWidgetByName(self, "WoodCount")
    local woodBar = ccui.Helper:seekWidgetByName(self, "WoodBar")
    local woodCapacity = ccui.Helper:seekWidgetByName(self, "WoodCapacity")
    local sum = DM.Resource.woodCount
    local baseLevel = baseTowerSprite.level
	local capacity  = DM.BaseTowerInfo.MineCapacity[baseLevel]
    woodCount:setString(sum)
	woodBar:setPercent(100 * sum / capacity)
	woodCapacity:setString(capacity)
end

function HomeHudLayer:addTouchListener()
	local btnWorld = ccui.Helper:seekWidgetByName(self, "WorldButton")
	local btnBuild = ccui.Helper:seekWidgetByName(self, "BuildButton")
	btnWorld:addClickEventListener(function ()
		return self:eventClickCallback(btnWorld)
	end)
	btnBuild:addClickEventListener(function ()
		return self:eventClickCallback(btnBuild)
	end)
end

function HomeHudLayer:initData()
	self:showPlayerName()	
	self:showEXP()
	self:showGold()
	self:showWood()
	self:showRing()
end

function HomeHudLayer:onEnter()
	self:addTouchListener()
	self:initData()
end

function HomeHudLayer:create()
	local homeHudLayer = HomeHudLayer.new()
	
	homeHudLayer:onEnter()
	DM.Layer.HomeHudLayer = homeHudLayer

	return homeHudLayer
end
