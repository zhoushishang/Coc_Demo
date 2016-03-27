	
DataManager = {}
DM = DataManager

DM.Player = {}
	DM.Player.name = "YuHuai"
	DM.Player.level = 10
	DM.Player.ringCount = 0
	DM.Player.currentEXP = 0
	DM.Player.EXPTab = {100, 150, 210, 300, 420, 570, 750, 950, 1300, 1600}
	-- 建筑信息
	DM.Player.BaseTower = {}
		DM.Player.BaseTower.level = 9
		DM.Player.BaseTower.pos   = nil
	DM.Player.Camp = {}
		DM.Player.Camp.level = 1
		DM.Player.Camp.pos = nil
	DM.Player.Raider = {}
		DM.Player.Raider.level = 1
		DM.Player.Raider.pos = nil
	DM.Player.ResearchLab = {}
		DM.Player.ResearchLab.level = 1
		DM.Player.ResearchLab.pos = nil
	DM.Player.HeroHotel = {}
		DM.Player.HeroHotel.level = 1
		DM.Player.HeroHotel.pos = nil	
	DM.Player.ArrowTowers = {}
		DM.Player.ArrowTowers.level = {}
		DM.Player.ArrowTowers.pos = {}
	DM.Player.Cannons = {}
		DM.Player.Cannons.level = {}
		DM.Player.Cannons.pos = {}	
	DM.Player.Lasers = {}
		DM.Player.Lasers.level = {}
		DM.Player.Lasers.pos = {}
	DM.Player.MineFactorys = {}
		DM.Player.MineFactorys.level = {}
		DM.Player.MineFactorys.pos = {}
	DM.Player.WoodFactorys = {}
		DM.Player.WoodFactorys.level = {}
		DM.Player.WoodFactorys.pos = {}
	-- 兵种信息
	DM.Player.Hero = {}
		DM.Player.Hero.level = 1
		DM.Player.Hero.EXP = 0 
	DM.Player.Fighter = {}
		DM.Player.Fighter.level = 1
		DM.Player.Fighter.num = 0
	DM.Player.Bowman = {}
		DM.Player.Bowman.level = 1
		DM.Player.Bowman.num = 0		
	DM.Player.Gunner = {}
		DM.Player.Gunner.level = 1
		DM.Player.Gunner.num = 0
	DM.Player.MeatShield = {}
		DM.Player.MeatShield.level = 1
		DM.Player.MeatShield.num = 0
	-- 敌方基地信息
	DM.Player.Enemys = {}
		DM.Player.Enemys.Enemy01 = {
			-- 信息格式：pos, level
			-- UB:Unique Building MB:Multi Building
			-- XP:英雄获得的经验
			level  = 3,
			name   = "狐步舞",
			reward = {Gold = 1000, Wood = 300, Ring = 2, EXP = 30},
			UB_BaseTower     = {pos = cc.p(480, 300), level = 1},
			UB_ResearchLab   = {pos = cc.p(660, 440), level = 1},
			MB_MineFactory01 = {pos = cc.p(312, 434), level = 1},
			MB_Cannon01      = {pos = cc.p(480, 450), level = 1},
			MB_Cannon02      = {pos = cc.p(714, 315), level = 1},
			MB_Laser01       = {pos = cc.p(250, 300), level = 1},
			MB_Laser02       = {pos = cc.p(710, 153), level = 1},
			MB_ArrowTower01  = {pos = cc.p(480, 140), level = 1},
			MB_ArrowTower02  = {pos = cc.p(300, 170), level = 1}
		}
		DM.Player.Enemys.Enemy02 = {
			level  = 15,
			name   = "几何战争",
			reward = {Gold = 3000, Wood = 1000, Ring = 2, EXP = 60},
			UB_BaseTower     = {pos = cc.p(480, 300), level = 4},
			UB_ResearchLab   = {pos = cc.p(660, 440), level = 3},
			MB_MineFactory01 = {pos = cc.p(312, 434), level = 2},
			MB_Cannon01      = {pos = cc.p(480, 450), level = 4},
			MB_Cannon02      = {pos = cc.p(714, 315), level = 2},
			MB_Laser01       = {pos = cc.p(250, 300), level = 5},
			MB_Laser02       = {pos = cc.p(710, 153), level = 3},
			MB_ArrowTower01  = {pos = cc.p(480, 140), level = 4},
			MB_ArrowTower02  = {pos = cc.p(300, 170), level = 4}
		}
		DM.Player.Enemys.Enemy03 = {
			level  = 30,
			name   = "滑铁卢",
			reward = {Gold = 10000, Wood = 3000, Ring = 4, EXP = 100},
			UB_BaseTower     = {pos = cc.p(480, 300), level = 8},
			UB_ResearchLab   = {pos = cc.p(660, 440), level = 8},
			MB_MineFactory01 = {pos = cc.p(312, 434), level = 6},
			MB_Cannon01      = {pos = cc.p(480, 450), level = 7},
			MB_Cannon02      = {pos = cc.p(714, 315), level = 9},
			MB_Laser01       = {pos = cc.p(250, 300), level = 6},
			MB_Laser02       = {pos = cc.p(710, 153), level = 8},
			MB_ArrowTower01  = {pos = cc.p(480, 140), level = 6},
			MB_ArrowTower02  = {pos = cc.p(300, 170), level = 9}
		}

DM.EXP = {}
	DM.EXP.currentEXP = 0
	DM.EXP.EXPTab = {100, 150, 210, 300, 420, 570, 750, 950, 1300, 1600}

DM.Resource = {}
	DM.Resource.goldCount = 4000000
	DM.Resource.woodCount = 4000000

local speedIndex = 0.3
DM.Speed = {}
	DM.Speed.Bullet      = 1000 * speedIndex


DM.BulletDelay = {}
	DM.BulletDelay.Bowman = 0.1
	DM.BulletDelay.Gunner = 0.1

-- Building Infomation
DM.BaseTowerInfo = {}
	DM.BaseTowerInfo.name = "司令部"
	DM.BaseTowerInfo.description  = "司令部是城中的核心建筑。\n升级司令部可解锁更多建筑。"
	DM.BaseTowerInfo.healthPoint  = {38000, 42000, 53000, 64000, 76000, 88000, 100000, 115000, 130000, 140000}
	DM.BaseTowerInfo.WoodCapacity = {7000, 30000, 50000, 150000, 300000, 600000, 1500000, 3000000, 4000000, 6000000}
	DM.BaseTowerInfo.MineCapacity = {7000, 30000, 50000, 150000, 300000, 600000, 1500000, 3000000, 4000000, 6000000}
	DM.BaseTowerInfo.upgradeGold  = {600, 5900, 25000, 49000, 126000, 268000, 570000, 1350000, 2690000, 3700000}
	DM.BaseTowerInfo.upgradeWood  = {0, 0, 0, 9800, 30000, 97000, 340000, 1020000, 2200000, 3600000}
	DM.BaseTowerInfo.upgradeTime  = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.BaseTowerInfo.upgradeEXP   = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}
	DM.BaseTowerInfo.WoodFactoryLimit = {0, 1, 2, 2, 3, 3, 3, 3, 3, 3}
	DM.BaseTowerInfo.MineFactoryLimit = {1, 1, 2, 2, 3, 3, 3, 3, 3, 3}
	DM.BaseTowerInfo.ArrowTowerLimit  = {1, 2, 2, 3, 4, 5, 5, 6, 6, 7}
	DM.BaseTowerInfo.CannonLimit      = {0, 1, 1, 2, 2, 2, 3, 3, 4, 5}
	DM.BaseTowerInfo.LaserLimit       = {0, 0, 1, 2, 2, 2, 3, 3, 3, 4}

local distanceIndex = 10
DM.ArrowTowerInfo = {}
	DM.ArrowTowerInfo.name  = "狙击塔"
	DM.ArrowTowerInfo.description = "狙击塔内的狙击手可以精确狙杀敌军。\n由于配备有高性能的狙击步枪，他们的杀伤力不容小觑。"
	DM.ArrowTowerInfo.ShootRange  = 12 * distanceIndex + 50
	DM.ArrowTowerInfo.AttackGap   = 1.4
	DM.ArrowTowerInfo.healthPoint = {1850, 2190, 2600, 3100, 3600, 4300, 5100, 6000, 7100, 8400}
	DM.ArrowTowerInfo.damage      = {44, 53, 64, 78, 94, 114, 138, 167, 202, 245}
	DM.ArrowTowerInfo.upgradeGold = {100, 200, 760, 2070, 4700, 9300, 12500, 19100, 32000, 52000}
	DM.ArrowTowerInfo.upgradeWood = {0, 0, 0, 2200, 3800, 7100, 10000, 18000, 30000, 52000}
	DM.ArrowTowerInfo.upgradeTime = {0, 5, 10, 10, 150, 300, 500, 700, 900, 1000}
	DM.ArrowTowerInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.CannonInfo = {}
	DM.CannonInfo.name  = "加农炮"
	DM.CannonInfo.description = "加农炮尽管在重装弹药时耗时较长，\n但却可以给以敌人以毁灭性的打击。\n即使是最强的装甲也无法抵御它的攻击。"
	DM.CannonInfo.ShootRange  = 14 * distanceIndex + 50
	DM.CannonInfo.AttackGap   = 4
	DM.CannonInfo.healthPoint = {3500, 4200, 5600, 6800, 75000, 8300, 9100, 10000, 11000, 12100}
	DM.CannonInfo.damage      = {319, 386, 467, 565, 622, 684, 752, 827, 910, 1000}
	DM.CannonInfo.upgradeGold = {150, 300, 1080, 3070, 6700, 13300, 18500, 29100, 52000, 73000}
	DM.CannonInfo.upgradeWood = {0, 0, 1500, 3300, 4500, 10000, 15000, 27000, 45000, 73000}
	DM.CannonInfo.upgradeTime = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.CannonInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.LaserInfo = {}
	DM.LaserInfo.name  = "镭射机枪"
	DM.LaserInfo.description = "镭射机枪可以以高频率发射镭射弹，\n可以对一定范围内的目标造成群体伤害。"
	DM.LaserInfo.AttackGap   = 0.1
	DM.LaserInfo.ShootRange  = 9 * distanceIndex + 50
	DM.LaserInfo.healthPoint = {2500, 3000, 3500, 4200, 4900, 5800, 6300, 7500, 8200, 8900}
	DM.LaserInfo.damage      = {66, 80, 97, 117, 141, 171, 207, 228, 251, 276}
	DM.LaserInfo.upgradeGold = {200, 400, 1460, 4070, 9400, 18600, 25000, 38000, 64000, 104000}
	DM.LaserInfo.upgradeWood = {0, 1100, 2200, 4400, 7600, 14200, 20000, 39000, 60000, 104000}
	DM.LaserInfo.upgradeTime = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.LaserInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.MineFactoryInfo = {}
	DM.MineFactoryInfo.name  = "金矿场"
	DM.MineFactoryInfo.description = "金矿场可以生产金币，\n升级金矿场可以增加金矿产出。"
	DM.MineFactoryInfo.healthPoint = {1500, 1800, 2200, 2600, 3100, 3700, 4400, 5300, 6300, 7500}
	DM.MineFactoryInfo.production  = {120, 210, 360, 580, 900, 1320, 1800, 2400, 3000, 3500}
	DM.MineFactoryInfo.upgradeGold = {50, 200, 600, 3500, 10000, 0, 0, 0, 0, 0}
	DM.MineFactoryInfo.upgradeWood = {0, 0, 0, 0, 0, 9300, 21000, 95000, 410000, 670000}
	DM.MineFactoryInfo.upgradeTime = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.MineFactoryInfo.upgradeWood = {0, 0, 0, 0, 0, 9300, 21000, 95000, 410000, 670000}
	DM.MineFactoryInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.WoodFactoryInfo = {}
	DM.WoodFactoryInfo.name  = "木材厂"
	DM.WoodFactoryInfo.description = "木场可以生产木材"
	DM.WoodFactoryInfo.healthPoint = {1500, 1800, 2200, 2600, 3100, 3700, 4400, 5300, 6300, 7500}
	DM.WoodFactoryInfo.production  = {120, 210, 360, 580, 900, 1320, 1800, 2400, 3000, 3500}
	DM.WoodFactoryInfo.upgradeGold = {50, 200, 600, 3500, 10000, 0, 0, 0, 0, 0}
	DM.WoodFactoryInfo.upgradeWood = {0, 0, 0, 0, 0, 9300, 21000, 95000, 410000, 670000}
	DM.WoodFactoryInfo.upgradeTime = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.WoodFactoryInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.CampInfo = {}
	DM.CampInfo.name  = "兵营"
	DM.CampInfo.description = "兵营是士兵的居住场所，\n升级营帐可以增加士兵的数量的上限。"
	DM.CampInfo.healthPoint = {1500, 1800, 2200, 2600, 3100, 3700, 4400, 5300, 6300, 7500}
	DM.CampInfo.upgradeGold = {150, 350, 1140, 3800, 7800, 19800, 57000, 227000, 760000, 1480000}
	DM.CampInfo.upgradeWood = {0, 0, 0, 0, 0, 3500, 13500, 136000, 680000, 1440000}
	DM.CampInfo.upgradeTime = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.CampInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}
	DM.CampInfo.FighterLimit    = {6, 8, 10, 12, 14, 16, 18, 20, 22, 24}
	DM.CampInfo.BowmanLimit     = {0, 4,  5,  6,  7,  8,  9, 10, 11, 12}
	DM.CampInfo.GunnerLimit     = {0, 0,  3,  4,  4,  5,  6,  6,  7,  8}
	DM.CampInfo.MeatShieldLimit = {0, 0,  0,  3,  3,  4,  4,  5,  5,  6}

DM.ResearchLabInfo = {}
	DM.ResearchLabInfo.name  = "研究所"
	DM.ResearchLabInfo.description = "提升研究所等级，可继续进阶士兵"
	DM.ResearchLabInfo.healthPoint = {1500, 1800, 2200, 2600, 3100, 3700, 4400, 5300, 6300, 7500}
	DM.ResearchLabInfo.upgradeGold = {150, 350, 1140, 3800, 7800, 19800, 57000, 227000, 760000, 1480000}
	DM.ResearchLabInfo.upgradeWood = {0, 0, 0, 0, 0, 3500, 13500, 136000, 680000, 1440000}
	DM.ResearchLabInfo.upgradeTime = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.ResearchLabInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.HeroHotelInfo = {}
	DM.HeroHotelInfo.name  = "英雄旅馆"
	DM.HeroHotelInfo.description = "英雄的聚集之地，升级英雄旅馆等级\n可解锁新技能以及增强英雄属性。"
	DM.HeroHotelInfo.healthPoint = {1500, 1800, 2200, 2600, 3100, 3700, 4400, 5300, 6300, 7500}
	DM.HeroHotelInfo.upgradeGold = {400, 5900, 16500, 44000, 114000, 249000, 520000, 1330000, 2430000, 3200000}
	DM.HeroHotelInfo.upgradeWood = {0, 0, 5100, 9600, 28700, 117000, 450000, 1190000, 2220000, 3200000}
	DM.HeroHotelInfo.upgradeTime = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.HeroHotelInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.RaiderInfo = {}
	DM.RaiderInfo.name  = "雷达"
	DM.RaiderInfo.description = "升级雷达可扩大世界地图的探索区域。"
	DM.RaiderInfo.healthPoint = {1500, 1800, 2200, 2600, 3100, 3700, 4400, 5300, 6300, 7500}
	DM.RaiderInfo.upgradeGold = {400, 5900, 16500, 44000, 114000, 249000, 520000, 1330000, 2430000, 3200000}
	DM.RaiderInfo.upgradeWood = {0, 0, 5100, 9600, 28700, 117000, 450000, 1190000, 2220000, 3200000}
	DM.RaiderInfo.upgradeTime = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5}
	DM.RaiderInfo.upgradeEXP  = {50, 80, 95, 20, 25, 30, 35, 40, 45, 50}

-- Hero Information
DM.HeroInfo = {}
	DM.HeroInfo.level = 1
	DM.HeroInfo.name  = "阿拉贡"
	DM.HeroInfo.description = "阿拉贡，人类的英雄。各方面表现都很出色。"
	DM.HeroInfo.AttackGap   = 1
	DM.HeroInfo.ShootRange  = 0.9 * distanceIndex
	DM.HeroInfo.Speed       = 130 * speedIndex
	DM.HeroInfo.healthPoint = {25000, 26800, 28600, 30600, 32800, 35000, 37500, 40000, 43000, 45000}
	DM.HeroInfo.damage      = {806, 886, 975, 1050, 1155, 1272, 1398, 1536, 1692, 1860}
	DM.HeroInfo.EXPTab      = {50, 75, 105, 150, 210, 300, 375, 475, 650, 800}
	DM.HeroInfo.evadeSkill  = {20, 23, 27, 30, 33, 37, 40, 43, 47, 50}
	DM.HeroInfo.rageSkill   = {5, 6, 7, 8, 9, 10, 11, 12, 13, 15}
	DM.HeroInfo.shieldSkill = {60, 70, 80, 90, 100, 110, 120, 130, 140, 150}

-- Soldier Information
DM.FighterInfo = {}
	DM.FighterInfo.level = 1
	DM.FighterInfo.name  = "人类士兵"
	DM.FighterInfo.description = "作为基本地面单位，士兵们可以对敌方造成一定\n伤害。如果施以人海战术，士兵们几乎势不可挡。"
	DM.FighterInfo.AttackGap   = 1
	DM.FighterInfo.ShootRange  = 0.9 * distanceIndex
	DM.FighterInfo.Speed       = 120 * speedIndex 
	DM.FighterInfo.healthPoint = {150, 172, 196, 225, 257, 295, 337, 386, 442, 506}
	DM.FighterInfo.damage      = {32, 38, 44, 52, 61, 71, 84, 98, 115, 134}
	DM.FighterInfo.cost        = {20, 100, 200, 300, 400, 500, 700, 900, 1100, 1300}
	DM.FighterInfo.upgradeGold = {0, 9500, 42000, 140000, 270000, 430000, 670000, 8000000, 1500000, 2000000}
	DM.FighterInfo.upgradeTime = {0, 5, 5, 120, 150, 300, 500, 700, 900, 1000}
	DM.FighterInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.BowmanInfo = {}
	DM.BowmanInfo.level = 1
	DM.BowmanInfo.name  = "精灵弓箭手"
	DM.BowmanInfo.description = "精灵弓箭手是基本的远程兵种，\n不错的杀伤力可以对敌方造成可观的伤害。"
	DM.BowmanInfo.AttackGap   = 1
	DM.BowmanInfo.ShootRange  = 7.2 * distanceIndex
	DM.BowmanInfo.Speed       = 100 * speedIndex
	DM.BowmanInfo.healthPoint = {54, 64, 76, 90, 107, 126, 150, 177, 210, 248}
	DM.BowmanInfo.damage  	  = {88, 106, 129, 156, 189, 228, 276, 334, 404, 489}
	DM.BowmanInfo.cost        = {220, 450, 700, 1000, 1300, 1600, 2000, 2400, 2800, 3200}
	DM.BowmanInfo.upgradeGold = {0, 16000, 88000, 250000, 360000, 560000, 900000, 1100000, 1500000, 2200000}
	DM.BowmanInfo.upgradeTime = {0, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.BowmanInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.GunnerInfo = {}
	DM.GunnerInfo.level = 1
	DM.GunnerInfo.name  = "矮人炮手"
	DM.GunnerInfo.description = "矮人炮手装备了先进的火焰枪，\n具有很高的攻击力，能对敌方造成毁灭性打击。"
	DM.GunnerInfo.AttackGap   = 1
	DM.GunnerInfo.ShootRange  = 10.5 * distanceIndex
	DM.GunnerInfo.Speed       = 80  * speedIndex 
	DM.GunnerInfo.healthPoint = {400, 477, 506, 538, 568, 602, 638, 680, 720, 760}
	DM.GunnerInfo.damage  	  = {170, 219, 260, 312, 389, 456, 526, 668, 808, 960}
	DM.GunnerInfo.cost   	  = {400, 800, 1200, 1800, 2500, 3300, 4100, 4900, 5500, 6500}
	DM.GunnerInfo.upgradeGold = {0, 36000, 148000, 400000, 700000, 900000, 1500000, 1900000, 2500000, 3200000}
	DM.GunnerInfo.upgradeTime = {0, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.GunnerInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.MeatShieldInfo = {}
	DM.MeatShieldInfo.level = 1
	DM.MeatShieldInfo.name  = "兽人肉盾"
	DM.MeatShieldInfo.description = "兽人肉盾敢于扑向敌人，乐于吸引敌人的全部\n火力，从而掩护其他兵种，给敌人致命的一击。"
	DM.MeatShieldInfo.AttackGap   = 1
	DM.MeatShieldInfo.ShootRange  = 3.3
	DM.MeatShieldInfo.Speed       = 110 * speedIndex
	DM.MeatShieldInfo.healthPoint = {1080, 1260, 1469, 1714, 1999, 2332, 2720, 3172, 3700, 4316}
	DM.MeatShieldInfo.damage  	  = {28, 33, 39, 46, 54, 64, 75, 88, 104, 123}
	DM.MeatShieldInfo.cost   	  = {500, 900, 1400, 2000, 2800, 3600, 4400, 5200, 6000, 7000}
	DM.MeatShieldInfo.upgradeGold = {0, 46000, 168000, 450000, 760000, 1160000, 1800000, 2100000, 3000000, 3800000}
	DM.MeatShieldInfo.upgradeTime = {10, 30, 60, 120, 150, 300, 500, 700, 900, 1000}
	DM.MeatShieldInfo.upgradeEXP  = {5, 10, 15, 20, 25, 30, 35, 40, 45, 50}

DM.BuildingInfo = {}
	DM.BuildingInfo.stdSize = 60

DM.Layer = {}
	DM.Layer.HomeMapLayer   = nil
	DM.Layer.HomeHudLayer   = nil
	DM.Layer.WorldMapLayer  = nil
	DM.Layer.BattleMapLayer = nil
	DM.Layer.BattleHudLayer = nil

DM.BattleLayer = {}
	DM.BattleLayer.SelectItem = nil

DM.bgSize    = cc.size(2000, 1500)
DM.worldSize = cc.size(2000, 2000)
