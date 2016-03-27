
WorldHudLayer = class("WorldHudLayer", function ()
	return ccs.GUIReader:getInstance():widgetFromJsonFile(UI_LAYER_WORLDHUD)
end)

function WorldHudLayer:homeCallback()
	GlobalManager:showHomeLayer()
end

function WorldHudLayer:onEnter()
	local btnHome = ccui.Helper:seekWidgetByName(self, "HomeButton")
	btnHome:addClickEventListener(WorldHudLayer.homeCallback)
end

function WorldHudLayer:create()
	local hudLayer = WorldHudLayer.new()
	
	self:onEnter()

	return hudLayer
end