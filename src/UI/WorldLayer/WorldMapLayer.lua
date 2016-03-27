
WorldMapLayer = class("WorldMapLayer", function (...)
	return cc.Layer:create(...)
end)

WorldMapLayer.touchListener = nil
WorldMapLayer.touchType = nil

local function enterHome()
	GlobalManager:showHomeLayer()
end

function WorldMapLayer.eventListenerCallback(button)
	local name = button:getName()
	TownDialogLayer:create(button)
end

function WorldMapLayer.touchBegan(self, touch, event)
	self.touchType = nil
    return true
end

function WorldMapLayer.touchMoved(self, touch, event)
	self.touchType = "TouchMoved"
	GM:moveFollowsSlide(touch, event, false, cc.size(2000, 2000))
end

function WorldMapLayer.touchEnded(self, touch, event)
	if self.touchType ~= "TouchMoved" then
		if scene.dialogLayer then
			scene.dialogLayer:removeFromParent()
			scene.dialogLayer = nil
		end
	end
end

function WorldMapLayer:addTouchListener()
	
	self.touchListener = cc.EventListenerTouchOneByOne:create()
	self.touchListener:setSwallowTouches(true)
	self.touchListener:registerScriptHandler(function(...)
		return WorldMapLayer.touchBegan(self, ...)
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	self.touchListener:registerScriptHandler(function(...)
		return WorldMapLayer.touchMoved(self, ...)
	end, cc.Handler.EVENT_TOUCH_MOVED)
	self.touchListener:registerScriptHandler(function (...)
		return WorldMapLayer.touchEnded(self, ...)
	end, cc.Handler.EVENT_TOUCH_ENDED)
	
	eventDispatcher:addEventListenerWithSceneGraphPriority(self.touchListener, self)
end

function WorldMapLayer:removeTouchListener()
	eventDispatcher:removeEventListener(self.touchListener)
end

function WorldMapLayer:onEnter()
	local homePos = cc.p(size.width / 2, 280)
	local bg = cc.Sprite:create(IMG_WORLD_BG)
	bg:setPosition(size.width / 2, size.height / 2)
	local btnTownHome = ccui.Button:create(IMG_TOWN_HOME)
	btnTownHome:addClickEventListener(function ()
		return WorldMapLayer.eventListenerCallback(btnTownHome)
	end)
	btnTownHome:setName("TownHome")
	btnTownHome:setPosition(homePos)
	btnTownHome:setScale(0.7)
	self:addChild(bg)
	self:addChild(btnTownHome)

	local btnTownChapter1 = ccui.Button:create(IMG_TOWN_CHAPTER)
	btnTownChapter1:setName("Enemy01")
	btnTownChapter1:setPosition(homePos.x + 300, homePos.y + 60)
	btnTownChapter1:addClickEventListener(function ()
			return WorldMapLayer.eventListenerCallback(btnTownChapter1)
		end)
	self:addChild(btnTownChapter1)
	local btnTownChapter2 = ccui.Button:create(IMG_TOWN_CHAPTER)
	btnTownChapter2:setName("Enemy02")
	btnTownChapter2:setPosition(homePos.x + 30, homePos.y + 230)
	btnTownChapter2:addClickEventListener(function ()
			return WorldMapLayer.eventListenerCallback(btnTownChapter2)
		end)
	self:addChild(btnTownChapter2)
	local btnTownChapter3 = ccui.Button:create(IMG_TOWN_CHAPTER)
	btnTownChapter3:setName("Enemy03")
	btnTownChapter3:setPosition(homePos.x - 330, homePos.y - 30)
	btnTownChapter3:addClickEventListener(function ()
			return WorldMapLayer.eventListenerCallback(btnTownChapter3)
		end)
	self:addChild(btnTownChapter3)

	self:addTouchListener()
end

function WorldMapLayer:create()
	local mapLayer = WorldMapLayer.new()
	
	mapLayer:onEnter()

	DM.Layer.WorldMapLayer = mapLayer
	return mapLayer
end