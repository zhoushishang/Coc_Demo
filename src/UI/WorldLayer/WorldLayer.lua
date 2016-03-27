
WorldLayer = class("WorldLayer", function (...)
	return cc.Layer:create()
end)

function WorldLayer:homeCallback()
	GlobalManager:showHomeLayer()
end

function WorldLayer:onEnter()
	local mapLayer = WorldMapLayer:create()
	self:addChild(mapLayer)

	local btnHome = ccui.Button:create(IMG_BUTTON_HOME)
	btnHome:addClickEventListener(WorldLayer.homeCallback)
	btnHome:setPosition(size.width - 80, 80)
	self:addChild(btnHome)
end

function WorldLayer:create()
	local worldLayer = WorldLayer.new()
	worldLayer:onEnter()

	return worldLayer
end