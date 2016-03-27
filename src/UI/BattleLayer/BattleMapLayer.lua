
BattleMapLayer = class("BattleMapLayer", function ( ... )
	return cc.Layer:create(...)
end)

BattleMapLayer.touchType = nil
BattleMapLayer.btnEnemy = nil
BattleMapLayer.effectNode = nil
BattleMapLayer.FighterNum    = 0
BattleMapLayer.BowmanNum     = 0
BattleMapLayer.GunnerNum     = 0
BattleMapLayer.MeatShieldNum = 0
BattleMapLayer.HeroNum       = 0

function BattleMapLayer:setSelectedSoldierNumGap(gap)
	local soldierName = string.sub(GM:getLayer("BattleHudLayer").SelectItem.__cname, 1, -7)
	local num = self[soldierName .. "Num"]
	if num + gap >= 0 then
		self[soldierName .. "Num"] = num + gap
	else
		self[soldierName .. "Num"] = 0
	end
end

function BattleMapLayer:getSelectedSoldierNum()
	local soldierName = string.sub(GM:getLayer("BattleHudLayer").SelectItem.__cname, 1, -7)
	return self[soldierName .. "Num"]
end

function BattleMapLayer.touchBegan(self, touch, event)
	self.touchType = "addAttacker"
    return true
end

function BattleMapLayer.touchMoved(self, touch, event)
	self.touchType = "moveMap"
	GM:moveFollowsSlide(touch, event)
end

function BattleMapLayer.touchEnded(self, touch, event)
	if self.touchType == "moveMap" then
		return
	end
	local battleHudLayer = GM:getLayer("BattleHudLayer")
	local node = event:getCurrentTarget()
	local touchPoint = touch:getLocation() -- 获取的是世界坐标
	local layX, layY = self:getPosition()
	if not battleHudLayer.SelectItem then
		return
	end
	local soldierHudNum = battleHudLayer:getSelectedSoldierNum()
	if soldierHudNum <= 0 then
		return
	end
	-- 增加Map上的士兵，减少Hud上的士兵
	self:setSelectedSoldierNumGap(1)
	battleHudLayer:setSelectedSoldierNumGap(-1)
	local item = battleHudLayer.SelectItem:create()
	item:setPosition(touchPoint.x - layX, touchPoint.y - layY)
	self:addChild(item, ORD_BOTTOM)
	item:run() -- 需要先加为BattleMapLayer的子节点才能调用
end

function BattleMapLayer:addTouchListener()
	local touchListener = cc.EventListenerTouchOneByOne:create()
	touchListener:setSwallowTouches(true)
	touchListener:registerScriptHandler(function(...)
		return BattleMapLayer.touchBegan(self, ...)
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	touchListener:registerScriptHandler(function(...)
		return BattleMapLayer.touchMoved(self, ...)
	end, cc.Handler.EVENT_TOUCH_MOVED)
	touchListener:registerScriptHandler(function (...)
		return BattleMapLayer.touchEnded(self, ...)
	end, cc.Handler.EVENT_TOUCH_ENDED)
	eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, self)
end

function BattleMapLayer:addBuildings()
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
		self:addChild(sprite, ORD_BOTTOM)
		::label::
	end
end

function BattleMapLayer:buildingStartATK()
	local children = self:getChildren()
	for i = 1, #children do
		if children[i].subType == "ATKBuilding" then
			children[i]:startSearching()
		end
	end
end

function BattleMapLayer:onEnter()
	local bg = cc.Sprite:create(IMG_HOME_BG)
	bg:setPosition(size.width / 2, size.height / 2)
	self:addChild(bg, ORD_BOTTOM - 1)
	
	self:addBuildings()
	
	self:addTouchListener()
	
	self.effectNode = cc.Node:create()
	self:addChild(self.effectNode)
	self:buildingStartATK()
end

function BattleMapLayer:create(btnEnemy)
	local mapLayer = BattleMapLayer.new()

	GM:saveLayer("BattleMapLayer", mapLayer)
	mapLayer.btnEnemy = btnEnemy
	mapLayer:onEnter()

	return mapLayer
end
