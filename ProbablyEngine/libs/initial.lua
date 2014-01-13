-- Initialize tables
if not cute then cute = {} end

-- ProbablyEngine.condition.register("dummy",function() -- Dummy Check
	-- cutedummies = {
		-- 31146, --Raider's Training Dummy - Lvl ??
		-- 67127, --Training Dummy - Lvl 90
		-- 46647, --Training Dummy - Lvl 85
		-- 32546, --Ebon Knight's Training Dummy - Lvl 80
		-- 31144, --Training Dummy - Lvl 80
		-- 32667, --Training Dummy - Lvl 70
		-- 32542, --Disciple's Training Dummy - Lvl 65
		-- 32666, --Training Dummy - Lvl 60
		-- 32545, --Initiate's Training Dummy - Lvl 55 
		-- 32541, --Initiate's Training Dummy - Lvl 55 (Scarlet Enclave) 
	-- }
	-- for i=1, #cutedummies do
		-- if UnitExists("target") then
			-- cutedummyID = tonumber(UnitGUID("target"):sub(-13, -9), 16)
		-- else
			-- cutedummyID = 0
		-- end
		-- if cutedummyID == cutedummies[i] then
			-- return true
		-- else
			-- return false
		-- end	
	-- end
-- end)
local DSL = ProbablyEngine.dsl.get
 

local dummies = {
  unitIDs = {
    31146, --Raider's Training Dummy - Lvl ??
    67127, --Training Dummy - Lvl 90
    46647, --Training Dummy - Lvl 85
    32546, --Ebon Knight's Training Dummy - Lvl 80
    31144, --Training Dummy - Lvl 80
    32667, --Training Dummy - Lvl 70
    32542, --Disciple's Training Dummy - Lvl 65
    32666, --Training Dummy - Lvl 60
    32545, --Initiate's Training Dummy - Lvl 55 
    32541, --Initiate's Training Dummy - Lvl 55 (Scarlet Enclave) 
  }
}

function dummies.check()
  if not UnitExists('target') then return false end

  local dummy = tonumber(UnitGUID('target'):sub(-13, -9), 16)
  for i = 1, #dummies.unitIDs do
    if dummy == dummies.unitIDs[i] then return true end
  end

  return false
end

function cute.checkDummy()
  if --DSL('toggle')('dummy')
     DSL('time')() > 300
     and dummies.check() then
    StopAttack()
    ClearTarget()
    print('5 minute dummy test concluded - Profile Stopped')
  end
end

ProbablyEngine.condition.register("ctime",function()				-- Rotation Timer
	if cuteTimer == nil then
		cuteTimer = 0
	end
	if cutecTime == nil then
		cutecTime = 0
	end
	if UnitAffectingCombat("player") and cuteTimer == 0 then
		 cuteTimer = GetTime()
	end
	if cuteTimer > 0 then
		 cutecTime = (GetTime() - cuteTimer)
	end
	if not UnitAffectingCombat("player") and not UnitExists("target") then
		cuteTimer = 0
		cutecTime = 0
	end
	return cutecTime
end)

ProbablyEngine.condition.register("power",function() 
	if UnitBuffID("player",106951) then
		return (UnitPower("player")*2)
	elseif UnitBuffID("player",135700) then
		return 100
	else
		return UnitPower("player")
	end
end)

ProbablyEngine.condition.register("regen", function()
  return select(2, GetPowerRegen("player"))
end)

ProbablyEngine.condition.register("rrr",function() 		--Rune of Reorigination Duration Tracking
	if UnitBuffID("player",139121) then
		return (select(7, UnitBuffID("player",139121)) - GetTime())
	elseif UnitBuffID("player",139117) then
		return (select(7, UnitBuffID("player",139117)) - GetTime())
	elseif UnitBuffID("player",139120) then
		return (select(7, UnitBuffID("player",139120)) - GetTime())
	else
		return 0
	end
end)
ProbablyEngine.condition.register("thrr",function()		--Trash Duration Tracking
	if UnitDebuffID("target",106830,"player") then
		return (select(7, UnitDebuffID("target",106830,"player")) - GetTime())
	else
		return 0
	end
end)

ProbablyEngine.condition.register("rkr",function()		--Rake Duration Tracking
	if UnitDebuffID("target",1822,"player") then
		return (select(7, UnitDebuffID("target",1822,"player")) - GetTime())
	else
		return 0
	end
end)

ProbablyEngine.condition.register("rpr",function()
	if UnitDebuffID("target",1079,"player") and UnitLevel("player") >= 20 then
		return (select(7, UnitDebuffID("target",1079,"player")) - GetTime())
	else
		if UnitLevel("player") < 20 then
			return 999
		else
			return 0
		end
	end
end)

ProbablyEngine.condition.register("srr",function()
	if ProbablyEngine.dsl.get("glyph")("player",127540) == true then
		if UnitBuffID("player",127538) and UnitLevel("player") >= 18 then
			return (select(7, UnitBuffID("player",127538)) - GetTime())
		else
			if UnitLevel("player") < 18 then
				return 999
			else
				return 0
			end
		end
	else
		if UnitBuffID("player",52610) and UnitLevel("player") >= 18 then
			return (select(7, UnitBuffID("player",52610)) - GetTime())
		else
			if UnitLevel("player") < 18 then
				return 999
			else
				return 0
			end
		end
	end
end)
ProbablyEngine.condition.register("srt",function()	--Total Sasvage Roar Time
	if (12 + (GetComboPoints("player")*6)) > (ProbablyEngine.dsl.get("srr")() + 12) then
		return true
	else
		return false
	end
end)
ProbablyEngine.condition.register("srrpdiff",function()	--Savage Roar / Rip Duration Difference
	if UnitLevel("player") >= 20 then
		if (ProbablyEngine.dsl.get("rpr")() - ProbablyEngine.dsl.get("srr")()) < 0 then
			return -(ProbablyEngine.dsl.get("rpr")()  - ProbablyEngine.dsl.get("srr")())
		else
			return (ProbablyEngine.dsl.get("rpr")() - ProbablyEngine.dsl.get("srr")())
		end
	else
		return 0
	end
end)

ProbablyEngine.condition.register("dcb",function() 		--Dream of Cenarius Damage Modifier
	if select(4,UnitBuffID("player",145152)) == nil then
		return 1
	else 
		return 1.3
	end
end)

ProbablyEngine.condition.register("mgld",function() 		--Potential Mangle Damage
	return (((((select(1, UnitDamage("player")) + select(2, UnitDamage("player")))/2)/2)*5)+(390*select(7,UnitDamage("player"))))*ProbablyEngine.dsl.get("dcb")()
end)

ProbablyEngine.condition.register("crkd",function() 		--Potential Rake Dot Damage
	return ((118 + (0.368 * UnitAttackPower("player"))) * (1 + GetMasteryEffect() / 100) * 0.8154868 * select(7, UnitDamage("player")))*ProbablyEngine.dsl.get("dcb")()
end)
	
ProbablyEngine.condition.register("rkd",function() 		--Active Rake Dot Damage
	if nDbDmg("target",1822,"player")~=nil then
		return nDbDmg("target",1822,"player")
	else
		return 100
	end
end)

ProbablyEngine.condition.register("rkp",function() 		--Percent Potential Rip Dot to Active Rip Dot 
	return round2(((ProbablyEngine.dsl.get("crkd")() / ProbablyEngine.dsl.get("rkd")())*100),2)
end)

ProbablyEngine.condition.register("crpd",function() 		--Potential Rip Dot Damage
	return (floor(113 + 320 * GetComboPoints("player") * (1+(GetMasteryEffect()/100)) + 0.04851 * GetComboPoints("player") * UnitAttackPower("player") * (1+(GetMasteryEffect()/100)))*select(7, UnitDamage("player")))*ProbablyEngine.dsl.get("dcb")()
end)
	
ProbablyEngine.condition.register("rpd",function() 		--Active Rip Dot Damage
	if nDbDmg("target",1079,"player")~=nil then
		return nDbDmg("target",1079,"player")
	else
		return 100
	end
end)

ProbablyEngine.condition.register("rpp",function() 		--Percent Potential Rip Dot to Active Rip Dot 
	return round2(((ProbablyEngine.dsl.get("crpd")() / ProbablyEngine.dsl.get("rpd")())*100),2)
end)

ProbablyEngine.condition.register("dex",function()		-- Assurance of Consequence Duration Tracking
	if UnitBuffID("player",146308) then
		return (select(7,UnitBuffID("player",146308)) - GetTime())
	else
		return 0
	end
end)

ProbablyEngine.condition.register("rscr",function()		-- Renataki's Soul Charm Duration Tracking
	if UnitBuffID("player", 138756) then
		return (select(7, UnitBuffID("player", 138756)) - GetTime())
	else
		return 0
	end
end)

-- Stack Counts
ProbablyEngine.condition.register("rscbuff",function() 	--Renataki's Soul Charm Buff Count
	if UnitBuffID("player", 138756) then
		return select(4,UnitBuffID("player", 138756))
	else
		return 0
	end
end)

ProbablyEngine.condition.register("canshr",function()	--I can has Shred?
	if ((UnitBuffID("player",106951) or UnitBuffID("player",5217)) and ProbablyEngine.dsl.get("glyph")("player",114234) == true) or ProbablyEngine.dsl.get("behind")("target") == true then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("rkfil",function() --Rake Filler
	if ProbablyEngine.dsl.get("ttd")("target") > 3 
		and ProbablyEngine.dsl.get("crkd")()*((ProbablyEngine.dsl.get("rkr")() / 3 ) + 1 ) - ProbablyEngine.dsl.get("rkd")()*(ProbablyEngine.dsl.get("rkr")()/3) > ProbablyEngine.dsl.get("mgld")() 
	then
		return true
	else
		return false
	end
end)

ProbablyEngine.condition.register("rerk",function() --Rake Override
	if ProbablyEngine.dsl.get("ttd")("target") - ProbablyEngine.dsl.get("rkr")() > 3 
		and (ProbablyEngine.dsl.get("rkp")() > 108 or (ProbablyEngine.dsl.get("rkr")() < 3 and ProbablyEngine.dsl.get("rkp")() >= 75))
	then
		return true
	else 
		return false
	end
end)
