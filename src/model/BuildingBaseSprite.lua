
BuildingBaseSprite = class("BuildingBaseSprite", function (...)
	return cc.Sprite:create(...)
end)

BuildingBaseSprite.touchListener = nil
BuildingBaseSprite.seekTouchListener = nil
BuildingBaseSprite.type = "Building" -- 指普通建筑，能建立多个
BuildingBaseSprite.hpBar = nil
BuildingBaseSprite.upgradeBar = nil
BuildingBaseSprite.fullHP = nil
BuildingBaseSprite.currentHP = nil
BuildingBaseSprite.isBroken = false
BuildingBaseSprite.target = nil -- 攻击目标
BuildingBaseSprite.scheduleEntry = nil -- 存储定时器标志
BuildingBaseSprite.isSelected = false
BuildingBaseSprite.normalImg = nil
BuildingBaseSprite.tipImg = nil
BuildingBaseSprite.brokenImg = nil
BuildingBaseSprite.moveType = nil
BuildingBaseSprite.level = 1

function BuildingBaseSprite:getLevel()
	local key = string.sub(self.__cname, 1, -7)
	if self.type == "UniqueBuilding" then
		return DM.Player[key].level
	else
		return DM.Player[key .. "s"].level[self.TAG]
	end
end

-- 更新Player中的等级信息，默认加一
function BuildingBaseSprite:setLevel(currentLevel)
	local key = string.sub(self.__cname, 1, -7)
	if self.type == "UniqueBuilding" then
		if currentLevel then
			DM.Player[key].level = currentLevel
		else
			DM.Player[key].level = DM.Player[key].level + 1
		end
	else
		if currentLevel then
			DM.Player[key .. 's'].level[self.TAG] = currentLevel
		else
			DM.Player[key .. 's'].level[self.TAG] = DM.Player[key .. 's'].level[self.TAG] + 1
		end
	end
end

function BuildingBaseSprite:storePos(pos)
	local key = string.sub(self.__cname, 1, -7)
	if self.type == "UniqueBuilding" then
		DM.Player[key].pos = pos
	else
		DM.Player[key .. "s"].pos[self.TAG] = pos
	end
end

function BuildingBaseSprite:getTarget()
	local children = self:getParent():getChildren()
	local minDistance = 999999
	local targetHuman = nil
	local p1 = nil -- 目标的坐标
	local p2 = GM:getNodePosition(self) -- 自身坐标
	local posTmp = {}
	local cIndex = string.sub(self.__cname, 1, -7)
	for i = 1, #children do
		if children[i].type == "Human" and
			children[i].isDeath == false then
			posTmp = GM:getNodePosition(children[i])
			local distance = cc.pGetDistance(posTmp, p2)
			if  distance < minDistance and
				distance < GM:getShootRange(cIndex) then
				minDistance = distance
				targetHuman = children[i]
				p1 = posTmp
			end	
		end
	end
	self.target = targetHuman
end

function BuildingBaseSprite:atk()
	self:getTarget()
	if not self.target then
		return
	end
	local cname = self.__cname
	local damagePS = GM:getDamage(string.sub(self.__cname, 1, -7), self.level)
	local atkTime = GM:getAttackGap(string.sub(self.__cname, 1, -7))
	local bullet = BulletSprite:create(self, self.target, damagePS * atkTime)
	bullet:shoot()
end

function BuildingBaseSprite:selectedAction()
	local scaleUp   = cc.ScaleBy:create(0.1, 1.1)
	local scaleDown = cc.ScaleTo:create(0.1, 1)
	local moveUp    = cc.MoveBy:create(0.1, cc.p(0, 3))
	local moveDown  = cc.MoveBy:create(0.1, cc.p(0, -3))
	local tintIn    = cc.TintTo:create(1, 160, 160, 160)
	local tintOut   = cc.TintTo:create(1, 255, 255, 255)

	local seq1 = cc.Sequence:create(scaleUp, scaleDown)
	local seq2 = cc.Sequence:create(moveUp, moveDown)
	local seq3 = cc.Sequence:create(tintIn, tintOut)
	local rep  = cc.RepeatForever:create(seq3)

	self.normalImg:runAction(seq1)
	self.normalImg:runAction(seq2)
	self.normalImg:runAction(rep)
end 

function BuildingBaseSprite:unselectedAction()
	self.isSelected = false
	self.tipImg:setOpacity(0)
	self.normalImg:stopAllActions()
	self.normalImg:setScale(1)
	self.normalImg:setColor(cc.c3b(255, 255, 255))
end

function BuildingBaseSprite.touchBegan(touch, event)
	local node = event:getCurrentTarget()
	if GM:beTouched(touch, event) then
		return true
	else
		-- 取消选中
		if node.isSelected then
			node:unselectedAction()
			GM:closeDialogLayer()
		end
		return false	
	end
end

function BuildingBaseSprite.touchMoved(touch, event)
	local node = event:getCurrentTarget()
	if node.isSelected then
		node.moveType = "moveSelf"
		GM:moveFollowsSlide(touch, event)
	else
		node.moveType = "moveLayer"
		GM:moveFollowsSlide(touch, event, true)
	end
end

function BuildingBaseSprite.touchEnded(touch, event)
	local node = event:getCurrentTarget()
	if node.moveType == "moveLayer" then
		-- 如果是要移动Layer则直接返回
		node.moveType = nil -- 不一定进touchMoved函数,所以这里要初始化
		return
	end
	-- 第一次被选中
	if not node.isSelected then
		-- 取消别的建筑的选中
		local children = node:getParent():getChildren()
		for i = 1, #children do
			if children[i].isSelected == true then
				children[i]:unselectedAction()
			end
		end
		node.isSelected = true
		node.tipImg:setOpacity(255)
		node:selectedAction()	
		-- 显示BuildingOptDialogLayer
		GM:closeDialogLayer()
		GM:showDialogLayer(BuildingOptDialogLayer, node)
	end

	node:runAction(cc.ScaleTo:create(0.06, 1))
	local cname = node.__cname
	local infoName = string.sub(cname, 1, -7)
	node:storePos(GM:getNodePosition(node))
end

function BuildingBaseSprite:addTouchListener()
	local touchListener = cc.EventListenerTouchOneByOne:create()
	self.touchListener = touchListener
	touchListener:setSwallowTouches(true)
	touchListener:registerScriptHandler(BuildingBaseSprite.touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	touchListener:registerScriptHandler(BuildingBaseSprite.touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	touchListener:registerScriptHandler(BuildingBaseSprite.touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, self)
end

function BuildingBaseSprite:removeEventListener()
	eventDispatcher:removeEventListener(self.touchListener)
end




function BuildingBaseSprite:seekSelectedAction()
	local name = string.sub(self.__cname, 1, -7)
	local text = nil
	if self.subType == "ATKBuilding" then
		text = string.format("%s Lv.%d\n  生命值 %d\n每秒伤害 %d", 
					GM:getName(name), self.level, GM:getHP(name, self.level), GM:getDamage(name, self.level))
	else
		text = string.format("%s Lv.%d\n  生命值 %d\n", 
					GM:getName(name), self.level, GM:getHP(name, self.level))
	end
	local label = cc.LabelTTF:create(text, "微软雅黑", 16)
	--label:setColor(cc.c3b(200, 100, 100))
	--label:enableShadow(cc.c4b(0, 0, 0, 255))  ??
	label:setPosition(self:getContentSize().width / 2, self:getContentSize().height)
	self:addChild(label, ORD_TOP, "Info")
	self.isSelected = true
	local moveUp    = cc.MoveBy:create(0.1, cc.p(0, 3))
	local moveDown  = cc.MoveBy:create(0.1, cc.p(0, -3))
	local scaleUp   = cc.ScaleBy:create(0.1, 1.1)
	local scaleDown = cc.ScaleTo:create(0.1, 1)
	local tintIn    = cc.TintTo:create(1, 160, 160, 160)
	local tintOut   = cc.TintTo:create(1, 255, 255, 255)

	local seqMove   = cc.Sequence:create(moveUp, moveDown)
	local seqScale  = cc.Sequence:create(scaleUp, scaleDown)
	local seqTint   = cc.Sequence:create(tintIn, tintOut)
	local repTint   = cc.RepeatForever:create(seqTint)
	self.normalImg:runAction(seqMove)
	self.normalImg:runAction(seqScale)
	self.normalImg:runAction(repTint)
end

function BuildingBaseSprite:seekUnselectedAction()
	self.isSelected = false
	self.normalImg:stopAllActions()
	self.normalImg:setColor(cc.c3b(255, 255, 255))
	self.normalImg:setScale(1)
	self:getChildByName("Info"):removeFromParent()
end

function BuildingBaseSprite.seekTouchBegan(touch, event)
	local node = event:getCurrentTarget()
	node.moveType = nil
	if GM:beTouched(touch, event) then
		return true
	else
		-- 取消选中
		if node.isSelected then
			node:seekUnselectedAction()
		end
		return false	
	end
end

function BuildingBaseSprite.seekTouchMoved(touch, event)
	local node = event:getCurrentTarget()
	node.moveType = "moveLayer"
	GM:moveFollowsSlide(touch, event, true)
end

function BuildingBaseSprite.seekTouchEnded(touch, event)
	local node = event:getCurrentTarget()
	if node.moveType == "moveLayer" then
		-- 如果是要移动Layer则直接返回
		node.moveType = nil -- 不一定进touchMoved函数,所以这里要初始化
		return
	end

	-- 第一次被选中
	if not node.isSelected then
		-- 取消别的建筑的选中
		local children = node:getParent():getChildren()
		for i = 1, #children do
			if children[i].isSelected == true then
				children[i]:seekUnselectedAction()
			end
		end
		node.isSelected = true
		node:seekSelectedAction()
	end
end

function BuildingBaseSprite:addSeekTouchListener()
	local seekTouchListener = cc.EventListenerTouchOneByOne:create()
	self.seekTouchListener = seekTouchListener
	seekTouchListener:setSwallowTouches(true)
	seekTouchListener:registerScriptHandler(BuildingBaseSprite.seekTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	seekTouchListener:registerScriptHandler(BuildingBaseSprite.seekTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	seekTouchListener:registerScriptHandler(BuildingBaseSprite.seekTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	eventDispatcher:addEventListenerWithSceneGraphPriority(seekTouchListener, self)
end

function BuildingBaseSprite:addHPBar()
	local bg = cc.Sprite:create(IMG_BUILD_PRO_BK)
	local hpBar = ccui.LoadingBar:create(IMG_BUILD_PRO_ENEMY, 100)
	local contentSize = self:getContentSize()
	hpBar:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
	bg:addChild(hpBar)
	bg:setPosition(contentSize.width / 2, contentSize.height)
	bg:setVisible(false)
	self:addChild(bg, ORD_MIDDLE, TAG_BUILD_BAR)
	self.hpBar = hpBar
end

function BuildingBaseSprite:addUpgradeBar()
	local bg = cc.Sprite:create(IMG_BUILD_PRO_BK)
	local upgradeBar = ccui.LoadingBar:create(IMG_BUILD_PRO, 0)
	local contentSize = self:getContentSize()
	upgradeBar:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
	bg:addChild(upgradeBar, ORD_TOP, "Bar")
	bg:setPosition(contentSize.width / 2, contentSize.height)
	bg:setVisible(false)
	self:addChild(bg, ORD_TOP, "UpgradeBarBg")
	self.upgradeBar = upgradeBar
end

function BuildingBaseSprite:adjustBarPosition(x, y)
	local hpBarBg = self.hpBar:getParent()
	local upgradeBarBg = self.upgradeBar:getParent()
	local baseX, baseY = hpBarBg:getPosition()
	hpBarBg:setPosition(baseX + x, baseY + y)
	upgradeBarBg:setPosition(baseX + x, baseY + y)
end

function BuildingBaseSprite:removeHPBar()
	local bg = self.hpBar:getParent()

	bg:setVisible(false)
end

function BuildingBaseSprite:broken()
	-- 停止定时器,不再攻击
	if self.scheduleEntry then
		scheduler:unscheduleScriptEntry(self.scheduleEntry)
	end
	self.hpBar:getParent():setVisible(false)
	-- 通知以自己为目标在跑过来路上的Human
	local children = self:getParent():getChildren()
	for i = 1, #children do
		if	children[i].type == "Human" and
			children[i].state == "running" and
			children[i].target == self then
			children[i]:run()
		end
	end
	
	self.normalImg:setVisible(false)
	self.brokenImg:setOpacity(255)
	-- 如果是主基地，则宣布战斗胜利
	if self.__cname == "BaseTowerSprite" and
		self.isBroken == false then
		local emenyName = self:getParent().btnEnemy:getName()
		GM:getLayer("BattleHudLayer"):setVisible(false)
		GM:stopBattleSchedule(self:getParent())
		GM:showDialogLayer(GameOverDialogLayer, "Win", emenyName)
	end	
	self.isBroken = true
end

function BuildingBaseSprite:hurt(damage)
	self.currentHP = self.currentHP - damage
	self.hpBar:getParent():setVisible(true)
	if self.currentHP <= 0 then
		self.hpBar:setPercent(0)
		self:broken()
	else
		self.hpBar:setPercent(self.currentHP / self.fullHP * 100)
	end
end

function BuildingBaseSprite:startSearching()
	local atkTime = GM:getAttackGap(string.sub(self.__cname, 1, -7))
	local function callATK()
		-- 如果自身被毁，则停止搜索目标schedule
		if self.isBroken then
			if self.scheduleEntry then
				scheduler:unscheduleScriptEntry(self.scheduleEntry)
				self.scheduleEntry = nil
			end
			return
		end
		self:atk()
	end
	self.scheduleEntry = scheduler:scheduleScriptFunc(callATK, atkTime, false)
end

function BuildingBaseSprite:addUI(normalPath)
	local size = self:getContentSize()
	self.normalImg = cc.Sprite:create(normalPath)
	self.tipImg = cc.Sprite:create(IMG_BUILDING_ARROWTIP)
	local brokenPath = string.sub(normalPath, 1, -5) .. "_broken.png"
	self.brokenImg = cc.Sprite:create(brokenPath)

	self.normalImg:setPosition(size.width / 2, size.height / 2)
	self.tipImg:setPosition(size.width / 2, size.height / 2)
	self.brokenImg:setPosition(size.width / 2, size.height / 2)
	self.brokenImg:setColor(cc.c3b(130, 130, 130))
	self.brokenImg:setOpacity(0)
	self.tipImg:setOpacity(0)

	self:addChild(self.normalImg)
	self:addChild(self.brokenImg)
	self:addChild(self.tipImg)	
end

function BuildingBaseSprite:onEnter(...)
	self:addUI(...)
	self:addTouchListener()
	self:addHPBar()
	self:addUpgradeBar()
end

function BuildingBaseSprite:create(...)
	local sprite = BuildingBaseSprite.new()
	sprite:setContentSize(90, 90)

	sprite:onEnter(...)

	return sprite
end
