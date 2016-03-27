
HeroInfoDialogLayer = class("HeroInfoDialogLayer", function ( ... )
	return cc.Layer:create(...)
end)

function HeroInfoDialogLayer:showInfo( )
	local ui = self:getChildByName("UI")
	-- 英雄动画
	local anim = ccs.Armature:create(ANIM_NAME_ARAGORN)
	anim:getAnimation():play("run0")
	anim:setPosition(255, 370)
	anim:setScale(2.5)
	self:addChild(anim, ORD_TOP)
	local scheduleEntry = nil
	local function animRandom()
		if scene._dialogLayer ~= self then
			if scheduleEntry then
				scheduler:unscheduleScriptEntry(scheduleEntry)
				scheduleEntry = nil
			end
			return
		end
		local num = math.random(0, 16)
		num = math.floor(num)
		if num < 8 then
			anim:getAnimation():play("run" .. num)
		elseif num ~= 16 then
			anim:getAnimation():play("atk" .. (num - 8))
		else
			anim:getAnimation():play("atk7")
		end
	end
	scheduleEntry = scheduler:scheduleScriptFunc(animRandom, 3, false)
	-- 面板信息
	local title = ccui.Helper:seekWidgetByName(ui, "Title")
	local level = GM:getLevel("Hero")
	title:setString("阿拉贡(Lv." .. level .. ")")
end

function HeroInfoDialogLayer:setSkillBoard()
	local ui = self:getChildByName("UI")
	local evadeSkill = ccui.Helper:seekWidgetByName(ui, "EvadeSkillDescription")
	local rageSkill = ccui.Helper:seekWidgetByName(ui, "RageSkillDescription")
	local shieldSkill = ccui.Helper:seekWidgetByName(ui, "ShieldSkillDescription")
	local level = DM.HeroInfo.level
	evadeSkill:setString("有" .. DM.HeroInfo.evadeSkill[level] .."%的几率躲避敌方攻击。")
	rageSkill:setString("伤害翻倍，持续" .. DM.HeroInfo.rageSkill[level] .. "秒。")
	if DM.HeroInfo.shieldSkill[level] <= 100 then
		shieldSkill:setString("受到的伤害降低" .. DM.HeroInfo.shieldSkill[level] .."%，持续10秒。")
    else
		shieldSkill:setString("将受到伤害的" .. (DM.HeroInfo.shieldSkill[level] - 100) .."%转化为HP，持续10秒。")
    end
	-- 技能图片
	local skillBoard  = ccui.Helper:seekWidgetByName(ui, "SkillBoard")
	local evadeImage  = ccui.ImageView:create(IMG_SKILL_BSKILL)
	local rageImage   = ccui.ImageView:create(IMG_SKILL_ZSKILL)
	local shieldImage = ccui.ImageView:create(IMG_SKILL_ZZSKILL)
	evadeImage:setPosition(150, 450)
	evadeImage:setScale(1.8)
	skillBoard:addChild(evadeImage)
	rageImage:setPosition(150, 280)
	rageImage:setScale(1.8)
	skillBoard:addChild(rageImage)
	shieldImage:setPosition(150, 120)
	shieldImage:setScale(1.8)
	skillBoard:addChild(shieldImage)
end

function HeroInfoDialogLayer:setBaseBoard()
	local ui = self:getChildByName("UI")
	local healthPoint = ccui.Helper:seekWidgetByName(ui, "HealthPoint")
	local damage      = ccui.Helper:seekWidgetByName(ui, "Damage")
	local atkGap      = ccui.Helper:seekWidgetByName(ui, "AttackGap")
	local shootRange  = ccui.Helper:seekWidgetByName(ui, "ShootRange")
	local hpUp		  = ccui.Helper:seekWidgetByName(ui, "HealthPointUp")
	local damageUp    = ccui.Helper:seekWidgetByName(ui, "DamageUp")
	local exp 		  = ccui.Helper:seekWidgetByName(ui, "Exp")

	local level = GM:getLevel("Hero")
	healthPoint:setString(GM:getHP("Hero", level))
	damage:setString(GM:getDamage("Hero", level))
	atkGap:setString(GM:getAttackGap("Hero") .. "s")
	shootRange:setString(GM:getShootRange("Hero"))
	if level < 10 then
		hpUp:setString(GM:getHP("Hero", level + 1) - GM:getHP("Hero", level))
		damageUp:setString(GM:getDamage("Hero", level + 1) - GM:getDamage("Hero", level))
		exp:setString(GM:getHeroEXP() .. "/" .. GM:getHeroEXPLimit(level))
	else
		hpUp:setString(0)
		damageUp:setString(0)
		exp:setString("0/--")
	end
end

function HeroInfoDialogLayer:showDialog( )
	-- Action
	local scale = cc.ScaleTo:create(0.3, 1)
	local act   = cc.EaseBackOut:create(scale)
	self:runAction(act)
	
	local ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UI_DIALOG_HEROINFO)
	self:addChild(ui, ORD_TOP, "UI")
	-- 关闭按钮
	local btnClose = ccui.Helper:seekWidgetByName(ui, "CloseButton")
	btnClose:addClickEventListener(function()
		GM:closeDialogLayer()
		local heroHotelDialogLayer = scene:getChildByName("HeroHotelDialogLayer")
		scene._dialogLayer = heroHotelDialogLayer
	end)
	-- 属性按钮
	local baseBoard = ccui.Helper:seekWidgetByName(ui, "BaseBoard")
    local skillBoard = ccui.Helper:seekWidgetByName(ui, "SkillBoard")
	local btnBase = ccui.Helper:seekWidgetByName(ui, "BaseButton")
	self:setBaseBoard()   -- 初始化属性模板
	btnBase:addClickEventListener(function ()
		baseBoard:setVisible(true)
		skillBoard:setVisible(false)
	end)
	-- 技能按钮
	local btnSkill = ccui.Helper:seekWidgetByName(ui, "SkillButton")
	self:setSkillBoard()  -- 初始化技能模板
	btnSkill:addClickEventListener(function ()
		baseBoard:setVisible(false)
		skillBoard:setVisible(true)
	end)
end

function HeroInfoDialogLayer:onEnter()
	self:setScale(0)
	self:showDialog()
	self:showInfo()
end

function HeroInfoDialogLayer:create(...)
	local dialogLayer = HeroInfoDialogLayer.new()

	dialogLayer:onEnter()

	return dialogLayer
end