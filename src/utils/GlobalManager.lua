
GlobalManager = {}
GM = GlobalManager

-- 查询主基地建筑和兵种的等级，不包括敌方基地建筑等级
function GlobalManager:getLevel(name, tag)
	if name == "Player" then
		return DM.Player.level
	elseif  name == "ArrowTower" or
		name == "Cannon" or
		name == "Laser" or
		name == "WoodFactory" or
		name == "MineFactory" then
		if tag then
			return DM.Player[name .. "s"].level[tag]
		else
			print("error：请输入目标建筑的TAG。")
		end
	else
		return DM.Player[name].level
	end
end

function GlobalManager:setLevel(name, level, tag)
	if  name == "ArrowTower" or
		name == "Cannon" or
		name == "Laser" or
		name == "WoodFactory" or
		name == "MineFactory" then
		if tag then
			if level then
				DM.Player[name .. "s"].level[tag] = level
			else
				DM.Player[name .. "s"].level[tag] = DM.Player[name .. "s"].level[tag] + 1
			end
		else
			print("error：请输入目标建筑的TAG。")
		end
	elseif level then
		DM.Player[name].level = level
	else
		DM.Player[name].level = DM.Player[name].level + 1
	end
end

function GlobalManager:getHP(name, level)
	return DM[name .. "Info"].healthPoint[level]
end

function GlobalManager:getDamage(name, level)
	return DM[name .. "Info"].damage[level]
end

function GlobalManager:getAttackGap(name)
	return DM[name .. "Info"].AttackGap
end

function GlobalManager:getName(name)
	return DM[name .. "Info"].name
end

function GlobalManager:getShootRange(name)
	return DM[name .. "Info"].ShootRange
end

function GlobalManager:getSpeed(name)
	return DM[name .. "Info"].Speed
end

------------------------- ShowLayer -------------------------
function GlobalManager:showHomeLayer()
	local worldLayer = scene:getChildByTag(TAG_LAYER_WORLD)
	local homeLayer  = scene:getChildByTag(TAG_LAYER_HOME)
	local homeHudLayer = scene:getChildByTag(TAG_LAYER_HOME_HUD)
	if scene.dialogLayer then
		scene.dialogLayer:removeFromParent()
		scene.dialogLayer = nil
	end
	if not homeLayer then  -- homeLayer 没创建，则创建它
		local homeLayer = HomeLayer:create()
		scene:addChild(homeLayer, ORD_BOTTOM, TAG_LAYER_HOME)
	end
	if not homeHudLayer then  -- homeHudLayer 没创建，则创建它
		local homeHudLayer = HomeHudLayer:create()
		scene:addChild(homeHudLayer, ORD_TOP, TAG_LAYER_HOME_HUD)
	else
		-- 进入WorldLayer时homeHudLayer被设为不显示，需要从新开启
		local btnWorld = homeHudLayer:getChildByTag(TAG_BUTTON_WORLD)
		local btnBuild = homeHudLayer:getChildByTag(TAG_BUTTON_BUILD)
		homeHudLayer:setVisible(true)
		btnWorld:setVisible(true)
		btnBuild:setVisible(true)
	end
	if worldLayer then
		worldLayer:setVisible(false)
		DM.Layer.WorldMapLayer:removeTouchListener()
	end
end

function GlobalManager:showWorldLayer()
	local worldLayer = scene:getChildByTag(TAG_LAYER_WORLD)
	local battleLayer = scene:getChildByTag(TAG_LAYER_BATTLE)
	local homeHudLayer = scene:getChildByTag(TAG_LAYER_HOME_HUD)
	local btnWorld = homeHudLayer:getChildByTag(TAG_BUTTON_WORLD)
	local btnBuild = homeHudLayer:getChildByTag(TAG_BUTTON_BUILD)
	-- 撤退或者战斗结束需要释放BattleLayer
	if battleLayer then
		scene:removeChildByTag(TAG_LAYER_BATTLE)
	end
	if not worldLayer then
		local worldLayer = WorldLayer:create()
		scene:addChild(worldLayer, ORD_MIDDLE, TAG_LAYER_WORLD)
		DM.Layer.BattleMapLayer = nil
		DM.Layer.BattleHudLayer = nil
	else
		worldLayer:setVisible(true)
		DM.Layer.WorldMapLayer:addTouchListener()
	end
	-- 设置HomeHudLayer的属性
	homeHudLayer:setVisible(true)
	btnWorld:setVisible(false)
	btnBuild:setVisible(false)
	-- 关闭对话框
	GM:closeDialogLayer()
end

function GlobalManager:showBattleSeekLayer(touchNode)
	local worldLayer = scene:getChildByTag(TAG_LAYER_WORLD)
	local homeHudLayer = scene:getChildByTag(TAG_LAYER_HOME_HUD)
	local battleLayer  = scene:getChildByTag(TAG_LAYER_BATTLE)
	-- 进入战斗画面释放HomeLayer
	scene:removeChildByTag(TAG_LAYER_HOME)
	DM.Layer.HomeMapLayer = nil
	if homeHudLayer then
		homeHudLayer:setVisible(false)
	end
	if worldLayer then
		worldLayer:setVisible(false)
		DM.Layer.WorldMapLayer:removeTouchListener()
	end
	if not battleSeekLayer then  -- homeLayer 没创建，则创建它
		local battleSeekLayer = BattleSeekLayer:create(touchNode)
		scene:addChild(battleSeekLayer, ORD_BOTTOM, TAG_LAYER_BATTLE)
	end
end

function GlobalManager:showBattleLayer(touchNode)
	local worldLayer = scene:getChildByTag(TAG_LAYER_WORLD)
	local homeHudLayer = scene:getChildByTag(TAG_LAYER_HOME_HUD)
	local battleLayer  = scene:getChildByTag(TAG_LAYER_BATTLE)
	-- 进入战斗画面释放HomeLayer
	scene:removeChildByTag(TAG_LAYER_HOME)
	DM.Layer.HomeMapLayer = nil
	if homeHudLayer then
		homeHudLayer:setVisible(false)
	end
	if worldLayer then
		worldLayer:setVisible(false)
		DM.Layer.WorldMapLayer:removeTouchListener()
	end
	if not battleLayer then  -- homeLayer 没创建，则创建它
		local battleLayer = BattleLayer:create(touchNode)
		scene:addChild(battleLayer, ORD_BOTTOM, TAG_LAYER_BATTLE)
	end
end

-- class为要新建的DialogLayer类，...为新建参数
function GlobalManager:showDialogLayer(class, ...)
	local dialogLayer = class:create(...)
	scene:addChild(dialogLayer, ORD_TOP)
	scene._dialogLayer = dialogLayer
end

function GlobalManager:closeDialogLayer()
	if scene._dialogLayer then
		scene._dialogLayer:removeFromParent()
		scene._dialogLayer = nil
	end
end

function GlobalManager:saveLayer(layerName, layerInstance)
	DM.Layer[layerName] = layerInstance
end

function GlobalManager:getLayer(layerName)
	return DM.Layer[layerName]
end

function GlobalManager:removeLayerFromDM(layerName)
	DM.Layer[layerName] = nil
end
------------------------- ShowLayer -------------------------

-- 解除所有建筑的选中状态
function GlobalManager:resetSelectedState( ... )
	local children = DM.Layer.HomeMapLayer:getChildren()
	for i = 1, #children do
		if children[i].isSelected then
			children[i].isSelected = false
			children[i]:unselectedAction()
		end
	end
end

function GlobalManager:beTouched(touch, event)
	-- 获取事件所绑定的 node
	local node = event:getCurrentTarget()
    -- 获取当前点击点所在相对按钮的位置坐标
	local locationInNode = node:convertToNodeSpace(touch:getLocation())
	local nodeSize = node:getContentSize()
	local rect = cc.rect(0, 0, nodeSize.width, nodeSize.height)
    -- 点击范围判断检测
	return cc.rectContainsPoint(rect, locationInNode)
end

-- 单指移动Layer或者Building
function GlobalManager:moveFollowsSlide(touch, event, moveLayer, contentSize)
	contentSize = contentSize or DM.bgSize
	local node = event:getCurrentTarget()
	local currentPosX, currentPosY = node:getPosition()
	local diff = touch:getDelta()
	local x = currentPosX + diff.x  -- 该node将要移动的到点
	local y = currentPosY + diff.y
	local cname = node.__cname
	if string.sub(cname, -5, -1) == "Layer" then
		-- 如果node是layer，其AnchorPoint是(0, 0)
		if x > contentSize.width / 2 - size.width / 2 then
			x = contentSize.width / 2 - size.width / 2
		elseif x < size.width / 2 - contentSize.width / 2 then
			x = size.width / 2 - contentSize.width / 2
		end
		if y > contentSize.height / 2 - size.height / 2 then
			y = contentSize.height / 2 - size.height / 2
		elseif y < size.height / 2 - contentSize.height / 2 then
			y = size.height / 2 - contentSize.height / 2
		end
		node:setPosition(x, y)
	elseif moveLayer then
		-- 选中Sprite但是要移动Layer
		local xx, yy = node:getParent():getPosition()
		local xx = xx + diff.x  -- 此node的Parent将要移动的到点
		local yy = yy + diff.y
		if xx > contentSize.width / 2 - size.width / 2 then
			xx = contentSize.width / 2 - size.width / 2
		elseif xx < size.width / 2 - contentSize.width / 2 then
			xx = size.width / 2 - contentSize.width / 2
		end
		if yy > contentSize.height / 2 - size.height / 2 then
			yy = contentSize.height / 2 - size.height / 2
		elseif yy < size.height / 2 - contentSize.height / 2 then
			yy = size.height / 2 - contentSize.height / 2
		end
		node:getParent():setPosition(xx, yy)  
	else
		node:setPosition(x, y)  -- 移动Sprite
	end
end

function GlobalManager:getNodePosition(node)
	local x, y = node:getPosition()
	return cc.p(x, y)
end

function GlobalManager:getAnimNum(p1)
	-- p1：目标指向战士的向量
	-- p2: y轴正方向
	local p2 = cc.p(0, 1)
	local angle = cc.pGetAngle(p1, p2)
	local pi = 3.1416
	local angle = angle + pi -- 加上pi的偏移，那么，角度都为正了。
	if angle >= 7/8*pi and angle <= 9/8*pi then
		return 0
	elseif angle < pi then
		local num = 4/pi*angle + 7/2
		return math.ceil(num)
	else
		local num = 4/pi*angle - 9/2
		return math.ceil(num)
	end
end

function GlobalManager:stopBattleSchedule(layer)
	-- 停止所有战斗计时器
	local children = layer:getChildren()
	for i = 1, #children do
		if (children[i].type == "Human" or
			children[i].type == "Building") and
			children[i].scheduleEntry then
			scheduler:unscheduleScriptEntry(children[i].scheduleEntry)
		end
	end
end

-- 根据系数r得到p1，p2之间的特定点
function GlobalManager:getRaitoPos(p1, p2, r)
	local x = p1.x + r * (p2.x - p1.x)
	local y = p1.y + r * (p2.y - p1.y)
	return cc.p(x, y)
end

function GlobalManager:showNotice(text, layer)
	local WIN_SIZE = director:getWinSize()
    
    local label = cc.LabelTTF:create(text, "Arial", 28)
    label:setPosition(WIN_SIZE.width/2, WIN_SIZE.height/2 - 20)
    label:setOpacity(0)
    label:setColor(cc.c3b(255, 0, 0))
    layer:addChild(label, 999)
    
    local function removeNotice()
    	label:removeFromParent()
    end
    -- action
    local moveUp1 = cc.MoveBy:create(0.25, cc.p(0, WIN_SIZE.height/6))
    local moveUp2 = cc.MoveBy:create(0.25, cc.p(0, WIN_SIZE.height/6))
    local fadeIn  = cc.FadeIn:create(0.25)
    local fadeOut = cc.FadeOut:create(0.25)
    local delay   = cc.DelayTime:create(1)
    local act1    = cc.Spawn:create(moveUp1, fadeIn)
    local act2    = cc.Spawn:create(moveUp2, fadeOut)
    local func    = cc.CallFunc:create(removeNotice)
    label:runAction(cc.Sequence:create(act1, delay, act2, func))
end

------------------------- Resource -------------------------
function GlobalManager:setGoldChange(gap)
	local goldCount = DM.Resource.goldCount
    local baseLevel = baseTowerSprite.level
	local capacity  = DM.BaseTowerInfo.MineCapacity[baseLevel]
    if goldCount + gap > capacity then
    	DM.Resource.goldCount = capacity
	elseif goldCount + gap < 0 then
		print("error: GoldCount below 0")
    	DM.Resource.goldCount = 0
    else
    	DM.Resource.goldCount = goldCount + gap
    end
	local hudLayer = DM.Layer.HomeHudLayer
	if hudLayer then
		hudLayer:showGold()
	end
end

function GlobalManager:getGoldCount()
	return DM.Resource.goldCount
end

function GlobalManager:setWoodChange(gap)
	local woodCount = DM.Resource.woodCount
    local baseLevel = baseTowerSprite.level
	local capacity  = DM.BaseTowerInfo.WoodCapacity[baseLevel]
    if woodCount + gap > capacity then
    	DM.Resource.woodCount = capacity
	elseif woodCount + gap < 0 then
		print("error: WoodCount below 0")
    	DM.Resource.woodCount = 0
    else
    	DM.Resource.woodCount = woodCount + gap
    end
	local hudLayer = DM.Layer.HomeHudLayer
	if hudLayer then
		hudLayer:showWood()
	end
end

function GlobalManager:getWoodCount()
	return DM.Resource.woodCount
end

function GlobalManager:getUpgradeGold(name, tag)
	local level = GM:getLevel(name, tag)
	return DM[name .. "Info"].upgradeGold[level + 1]
end

function GlobalManager:getUpgradeWood(name, tag)
	local level = GM:getLevel(name, tag)
	return DM[name .. "Info"].upgradeWood[level + 1]
end

function GlobalManager:getUpgradeTime(name, tag)
	local level = GM:getLevel(name, tag)
	return DM[name .. "Info"].upgradeTime[level + 1]
end

------------------------- Resource -------------------------

function GlobalManager:setIncreasedXP(XP)
	local currentEXP  = DM.EXP.currentEXP
	local level = DM.Player.level
	local capacityXP = DM.EXP.EXPTab[level]
	if XP + currentEXP < capacityXP then
		DM.EXP.currentEXP = XP + currentEXP
	else
		DM.EXP.currentEXP = XP + currentEXP - capacityXP
		DM.Player.level = level + 1
	end
	DM.Layer.HomeHudLayer:showXP()
end

function GlobalManager:getHeroEXP()
	return DM.Player.Hero.EXP
end

function GlobalManager:getHeroEXPLimit(level)
	return DM.HeroInfo.EXPTab[level]
end

function GlobalManager:setHeroEXPIncrease(XP)
	local heroLevel  = GM:getLevel("Hero")
	local currentEXP = DM.Player.Hero.EXP
	local capacityXP = DM.HeroInfo.EXPTab[heroLevel]
	if XP + currentEXP < capacityXP then
		DM.Player.Hero.EXP = XP + currentEXP
	else
		DM.Player.Hero.EXP = XP + currentEXP - capacityXP
		GM:setLevel("Hero", heroLevel + 1)
	end
end

function GlobalManager:setPlayerEXPIncrease(XP)
	local playerLevel = DM.Player.level 
	local currentEXP = DM.Player.currentEXP
	local capacityXP = DM.Player.EXPTab[playerLevel]
	if XP + currentEXP < capacityXP then
		DM.Player.currentEXP = XP + currentEXP
	else
		DM.Player.currentEXP = XP + currentEXP - capacityXP
		DM.Player.level = playerLevel + 1
	end
end

function GlobalManager:getPlayerCurrentEXP()
	return DM.Player.currentEXP 
end

function GlobalManager:getPlayerEXPLimit()
	local level = GM:getLevel("Player")
	return DM.Player.EXPTab[level]
end

function GlobalManager:getUpgradeEXP(name, level)
	-- level: Lv.1 -> Lv.2 则level应为2
	return DM[name .. "Info"].upgradeEXP[level]
end

function GlobalManager:setRingIncrease(inc)
	if DM.Player.ringCount + inc > 0 then
		DM.Player.ringCount = DM.Player.ringCount + inc
	else
		DM.Player.ringCount = 0
	end
	DM.Layer.HomeHudLayer:showRing()
end

function GlobalManager:setPlayerName(name)
	if name then
		DM.Player.name = name
	end
	DM.Layer.HomeHudLayer:showPlayerName()
end

------------------------- Soldier -------------------------
function GlobalManager:getSoldierNum(name)
	return DM.Player[name].num
end

function GlobalManager:getSoldierRemain(name)
	return DM.Layer.BattleMapLayer[name .. "Num"] + DM.Layer.BattleHudLayer[name .. "Num"]
end

-- 默认加一
function GlobalManager:setSoldierNum(name, num)
	if num then
		DM.Player[name].num = num
	else
		DM.Player[name].num = DM.Player[name].num + 1
	end
end

function GlobalManager:getSoldierLimit(name)
	local campLevel = DM.Player.Camp.level
	return DM.CampInfo[name .. "Limit"][campLevel]
end

function GlobalManager:getSoldierUpgradeCost(name)
	local soldierLevel = GM:getLevel(name)
	return DM[name .. "Info"].upgradeGold[soldierLevel + 1]
end

function GlobalManager:getSoldierCost(name)
	local soldierLevel = GM:getLevel(name)
	return DM[name .. "Info"].cost[soldierLevel]
end
------------------------- Soldier -------------------------

------------------------- Building -------------------------
-- 得到当前地图中特定建筑数目
function GlobalManager:getBuildingCount(cname)
	local children = DM.Layer.HomeMapLayer:getChildren()
	local count = 0
	for i = 1, #children do
		if children[i].__cname == cname then
			count = count + 1
		end
	end
	return count
end

-- 获得对应主基地等级的建筑数量限制
function GlobalManager:getBuildingLimit(cname)
	local level = baseTowerSprite.level
	local key = string.sub(cname, 1, -7) .. "Limit"
	return DM.BaseTowerInfo[key][level]
end

function GlobalManager:getBuildingImg(instance)
	local cname = instance.__cname
	local key = string.sub(cname, 1, -7)
	local path = "images/building/" .. key .. ".png"
	return path
end
------------------------- Building -------------------------


function GlobalManager:getEnemyInfo(enemyName)
	return DM.Player.Enemys[enemyName]
end

function GlobalManager:getClass(name)
	if name == "BaseTower" then
		return BaseTowerSprite
	elseif name == "ResearchLab" then
		return ResearchLabSprite
	elseif name == "Camp" then
		return CampSprite	
	elseif name == "Raider" then
		return RaiderSprite	
	elseif name == "HeroHotel" then
		return HeroHotelSprite	
	elseif name == "ArrowTower" then
		return ArrowTowerSprite	
	elseif name == "Cannon" then
		return CannonSprite	
	elseif name == "Laser" then
		return LaserSprite	
	elseif name == "MineFactory" then
		return MineFactorySprite
	elseif name == "WoodFactory" then
		return WoodFactorySprite		
	elseif name == "Hero" then
		return HeroSprite
	elseif name == "Fighter" then
		return FighterSprite
	elseif name == "Bowman" then
		return BowmanSprite
	elseif name == "Gunner" then
		return GunnerSprite
	elseif name == "MeatShield" then
		return MeatShieldSprite
	else
		print("invalid ClassName")		
	end
end