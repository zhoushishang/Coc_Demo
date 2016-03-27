
TownDialogLayer = class("TownDialogLayer", function(...)
	return cc.Layer:create(...)
end)

TownDialogLayer.button = nil

function TownDialogLayer:showRewardInfo()
	local ui = self.button:getChildByName("UI")
	local EnemyInfo = GM:getEnemyInfo(self.button:getName())
	local goldReward = ccui.Helper:seekWidgetByName(ui, "GoldReward")
	goldReward:setString(EnemyInfo.reward.Gold)
	local woodReward = ccui.Helper:seekWidgetByName(ui, "WoodReward")
	woodReward:setString(EnemyInfo.reward.Wood)
	local ringReward = ccui.Helper:seekWidgetByName(ui, "RingReward")
	ringReward:setString(EnemyInfo.reward.Ring)
end

function TownDialogLayer:showDialog()
	local btnName = self.button:getName()
	if btnName == "TownHome" then
		local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_HOME)
		ui:setScale(0.7)
		ui:setAnchorPoint(0.5, 0)
		ui:setPosition(self.button:getContentSize().width / 2, 0)
		self.button:addChild(ui, ORD_TOP, "UI")
		if scene.dialogLayer then
			scene.dialogLayer:removeFromParent()
			scene.dialogLayer = nil
		end
		scene.dialogLayer = ui
		local btnEnterHome = ccui.Helper:seekWidgetByName(ui, "EnterButton")
		btnEnterHome:setSwallowTouches(true)
		btnEnterHome:addClickEventListener(function ()
			GM:showHomeLayer()
			scene.dialogLayer = nil
		end)
	else
		local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_CHAPTER)
		ui:setScale(0.5)
		ui:setAnchorPoint(0.5, 0)
		ui:setPosition(self.button:getContentSize().width / 2, -30)
		self.button:addChild(ui, ORD_TOP, "UI")
		self:showRewardInfo()
		if scene.dialogLayer then
			scene.dialogLayer:removeFromParent()
			scene.dialogLayer = nil
		end
		scene.dialogLayer = ui
		local btnSeek = ccui.Helper:seekWidgetByName(ui, "SeekButton")
		btnSeek:setSwallowTouches(true)
		local btn = self.button  -- 一定要存储，否则callback函数执行时这个类已经返回了，self就不存在了
		btnSeek:addClickEventListener(function ()
			GM:showBattleSeekLayer(btn)
			ui:removeFromParent()
			scene.dialogLayer = nil
		end)
		local btnFight = ccui.Helper:seekWidgetByName(ui, "FightButton")
		btnFight:setSwallowTouches(true)
		btnFight:addClickEventListener(function ()
			GM:showBattleLayer(btn)
			ui:removeFromParent()
			scene.dialogLayer = nil
		end)
	end
end

function TownDialogLayer:onEnter()
	self:showDialog()
end

function TownDialogLayer:create(button)
	local dialogLayer = TownDialogLayer.new()

	dialogLayer.button = button
	dialogLayer:onEnter()

	return dialogLayer
end