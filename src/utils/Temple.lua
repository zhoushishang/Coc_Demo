
Temple = {}

function Temple:newBuilding_AddTouchListenerTemple(class, prefix)
	-- 新建建筑的addEventListener模板
	class.type = "Building"
	class.eventListener = nil
	function class.touchBegan(touch, event)
		--print "class:touchBegan()"
		local node = event:getCurrentTarget()
	    if GM:beTouched(touch, event) then
	    	node:runAction(cc.ScaleBy:create(0.06, 1.06))
	    	return true
	    else
	    	return false
	    end
	end

	function class:removeEventListener()
		eventDispatcher:removeEventListener(self.eventListener)
	end

	function class.touchMoved(touch, event)
		--print "class:touchMoved()"
		GM:moveFollowsSlide(touch, event)
	end

	function class.touchEnded(self, touch, event)
		--print "class:touchEnded()
		local node = event:getCurrentTarget()
		node:runAction(cc.ScaleTo:create(0.06, 1))
		local towerName = string.format("%s%d", prefix, self.TAG)
		--print("ArrowTower TAG: ", self.TAG)
		DM.HomeLayerInfo[prefix .. "s"][towerName].position = GM:getNodePosition(node)
	end

	function class:addEventListener()
		local touchListener = cc.EventListenerTouchOneByOne:create()
		touchListener:setSwallowTouches(true)
		touchListener:registerScriptHandler(class.touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
		touchListener:registerScriptHandler(class.touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
		touchListener:registerScriptHandler(function(...)
				return class.touchEnded(self, ...)
			end, cc.Handler.EVENT_TOUCH_ENDED)
		eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, self)
		self.eventListener = touchListener
	end
end

function Temple:initBuildingHP(class)
	function class:initBuildingHP(level)  -- 只有EnemyBuilding才需要初始化
		local key = string.sub(self.__cname, 1, -7)
		self.level = level
		self.fullHP = DM[key .. "Info"].healthPoint[level]
		self.currentHP = DM[key .. "Info"].healthPoint[level]
	end
end
