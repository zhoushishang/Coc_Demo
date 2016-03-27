
BattleLayer = class("BattleLayer", function (...)
	return cc.Layer:create()
end)

BattleLayer.touchNode = nil -- 进入本BattleLayer所对应的Enemy Button

function BattleLayer:onEnter()
	local battleMapLayer = BattleMapLayer:create(self.touchNode)
	local battleHudLayer = BattleHudLayer:create(self.touchNode)

	self:addChild(battleMapLayer, ORD_BOTTOM, TAG_LAYER_BATTLE_MAP)
	self:addChild(battleHudLayer, ORD_MIDDLE, TAG_LAYER_BATTLE_HUD)
end

function BattleLayer:create(touchNode)
	local battleLayer = BattleLayer.new()

	battleLayer.touchNode = touchNode
	battleLayer:onEnter()

	return battleLayer
end