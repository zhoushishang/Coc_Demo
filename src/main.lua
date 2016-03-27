
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

-- CC_USE_DEPRECATED_API = true

require "init"
first = true
-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function initGLView()
    local director = cc.Director:getInstance()
    local glView = director:getOpenGLView()
    if nil == glView then
        glView = cc.GLViewImpl:create("Lua Empty Test")
        director:setOpenGLView(glView)
    end
    
    director:setOpenGLView(glView)
    
    glView:setDesignResolutionSize(960, 640, 0)

    --turn on display FPS
    director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
end



local function loadResources( ... )

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANIM_FIGHTER)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANIM_BOWMAN)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANIM_GUNNER)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANIM_MEATSHIELD)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANIM_HERO_ARAGORN)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANIM_SKILL_1)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ANIM_SKILL_2)
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    initGLView()
    require "Utils.Global"

    loadResources()

    scene = cc.Scene:create()
    local helloLayer = HelloLayer:create()
    scene:addChild(helloLayer, 0, TAG_LAYER_HELLO)
    director:runWithScene(scene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
