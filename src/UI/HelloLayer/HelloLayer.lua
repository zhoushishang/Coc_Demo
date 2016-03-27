
HelloLayer = class("HelloLayer", function ( ... )
	return cc.Layer:create(...)
end)

local function showHomeLayer(self)
	self:setVisible(false)
	scene:removeChildByTag(TAG_LAYER_HELLO, cleanup)
	GlobalManager:showHomeLayer()
end

function HelloLayer:showUi(tar)
	tar:setOpacity(10)
	local fadeIn = cc.FadeTo:create(0.1, 255)
	--local fadeOut = cc.FadeTo:create(1, 0)
	local func = cc.CallFunc:create(function()
		return showHomeLayer(self)
	end)
	local seq = cc.Sequence:create(fadeIn, func)

	tar:runAction(seq)
end

function HelloLayer:onEnter()
	local bg = cc.Sprite:create(IMG_LOADING_BG)
	bg:setPosition(size.width / 2, size.height / 2)
	self:showUi(bg)
	self:addChild(bg)
end

function HelloLayer:create()
	local helloLayer = HelloLayer.new()

	helloLayer:onEnter()
	return helloLayer
end