
GameOverDialogLayer = class("GameOverDialogLayer", function()
	return ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_GAMEOVER)
end)

GameOverDialogLayer.enemyName = nil
GameOverDialogLayer.result    = nil

local function backCallBack(self)
	local EnemyInfo = GM:getEnemyInfo(self.enemyName)
	-- 设置奖励
	local goldReward = EnemyInfo.reward.Gold
   	local woodReward = EnemyInfo.reward.Wood
   	local ringReward = EnemyInfo.reward.Ring
   	local XPReward   = EnemyInfo.reward.EXP
   	GM:setGoldChange(goldReward)
   	GM:setWoodChange(woodReward)
   	GM:setRingIncrease(ringReward)
   	GM:setHeroEXPIncrease(XPReward)
   	-- 设置士兵数量
	local fighterRemain    = GM:getSoldierRemain("Fighter")
	local bowmanRemain     = GM:getSoldierRemain("Bowman")
	local gunnerRemain     = GM:getSoldierRemain("Gunner")
	local meatShieldRemain = GM:getSoldierRemain("MeatShield")
	GM:setSoldierNum("Fighter", fighterRemain)
	GM:setSoldierNum("Bowman", bowmanRemain)
	GM:setSoldierNum("Gunner", gunnerRemain)
	GM:setSoldierNum("MeatShield", meatShieldRemain)
	GM:closeDialogLayer()
	GM:showWorldLayer()
end

function GameOverDialogLayer:showWinInfo()
	local EnemyInfo = GM:getEnemyInfo(self.enemyName)
	local btnBack = ccui.Helper:seekWidgetByName(self, "BackButton")
	btnBack:addClickEventListener(function ()
		backCallBack(self)
	end)
	local wgGoldReward = ccui.Helper:seekWidgetByName(self, "GoldReward")
	local wgWoodReward = ccui.Helper:seekWidgetByName(self, "WoodReward")
	local wgRingReward = ccui.Helper:seekWidgetByName(self, "RingReward")
	local wgExpReward  = ccui.Helper:seekWidgetByName(self, "Exp")
	wgGoldReward:setString(EnemyInfo.reward.Gold)
	wgWoodReward:setString(EnemyInfo.reward.Wood)
	wgRingReward:setString(EnemyInfo.reward.Ring)
	wgExpReward:setString(EnemyInfo.reward.EXP)
	local fighterCount    = GM:getSoldierNum("Fighter")
	local bowmanCount     = GM:getSoldierNum("Bowman")
	local gunnerCount     = GM:getSoldierNum("Gunner")
	local meatShieldCount = GM:getSoldierNum("MeatShield")
	local fighterRemain    = GM:getSoldierRemain("Fighter")
	local bowmanRemain     = GM:getSoldierRemain("Bowman")
	local gunnerRemain     = GM:getSoldierRemain("Gunner")
	local meatShieldRemain = GM:getSoldierRemain("MeatShield")
	local wgFighterCount = ccui.Helper:seekWidgetByName(self, "FighterCount")
	local wgBowmanCount = ccui.Helper:seekWidgetByName(self, "BowmanCount")
	local wgGunnerCount = ccui.Helper:seekWidgetByName(self, "GunnerCount")
	local wgMeatShieldCount = ccui.Helper:seekWidgetByName(self, "MeatShieldCount")
	wgFighterCount:setString(fighterRemain - fighterCount)
	wgBowmanCount:setString(bowmanRemain - bowmanCount)
	wgGunnerCount:setString(gunnerRemain - gunnerCount)
	wgMeatShieldCount:setString(meatShieldRemain - meatShieldCount)
end

function GameOverDialogLayer:winDialog()
	local EnemyInfo = GM:getEnemyInfo(self.enemyName)
	local success = ccui.Helper:seekWidgetByName(self, "SuccessImage")
	success:setVisible(true)
	local star = ccui.Helper:seekWidgetByName(self, "Star")
	local rotate = cc.RotateBy:create(1, 90)
	star:setVisible(true)
	star:runAction(cc.RepeatForever:create(rotate))
	self:showWinInfo()
end

function GameOverDialogLayer:onEnter()
	if self.result == "Win" then
		self:winDialog()
	else
		self:loseDialog()
	end
end

function GameOverDialogLayer:create(result, enemyName)
	local gameOverDialogLayer = GameOverDialogLayer.new()

	gameOverDialogLayer.enemyName = enemyName
	gameOverDialogLayer.result    = result
	gameOverDialogLayer:onEnter(result, enemyName)

	return gameOverDialogLayer
end