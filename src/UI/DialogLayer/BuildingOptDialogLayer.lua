 
BuildingOptDialogLayer = class("BuildingOptDialogLayer", function(...)
	return cc.Layer:create(...)
end)

BuildingOptDialogLayer._instance      = nil  -- 目标建筑对象类
BuildingOptDialogLayer.btnInfoOpt     = nil
BuildingOptDialogLayer.btnUpgradeOpt  = nil
BuildingOptDialogLayer.btnEnterOpt    = nil

function BuildingOptDialogLayer:registerButtons()
	local function infoCallback()
		GM:showDialogLayer(BuildingInfoDialogLayer, self._instance)
		-- 重置目标建筑未选中状态
		self._instance:unselectedAction()
		-- 关闭对话框
		self:removeFromParent()
	end	
	local function upgradeCallback( )
		GM:showDialogLayer(BuildingUpgradeDialogLayer, self._instance)
		-- 重置目标建筑未选中状态
		self._instance:unselectedAction()
		-- 关闭对话框
		self:removeFromParent()
	end	
	local function enterCallback( )
		if self._instance.__cname == "CampSprite" then
			GM:showDialogLayer(CampDialogLayer, self._instance)
		elseif self._instance.__cname == "HeroHotelSprite" then
			GM:showDialogLayer(HeroHotelDialogLayer, self._instance)
		elseif self._instance.__cname == "ResearchLabSprite" then
			GM:showDialogLayer(ResearchLabDialogLayer, self._instance)
		end
		-- 重置目标建筑未选中状态
		self._instance:unselectedAction()
		-- 关闭对话框
		self:removeFromParent()

	end
	self.btnInfoOpt:addClickEventListener(infoCallback)
	self.btnUpgradeOpt:addClickEventListener(upgradeCallback)
	self.btnEnterOpt:addClickEventListener(enterCallback)
end

function BuildingOptDialogLayer:getOptType()
	-- 有的建筑需要2个选项，有的需要三个，在这个函数里做个区别。
	local cname = self._instance.__cname
	if  cname == "ResearchLabSprite" or
		cname == "CampSprite" or
		cname == "HeroHotelSprite" then
		return 3
	else
		return 2
	end
end

function BuildingOptDialogLayer:showUi( )
	local type = self:getOptType()
	if type == 2 then
		self.btnInfoOpt:setPosition(size.width / 2 - 65, 80)
		self:addChild(self.btnInfoOpt)
		self.btnUpgradeOpt:setPosition(size.width / 2 + 65, 80)
		self:addChild(self.btnUpgradeOpt)
	else
		self.btnInfoOpt:setPosition(size.width / 2 - 120, 80)
		self:addChild(self.btnInfoOpt)
		self.btnUpgradeOpt:setPosition(size.width / 2, 80)
		self:addChild(self.btnUpgradeOpt)
		self.btnEnterOpt:setPosition(size.width / 2 + 120, 80)
		self:addChild(self.btnEnterOpt)
	end
end

function BuildingOptDialogLayer:onEnter(instance)
	self._instance = instance
	self.btnInfoOpt    = ccui.Button:create(IMG_BUTTON_INFOOPT)
	self.btnUpgradeOpt = ccui.Button:create(IMG_BUTTON_UPGRADEOPT)
	self.btnEnterOpt   = ccui.Button:create(IMG_BUTTON_ENTEROPT)
	self:registerButtons()
	self:showUi()
end

function BuildingOptDialogLayer:create(instance)
	local optLayer = BuildingOptDialogLayer.new()

	optLayer:onEnter(instance)

	return optLayer
end