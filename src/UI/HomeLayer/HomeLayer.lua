
HomeLayer = class("HomeLayer", function(...)
	return cc.Layer:create(...)
end)

function HomeLayer:onEnter()

	local mapLayer = HomeMapLayer:create()
	self:addChild(mapLayer, 0, TAG_LAYER_HOME_MAP)
end

function HomeLayer:create()
	local homeLayer = HomeLayer.new()
	homeLayer:onEnter()
	
	return homeLayer
end