
BattleSeekLayer = class("BattleSeekLayer", function ( ... )
	return cc.Layer:create(...)
end)

BattleSeekLayer.touchType = nil
BattleSeekLayer.effectNode = nil
BattleSeekLayer.btnEnemy = nil

function BattleSeekLayer.touchBegan(self, touch, event)
	self.touchType = "addAttacker"
    return true
end

function BattleSeekLayer.touchMoved(self, touch, event)
	self.touchType = "moveMap"
	GM:moveFollowsSlide(touch, event)
end

function BattleSeekLayer.touchEnded(self, touch, event)
	if self.touchType == "moveMap" then
		return
	end
	local node = event:getCurrentTarget()
	local touchPoint = touch:getLocation() -- 获取的是世界坐标
	local layX, layY = self:getPosition()
	if not DM.BattleLayer.SelectItem then
		return
	end
	local item = DM.BattleLayer.SelectItem:create()
	item:setPosition(touchPoint.x - layX, touchPoint.y - layY)
	self:addChild(item, ORD_BOTTOM)
	item:run() -- 需要先加为BattleSeekLayer的子节点才能调用
end

function BattleSeekLayer:addTouchListener()
	local touchListener = cc.EventListenerTouchOneByOne:create()
	touchListener:setSwallowTouches(true)
	touchListener:registerScriptHandler(function(...)
		return BattleSeekLayer.touchBegan(self, ...)
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	touchListener:registerScriptHandler(function(...)
		return BattleSeekLayer.touchMoved(self, ...)
	end, cc.Handler.EVENT_TOUCH_MOVED)
	touchListener:registerScriptHandler(function (...)
		return BattleSeekLayer.touchEnded(self, ...)
	end, cc.Handler.EVENT_TOUCH_ENDED)
	eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, self)
end

function BattleSeekLayer:addBuildings()
	local enemyName = self.btnEnemy:getName()
	local EnemyInfo = GM:getEnemyInfo(enemyName)
	for name, info in pairs(EnemyInfo) do
		local type = string.sub(name, 1, 2)
		local buildingName = nil
		if type == "UB" then
			buildingName = string.sub(name, 4, -1)
		elseif type == "MB" then
			buildingName = string.sub(name, 4, -3)
		else
			goto label
		end
		local buildingClass = GM:getClass(buildingName)
		local sprite = buildingClass:create()
		sprite:setPosition(info.pos)
		sprite:initBuildingHP(info.level)
		sprite:removeEventListener()
		sprite:addSeekTouchListener()
		self:addChild(sprite, ORD_BOTTOM)
		::label::
	end
end

function BattleSeekLayer:addHudLayer()
	local hudLayer = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_LAYER_BATTLEHUD)
	scene:addChild(hudLayer, ORD_TOP, "BattleHudLayer")
	for i = 0, 4 do
		ccui.Helper:seekWidgetByName(hudLayer, "Button" .. i):setVisible(false)
	end
	for i = 1, 2 do
		ccui.Helper:seekWidgetByName(hudLayer, "Skill" .. i):setVisible(false)
	end
	local EnemyInfo = GM:getEnemyInfo(self.btnEnemy:getName())
	local retreatButton = ccui.Helper:seekWidgetByName(hudLayer, "RetreatButton")
	retreatButton:setTitleText("返回")
	retreatButton:addClickEventListener(function ()
		hudLayer:removeFromParent()
		GM:showWorldLayer()
	end)
	local wgLevel = ccui.Helper:seekWidgetByName(hudLayer, "Level")
	wgLevel:setString(EnemyInfo.level)
	local name = ccui.Helper:seekWidgetByName(hudLayer, "Name")
	name:setString(EnemyInfo.name)
	local goldReward = ccui.Helper:seekWidgetByName(hudLayer, "GoldReward")
	goldReward:setString(EnemyInfo.reward.Gold)
	local woodReward = ccui.Helper:seekWidgetByName(hudLayer, "WoodReward")
	woodReward:setString(EnemyInfo.reward.Wood)
	local ringReward = ccui.Helper:seekWidgetByName(hudLayer, "RingReward")
	ringReward:setString(EnemyInfo.reward.Ring)

end

function BattleSeekLayer:onEnter()
	local bg = cc.Sprite:create(IMG_HOME_BG)
	bg:setPosition(size.width / 2, size.height / 2)
	self:addChild(bg, ORD_BOTTOM - 1)
	self:addHudLayer()
	self:addBuildings()
	self:addTouchListener()
end

function BattleSeekLayer:create(btnEnemy)
	local seekLayer = BattleSeekLayer.new()

	seekLayer.btnEnemy = btnEnemy
	seekLayer:onEnter()

	return seekLayer
end
