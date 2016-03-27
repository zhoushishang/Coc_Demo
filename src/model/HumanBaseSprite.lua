
HumanBaseSprite = class("HumanBaseSprite", function(...)
	return cc.Sprite:create(...)
end)

HumanBaseSprite.type = "Human"
HumanBaseSprite.anim = {}
HumanBaseSprite.currentAnimNum = nil
HumanBaseSprite.target = nil -- 攻击目标
HumanBaseSprite.scheduleEntry = nil -- 存储定时器标志
HumanBaseSprite.state = nil
HumanBaseSprite.isDeath = false
HumanBaseSprite.bar = nil
HumanBaseSprite.fullHP = nil
HumanBaseSprite.currentHP = nil

function HumanBaseSprite:atk()
	--print("Base atk")
	self.state = "attacking"
	self.anim:getAnimation():play("atk" .. self.currentAnimNum)
	local cname = self.__cname
	local soldierName = string.sub(self.__cname, 1, -7)
	local damagePS = GM:getDamage(soldierName, GM:getLevel(soldierName))
	local atkTime = GM:getAttackGap(soldierName)
	if cname == "BowmanSprite" or cname == "GunnerSprite" then
		local function loopShoot()
			-- 角色死亡或者目标被摧毁则注销发射子弹schedule
			if self.isDeath then
				if self.scheduleEntry then
					scheduler:unscheduleScriptEntry(self.scheduleEntry)
					self.scheduleEntry = nil
				end
				return
			end
			if self.target.isBroken then
				if self.scheduleEntry then
					scheduler:unscheduleScriptEntry(self.scheduleEntry)
					self.scheduleEntry = nil
				end
				self:run()
			else
				local bullet = BulletSprite:create(self, self.target, damagePS * atkTime)
				bullet:shoot()
			end
		end 
		-- 注册发射子弹schedule
		self.scheduleEntry = scheduler:scheduleScriptFunc(loopShoot, atkTime, false)		
	else
		local function loopAttacking()
			if self.isDeath then
				if self.scheduleEntry then
					scheduler:unscheduleScriptEntry(self.scheduleEntry)
					self.scheduleEntry = nil
				end
				return
			end
			if self.target.isBroken then
				if self.scheduleEntry then
					scheduler:unscheduleScriptEntry(self.scheduleEntry)
					self.scheduleEntry = nil
				end
				self:run()
			else
				self.target:hurt(damagePS * atkTime)
			end
		end
		self.scheduleEntry = scheduler:scheduleScriptFunc(loopAttacking, atkTime, false)
	end
end

function HumanBaseSprite:run( ... )
	-- 如果当前是running状态，则停下当前动作，重新计算目标
	if self.state == "running" then
		self.target = nil
		self:stopAllActions()
	end
	self.state = "running"
	-- 决定目标
	local children = self:getParent():getChildren()
	local minDistance = 999999
	local targetBuilding = nil
	local p1 = nil -- 目标的坐标
	local p2 = GM:getNodePosition(self) -- 自身坐标
	for i = 1, #children do
		local tagPos = nil
		if (children[i].type == "Building" or 
			children[i].type == "UniqueBuilding") and
			children[i].isBroken == false then
			tagPos = GM:getNodePosition(children[i])
			local distance = cc.pGetDistance(tagPos, p2)
			if distance < minDistance then
				minDistance = distance
				targetBuilding = children[i]
				p1 = tagPos
			end	
		end
	end
	-- 是否全灭地方建筑
	if targetBuilding == nil then
		--print("Broke all")
		if self.__cname == "HeroSprite" then
			self.anim:getAnimation():play("idle" .. self.currentAnimNum)
		else
			self.anim:getAnimation():stop()
		end
		return
	end
	self.target = targetBuilding
	-- 计算目标指向自身的向量
	local vec = cc.pSub(p2, p1)
	-- 获得对应的动作编号
	local num = GM:getAnimNum(vec)
	self.currentAnimNum = num
	self.anim:getAnimation():play("run" .. num)
	-- 决定要到达的地点，所到达地点为据目标建筑中心stdSize/sqrt(2)处
	local ATKDistance = GM:getShootRange(string.sub(self.__cname, 1, -7))
	if minDistance < ATKDistance + DM.BuildingInfo.stdSize/2 then
		local delay = cc.DelayTime:create(0.7)
		local acf = cc.CallFunc:create(function ()
			self:atk()
		end)
		self:runAction(cc.Sequence:create(delay, acf))
	else
		local r = (minDistance - ATKDistance - DM.BuildingInfo.stdSize/2)/cc.pGetDistance(p1, p2)
		local moveToPot = GM:getRaitoPos(p2, p1, r)
		local moveByLength = cc.pGetDistance(p2, moveToPot)
		local act_run = cc.MoveTo:create(moveByLength/GM:getSpeed(string.sub(self.__cname, 1, -7)), moveToPot)
		local acf_atk = cc.CallFunc:create(function()
			return self:atk()
		end)
		local play_anim = cc.CallFunc:create(function ( )
			self.anim:getAnimation():play("run" .. num)
		end)
		local delay = cc.DelayTime:create(0.7)
		self.anim:getAnimation():stop()
		local seq = cc.Sequence:create(delay, play_anim, act_run, acf_atk)
		self:runAction(seq)
	end
end

function HumanBaseSprite:hurt(damage)
	self.currentHP = self.currentHP - damage
	self.bar:getParent():setVisible(true)
	if self.currentHP <= 0 then
		self.bar:setPercent(0)
		self:dead()
	else
		self.bar:setPercent(self.currentHP / self.fullHP * 100)
	end
end

function HumanBaseSprite:idle( ... )
	--print("Base idle")
end

function HumanBaseSprite:dead()
	--print("Base isDeath")
	-- 停止定时器
	if self.scheduleEntry then
		scheduler:unscheduleScriptEntry(self.scheduleEntry)
	end
	-- 跟新士兵数量
	if self.isDeath == false then
		local key = string.sub(self.__cname, 1, -7) .. "Num"
		self:getParent()[key] = self:getParent()[key] - 1
	end
	-- 停止动画和动作
	self.anim:getAnimation():stop()
	self:stopAllActions()
	local act = cc.Blink:create(1.7, 3)
	self:runAction(act)
	self.isDeath = true
	local function delayDeath()
		self:removeFromParent()
	end
	performWithDelay(self, delayDeath, 1.7)
end

function HumanBaseSprite:addHPBar()
	local bg = cc.Sprite:create(IMG_BUILD_PRO_BK)
	bg:setScaleY(0.8)
	local hpBar = ccui.LoadingBar:create(IMG_BUILD_PRO, 100)
	hpBar:setPosition(bg:getContentSize().width / 2, bg:getContentSize().height / 2)
	bg:addChild(hpBar)
	bg:setPosition(0, 45)
	bg:setVisible(false)
	self:addChild(bg, ORD_MIDDLE, TAG_BUILD_BAR)
	self.bar = hpBar
end

function HumanBaseSprite:removeHPBar()
	local bg = self.bar:getParent()

	bg:setVisible(false)
end

function HumanBaseSprite:onEnter()
	self:addHPBar()
end

function HumanBaseSprite:create()
	local humanBaseSprite = HumanBaseSprite.new()
	humanBaseSprite:setScale(0.7)

	humanBaseSprite:onEnter()

	return humanBaseSprite
end