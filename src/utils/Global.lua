
director = cc.Director:getInstance()
size     = director:getVisibleSize()  -- 在initGLView()之后才会产生正确的值
eventDispatcher = director:getEventDispatcher()
scheduler = director:getScheduler()

upgradingSoldier = nil
upgradingBuilding = nil
baseTowerSprite = nil
researchLabSprite = nil
campSprite = nil