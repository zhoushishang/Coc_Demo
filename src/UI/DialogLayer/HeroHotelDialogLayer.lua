
HeroHotelDialogLayer = class("HeroHotelDialogLayer", function (...)
	return cc.Layer:create(...)
end)

function HeroHotelDialogLayer.infoCallback(sender)
	local heroHotelDialogLayer = scene._dialogLayer
	heroHotelDialogLayer:setName("HeroHotelDialogLayer")
	local name = sender:getName()
	if name == "AragornInfoButton" then
		GM:showDialogLayer(HeroInfoDialogLayer)
	end		
end

function HeroHotelDialogLayer:addListener( )
	local ui = self:getChildByName("UI")
	-- 关闭按钮
	local btnClose = ccui.Helper:seekWidgetByName(ui, "CloseButton")
	btnClose:addClickEventListener(GM.closeDialogLayer)
	-- 信息按钮
	local btnInfo  = ccui.Helper:seekWidgetByName(ui, "AragornInfoButton") 
	btnInfo:addClickEventListener(HeroHotelDialogLayer.infoCallback)
	-- 参战按钮
	local btnBattle = ccui.Helper:seekWidgetByName(ui, "AragornButton")
	btnBattle:addClickEventListener(function ()
		GM:showNotice("该英雄已进入参战状态~~~", self)
	end)
end

function HeroHotelDialogLayer:showDialog()
	-- Action
	local scale = cc.ScaleTo:create(0.3, 1)
	local act   = cc.EaseBackOut:create(scale)
	self:runAction(act)

	local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_HEROHOTEL)
	local bg = cc.Sprite:create(IMG_GRAY_BG)
	bg:setScale(size.width / 1000, size.height / 1000)
	bg:setOpacity(128)
	bg:setPosition(size.width / 2, size.height / 2)
	self:addChild(bg, ORD_BG)
	self:addChild(ui, ORD_BOTTOM, "UI")
	local wgLevel = ccui.Helper:seekWidgetByName(ui, "AragornLevel")
	wgLevel:setString(DM.HeroInfo.level)
end

function HeroHotelDialogLayer:onEnter()
	self:setScale(0)
	self:showDialog()
	self:addListener()
end

function HeroHotelDialogLayer:create()
	local dialogLayer = HeroHotelDialogLayer.new()

	dialogLayer:onEnter()

	return dialogLayer
end