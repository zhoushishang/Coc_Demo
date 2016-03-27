
HomeMapLayer = class("HomeMapLayer", function (...)
	return cc.Layer:create(...)
end)

HomeMapLayer.PRIORITY_BUILDIND = 10
HomeMapLayer.touchListener = nil

function HomeMapLayer.touchBegan(self, touch, event)
    return true
end

function HomeMapLayer.touchMoved(self, touch, event)
	GM:moveFollowsSlide(touch, event)
end

function HomeMapLayer.touchEnded(self, touch, event)
	
end

function HomeMapLayer:addTouchListener()
	self.touchListener = cc.EventListenerTouchOneByOne:create()
	self.touchListener:setSwallowTouches(true)
	self.touchListener:registerScriptHandler(function(...)
		return HomeMapLayer.touchBegan(self, ...)
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	self.touchListener:registerScriptHandler(function(...)
		return HomeMapLayer.touchMoved(self, ...)
	end, cc.Handler.EVENT_TOUCH_MOVED)
	self.touchListener:registerScriptHandler(function (...)
		return HomeMapLayer.touchEnded(self, ...)
	end, cc.Handler.EVENT_TOUCH_ENDED)
	
	eventDispatcher:addEventListenerWithSceneGraphPriority(self.touchListener, self)
end

function HomeMapLayer:removeTouchListener()
	eventDispatcher:removeEventListener(self.touchListener)
end

local function addBuildingTemple(class, layer, prefix)
	local buildingNum = #DM.Player[prefix .. "s"].level
	if buildingNum ~= 0 then 
		for i = 1, buildingNum do
			local pos = DM.Player[prefix .. "s"].pos[i]
			local level = DM.Player[prefix .. "s"].level[i]
			local buildingSprite = class:create()
			buildingSprite:setPosition(pos)
			buildingSprite:removeHPBar()
			buildingSprite.TAG = i
			buildingSprite.level = level
			layer:addChild(buildingSprite, HomeMapLayer.PRIORITY_BUILDIND)
		end
	end
end

function HomeMapLayer:addBuildings()
	-- 添加新建的建筑
	-- add MineFactorys
	addBuildingTemple(MineFactorySprite, self, "MineFactory")
	-- add WoodFactorys
	addBuildingTemple(WoodFactorySprite, self, "WoodFactory")
	-- add ArrowTowers
	addBuildingTemple(ArrowTowerSprite, self, "ArrowTower")
	-- add Cannons
	addBuildingTemple(CannonSprite, self, "Cannon")
	-- add Lasers
	addBuildingTemple(LaserSprite, self, "Laser")
end

local function addTowerTemple(class, pos, layer, prefix)
	local towerSprite = class:create()
	local savedPos = DM.Player[prefix].pos
	local towerLevel = DM.Player[prefix].level
	if towerLevel then
		towerSprite.level = towerLevel
	end
	if savedPos then
		towerSprite:setPosition(savedPos)
	else
		towerSprite:setPosition(pos)
		DM.Player[prefix].pos = pos
	end
	towerSprite:removeHPBar()
	layer:addChild(towerSprite, HomeMapLayer.PRIORITY_BUILDIND)
end

function HomeMapLayer:addTowers()
	-- 添加固定的建筑
	local stdPos = cc.p(size.width / 8, size.height * 2 / 3)
	local gap = 80
	local ratio = 1.35
	-- add BaseTower
	local pos = cc.p(size.width / 2, size.height / 2)
	addTowerTemple(BaseTowerSprite, pos, self, "BaseTower")
	-- add Camp
	pos = cc.p(stdPos.x + gap*ratio, stdPos.y - gap)
	addTowerTemple(CampSprite, pos, self, "Camp")
	-- add HeroHotel
	pos = cc.p(stdPos.x + 2*gap*ratio, stdPos.y + 10)
	addTowerTemple(HeroHotelSprite, pos, self, "HeroHotel")
	-- add Raider
	pos = stdPos
	addTowerTemple(RaiderSprite, pos, self, "Raider")
	-- add ResearchLab
	pos = cc.p(stdPos.x + gap*ratio, stdPos.y + gap)
	addTowerTemple(ResearchLabSprite, pos, self, "ResearchLab")
end

function HomeMapLayer:addNPCs()
	-- add Hero
	local heroSprite = HeroSprite:create()
	heroSprite:setPosition(size.width / 2, size.height / 3)
	heroSprite:setScale(0.7)
	self:addChild(heroSprite, HomeMapLayer.PRIORITY_BUILDIND)
end

function HomeMapLayer:onEnter()
	local bg = cc.Sprite:create(IMG_HOME_BG)
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(size.width / 2, size.height / 2)
	self:addChild(bg)

	self:addTouchListener()
	self:addTowers()
	--self:addNPCs()
	self:addBuildings()		
end

function HomeMapLayer:create()
	local layer = HomeMapLayer.new()

	layer:onEnter()

	DM.Layer.HomeMapLayer = layer
	return layer
end