if not PQR_LoadedDataFile then
	PQR_LoadedDataFile = 1
	print("|cffFF6EB4--CuteOne Data File--|cffffffff")
elseif PQR_LoadedDataFile then
	print("|cffFF6EB4--Reloading Data--|cffffffff")
end

--- Global Shorthand Commands
function shcom()
t = "target"
p = "player"
foc = "focus"
gsi = GetSpellInfo
giid = GetInventoryItemID
cast = CastSpellByName
cd = GetSpellCooldown
cp = GetComboPoints(p)
ub = UnitBuff
ubid = UnitBuffID
ua = UnitAura
udb = UnitDebuff
udbid = UnitDebuffID
pow = UnitPower(p)
repow = select(2, GetPowerRegen(p))
powmax = UnitPowerMax(p)
powper = (UnitPower(p) / UnitPowerMax(p))*100
if repow == 0 or repow==nil then
  tmp = 9999999
else
  tmp = (UnitPowerMax(p) - UnitPower(p)) * (1.0 / select(2, GetPowerRegen(p)))
end
plvl = UnitLevel(p)
sir = IsSpellInRange
incom = UnitAffectingCombat(p)==1
outcom = UnitAffectingCombat(p)~=1
if UnitHealthMax(p)==0 or UnitHealthMax(p)==nil then
  php = 0
else
  php = 100*(UnitHealth(p)/UnitHealthMax(p))
end
phmax = UnitHealthMax(p)
pchannel = select(8,UnitChannelInfo(p))
pcasting = (UnitCastingInfo(p) and select(9,UnitCastingInfo(p)))
hastar = UnitExists(t)
canattack =  UnitCanAttack(p,t)
thealth = UnitHealth(t)
tthp = UnitHealthMax(t)
if UnitHealthMax(t)==0 or UnitHealthMax(t)==nil then
  thp = 0
else
  thp = 100*(UnitHealth(t)/UnitHealthMax(t))
end
tchannel = select(8,UnitChannelInfo(t))
tcasting = (UnitCastingInfo(t) and select(9,UnitCastingInfo(t)))
if select(6,UnitCastingInfo(t))~=nil then 
	tcasttime = (select(6,UnitCastingInfo(t))/1000)-GetTime()
else
	tcasttime = 0
end
end

function PQR_UnitDistance2(var1,var2,var3,var4)
	local hasTarget1 = UnitExists('var2')
	local hasTarget2 = UnitExists('var1')
	
	if hasTarget1 and hasTarget2 then
    if not Loaded then
	    	local readyTimer = 0
	    	local targetGUID1 = "none"
	    	local targetGUID2 = "none"
	    	local endTimer = GetTime() - readyTimer
    		local minTimer = var3 or .5
    		local maxTimer = var4 or 10
       Loaded = true
    end
		
		if (endTimer > minTimer and endTimer < maxTimer) or (UnitGUID(var1) ~= "none" and UnitGUID(var1) ~= targetGUID1) or (UnitGUID(var2) ~= "none" and UnitGUID(var2) ~= targetGUID2) then
			readyTimer = 0
			targetGUID1 = "none"
			targetGUID2 = "none"
		end
		
		if readyTimer == 0 then
			distance = PQR_UnitDistance(var1,var2)
			targetGUID1 = UnitGUID(var1)
			targetGUID2 = UnitGUID(var2)
			readyTimer = GetTime()
		end
		return distance
	end
	return 0
end

-- Dummy Check
function dummy()
	dummies = {
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
	for i=1, #dummies do
		if UnitExists("target") then
			dummyID = tonumber(UnitGUID("target"):sub(-13, -9), 16)
		else
			dummyID = 0
		end
		if dummyID == dummies[i] then
			return true
		end	
	end
end

-- Rotation Timer
function timecheck()
	if sTimer == nil then
		sTimer = 0
	end
	if cTime == nil then
		cTime = 0
	end
	if UnitAffectingCombat("player") and sTimer == 0 then
		 sTimer = GetTime()
	end
	if sTimer > 0 then
		 cTime = (GetTime() - sTimer)
	end
	if not UnitAffectingCombat("player") and not UnitExists("target") then
		sTimer = 0
		cTime = 0
	end
	return cTime
end

-- Behind Check
function BehindFunc()
	if behindTimer == nil then
		behindTimer = 0
 	end
 local BehindCheck = PQR_CheckUIError(SPELL_FAILED_NOT_BEHIND)
 if BehindCheck==nil then
  BehindCheck = true
 end
 bTimer = GetTime() - behindTimer
 if BehindCheck and behindTimer == 0 then
  behindTimer = GetTime()
  behind = false
 end
 if not BehindCheck and bTimer > 0 then
  behindTimer = 0
  behind = true
 end
 if bTimer > 3 and bTimer < 10 then
  behindTimer = 0
  behind = false
 end
end

---Spell Check
check = nil
function check(spell, unit)
	unit = unit or t;
    --spell = string.format("%s",GetSpellInfo(sp))
    if UnitExists(unit) 
   		and UnitCanAttack("player", unit) == 1
   		and not UnitIsDeadOrGhost(unit)
    	and not PQR_IsOutOfSight(unit, 1)
    	--and IsSpellKnown(spell)
    	and PQR_SpellAvailable(spell)
    	--and IsPlayerSpell(spell)
    	and IsUsableSpell(spell)==1
    	and GetSpellCooldown(spell)==0
    then 
       	if SpellHasRange(spell)==1 then
           	if IsSpellInRange(GetSpellInfo(spell),unit)~=1 then
       			return false
       		else
       			return true
       		end
    	else
	   		return true
    	end
   	else 
    	return false
    end
end

--- Round
function round2(num, idp)
  mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--- Time to Die
--ttd = nil
function ttd(unit)
	unit = unit or "target";
	if thpcurr == nil then
		thpcurr = 0
	end
	if thpstart == nil then
		thpstart = 0
	end
	if timestart == nil then
		timestart = 0
	end
	if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
		if currtar ~= UnitGUID(unit) then
			priortar = currtar
			currtar = UnitGUID(unit)
		end
		if thpstart==0 and timestart==0 then
			thpstart = UnitHealth(unit)
			timestart = GetTime()
		else
			thpcurr = UnitHealth(unit)
			timecurr = GetTime()
			if thpcurr >= thpstart then
				thpstart = thpcurr
				timeToDie = 999
			else
				if ((timecurr - timestart)==0) or ((thpstart - thpcurr)==0) then
					timeToDie = 999
				else
					timeToDie = round2(thpcurr/((thpstart - thpcurr) / (timecurr - timestart)),2)
				end
			end
		end
	elseif not UnitExists(unit) or currtar ~= UnitGUID(unit) then
		currtar = 0 
		priortar = 0
		thpstart = 0
		timestart = 0
		timeToDie = 0
	end
	if timeToDie==nil then
		return 999
	else
		return timeToDie
	end
end	


------Interrupt------
Interruptable = nil
function Interruptable(unit, spell)
	if UnitExists(unit)
	and PQR_SpellAvailable(spell)
	and UnitCanAttack("player", unit) == 1 
	and not UnitIsDeadOrGhost(unit) 
	and not PQR_IsOutOfSight(unit, 1)
	and IsSpellInRange(GetSpellInfo(spell), unit) == 1 then
		if select(6,UnitCastingInfo(unit))~=nil or select(6,UnitChannelInfo(unit))~=nil then
			if (((UnitCastingInfo(unit) and select(9,UnitCastingInfo(unit)))==false	and ((select(6,UnitCastingInfo(unit))/1000)-GetTime()) < 5) 
			or ((UnitChannelInfo(unit) and select(8,UnitChannelInfo(unit)))==false)) 
		then
				return true
			else
				return false
			end
		end
	end
end

------Loss of Control------
function LossOfControl(spell)
	local eventIndex = C_LossOfControl.GetNumEvents()
	while (eventIndex > 0) do
		local _, _, text = C_LossOfControl.GetEventInfo(eventIndex)
		if text == LOSS_OF_CONTROL_DISPLAY_STUN or text == LOSS_OF_CONTROL_DISPLAY_FEAR or text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_HORROR then
			CastSpellByName(GetSpellInfo(spell))
		end
		eventIndex = eventIndex - 1
	end
	return false
end

---Buff Check
function HaveBuff(UnitID,SpellID,TimeLeft,Filter) 
  if not TimeLeft then TimeLeft = 0 end
  if type(SpellID) == "number" then SpellID = { SpellID } end 
  for i=1,#SpellID do 
local spell, rank = GetSpellInfo(SpellID[i])
if spell then
  local buff = select(7,UnitBuff(UnitID,spell,rank,Filter)) 
  if buff and ( buff == 0 or buff - GetTime() > TimeLeft ) then return true end
end
  end
end

--- Glyph Check
GlyphCheck = nil
function GlyphCheck(glyphid)
	for i=1, 6 do
		if select(4, GetGlyphSocketInfo(i)) == glyphid then
			return true
		end
	end
	return false
end

--- Talent Check
TalentCheck = nil
function TalentCheck(talentid)
	for i=1, 18 do
		if select(1,GetTalentInfo(i)) == GetSpellInfo(talentid) then
			if select(5,GetTalentInfo(i))==true then
				return true
			end
		end
	end
	return false
end

------Member Check------
function CalculateHP(t)
  incomingheals = UnitGetIncomingHeals(t) or 0
  return 100 * ( UnitHealth(t) + incomingheals ) / UnitHealthMax(t)
end

function CanHeal(t)
  if UnitInRange(t) and UnitCanCooperate("player",t) and not UnitIsEnemy("player",t) 
  and not UnitIsCharmed(t) and not UnitIsDeadOrGhost(t) and not PQR_IsOutOfSight(t) 
  then return true end 
end

function GroupInfo()
	members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }		
  	group.type = IsInRaid() and "raid" or "party" 
  	group.number = GetNumGroupMembers()
  	if group.number > 0 then
  		for i=1,group.number do 
  			if CanHeal(group.type..i) then 
				local unit, hp = group.type..i, CalculateHP(group.type..i) 
				table.insert( members,{ Unit = unit, HP = hp } ) 
				if hp < 90 then group.low = group.low + 1 end 
				if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end 
  			end 
  		end 
  		if group.type == "raid" and #members > 1 then table.remove(members,1) end 
  		table.sort(members, function(x,y) return x.HP < y.HP end)
  		local customtarget = CanHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover" 
  		if customtarget then table.sort(members, function(x) return UnitIsUnit(customtarget,x.Unit) end) end 
	end
end

-- Trick of the Trade
function TricksInfo()
  	tmembers, tgroup = { }, { } 
  	tgroup.type = IsInRaid() and "raid" or "party" 
  	tgroup.number = GetNumGroupMembers()
  	if tgroup.number > 0 then
  		for i=1,tgroup.number do 
  			if CanHeal(tgroup.type..i) and UnitGroupRolesAssigned(tgroup.type..i)~="HEALER" and UnitGroupRolesAssigned(tgroup.type..i)~="NONE" then 
				local tunit, gr = tgroup.type..i, UnitGroupRolesAssigned(tgroup.type..i) 
				table.insert( tmembers,{ Unit = tunit, Role = gr } ) 
  			end 
  		end
  		if tgroup.type == ("raid" or "party") and #tmembers > 1 then table.remove(tmembers,1) end 
  	end
end

-- Rupture Info


--Symbiosis Priority Cast
function classPrio(t)
    local class = select(3,UnitClass(t))
   
    if class == 1 then --Warrior
            return 1
    elseif class == 2 then --Paladin
            return 5
    elseif class == 3 then --Hunter
            return 8
    elseif class == 4 then --Rogue
            return 4
    elseif class == 5 then --Priest
            return 6
    elseif class == 6 then --Deathknight
            return 7
    elseif class == 7 then --Shaman
            return 2
    elseif class == 8 then --Mage
            return 9
    elseif class == 9 then --Warlock
            return 3
    elseif class == 10 then --Monk
            return 10
    elseif class == 11 then --Druid
            return 11
    end
end
 
local symIDs = {
 110478, --DK
 110479, --Hunter
 110482, --Made
 110483, --Monk
 110484, --Paladin
 110485, --Priest
 110486, --Rogue
 110488, --Shaman
 110490, --Warlock
 110491 --Warrior
}
 
function HasSymb( t )
    for i=1, #symIDs do
        local hasSym = select(15,UnitBuffID(t,symIDs[i]))
        local class = select(3,UnitClass( t ))
 
        if hasSym or class == 11 then
                return true
        else
                return false
        end
    end
end
 
function SymMem()
--	symmem, symgroup = { { Unit = "player", Prio = classPrio("Player"), Class = select(2, UnitClass("Player")),ClassID = select(3,UnitClass("Player")) } }, { low = 0, tanks = { } }
    symmem, symgroup = { {Prio = 12 } }, { low = 0, tanks = { } }
    symgroup.type = IsInRaid() and "raid" or "party"
   	symgroup.number = GetNumGroupMembers()
	if symgroup.number > 0 then   
    	for i=1,symgroup.number do
        	if CanHeal(symgroup.type..i) and not HasSymb(symgroup.type..i) then
        		local unit, prio, class, classID = symgroup.type..i, classPrio(symgroup.type..i), select(2, UnitClass(symgroup.type..i)), select(3,UnitClass(symgroup.type..i))
        		table.insert( symmem,{ Unit = unit, Prio = prio, Class = class, ClassID = classID } )
 
        		if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(symgroup.tanks,unit) end
       		end
    	end
   
    	if symgroup.type == "Raid" and #members > 1 then table.remove(symmem,1) end
    	table.sort(symmem, function(x,y) return x.Prio < y.Prio end)
  --  local customtarget = CanHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover"
  --  if customtarget then table.sort(symmem, function(x) return UnitIsUnit(customtarget,x.Unit) end) end
	end
end

--Tabled Cast Time Checking for When you Last Cast Something.
CheckCastTime = {}
Nova_CheckLastCast = nil
function Nova_CheckLastCast(spellid, ytime) -- SpellID of Spell To Check, How long of a gap are you looking for?
	if ytime > 0 then
		if #CheckCastTime > 0 then
			for i=1, #CheckCastTime do
				if CheckCastTime[i].SpellID == spellid then
					if GetTime() - CheckCastTime[i].CastTime > ytime then
						CheckCastTime[i].CastTime = GetTime()
						return true
					else
						return false
					end
				end
			end
		end
		table.insert(CheckCastTime, { SpellID = spellid, CastTime = GetTime() } )
		return true
	elseif ytime <= 0 then
		return true
	end
	return false
end

--Totem Range Check
local Blacklist = {
    120668,
    2062,
    2894

}

function totemDistance()
 if not (totemX and totemY) then
 	totemX,totemY = 0,0
 end
 for i=1, #Blacklist do
     local totemName = select(2,GetTotemInfo(1)) or select(2,GetTotemInfo(2))
     local blackList = GetSpellInfo(Blacklist[i])
 
     if totemX ~= (0 or nil) and totemY ~= (0 or nil) and totemName ~= blackList then
         local a,b,c,d,e,f,g,h,i,j = GetAreaMapInfo(GetCurrentMapAreaID())
         local a1 , b1 = GetPlayerMapPosition("Player")
         local x1 , y1 = a1 * 1000, b1 * 1000
         local a2 , b2 = totemX, totemY
         local x2 , y2 = a2 * 1000, b2 * 1000
         local w = (d - e)
         local h1 = (f - g)
         local distance = sqrt(min(x1 - x2, w - (x1 - x2))^2 + min(y1 - y2, h1 - (y1-y2))^2)
         
         return round2(distance,2)
     else
         return 0
     end
 end
end

-- Dispel Check
 function ValidDispel(t)
  	local HasValidDispel = false
  	local i = 1
  	local debuff = UnitDebuff(t, i)
  	while debuff do
  		local debuffType = select(5, UnitDebuff(t, i))
  		local debuffid = select(11, UnitDebuff(t, i)) 
  		local PQ_Class = select(2, UnitClass(t)) 	
  		local ValidDebuffType = false	
		if PQ_Class == "DRUID" then  			
  			if debuffType == "Poison" or debuffType == "Curse" then
  				ValidDebuffType = true
  			--elseif PQR_SpellAvailable(122288) and debuffType == "Disease" then --Cleanse from Paladin Symbiosis
  				--ValidDebuffType = true
  			end
  		end
  		if PQ_Class == "MONK" then
  			if debuffType == "Poison" or debuffType == "Disease" then
  				ValidDebuffType = true
  			end
  		end		
  		
  		if ValidDebuffType
  		and debuffid ~= 138732 --Ionization from Jin'rokh the Breaker - ptr
		and debuffid ~= 138733 --Ionization from Jin'rokh the Breaker - live
		then
  			HasValidDispel = true
  		end
  		i = i + 1
  		debuff = UnitDebuff(t, i)
  	end
	return HasValidDispel
end

--Line of Sight Check
if not tLOS then tLOS={} end
if not fLOS then fLOS=CreateFrame("Frame") end

function LineOfSight(target)
	local updateRate=3
	--local x1, y1 = PQR_UnitInfo(target)
	fLOS:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	function fLOSOnEvent(self,event,...)
		if event=="COMBAT_LOG_EVENT_UNFILTERED" then
			local cLOG={...}			
			if cLOG and cLOG[2] and cLOG[2]=="SPELL_CAST_FAILED" then
				local player=UnitGUID("player") or ""
				if cLOG[4] and cLOG[4]==player then 
					if cLOG[15] then
						if cLOG[15]==SPELL_FAILED_LINE_OF_SIGHT 
						or cLOG[15]==SPELL_FAILED_NOT_INFRONT 
						or cLOG[15]==SPELL_FAILED_OUT_OF_RANGE 
						or cLOG[15]==SPELL_FAILED_UNIT_NOT_INFRONT 
						or cLOG[15]==SPELL_FAILED_UNIT_NOT_BEHIND 
						or cLOG[15]==SPELL_FAILED_NOT_BEHIND 
						or cLOG[15]==SPELL_FAILED_MOVING 
						or cLOG[15]==SPELL_FAILED_IMMUNE 
						or cLOG[15]==SPELL_FAILED_FLEEING 
						or cLOG[15]==SPELL_FAILED_BAD_TARGETS 
						--or cLOG[15]==SPELL_FAILED_NO_MOUNTS_ALLOWED 
						or cLOG[15]==SPELL_FAILED_STUNNED 
						or cLOG[15]==SPELL_FAILED_SILENCED 
						or cLOG[15]==SPELL_FAILED_NOT_IN_CONTROL 
						--or cLOG[15]==Your vision of the target is obscured?
						then						
							--tinsert(tLOS,{unit=target,time=GetTime(),x=x1,y=y1})
							tinsert(tLOS,{unit=target,time=GetTime()})
						end
					end
				end
			else				
				if #tLOS > 0 then
					table.sort(tLOS,function(x,y) return x.time>y.time end)
					for i=1,#tLOS do
						local time=tLOS[i].time or GetTime()
						if GetTime()>time+updateRate then
							tremove(tLOS,i)
						end
					end
				end
			end
		end
	end
	fLOS:SetScript("OnEvent",fLOSOnEvent)
	if #tLOS > 0 then
		for i=1,#tLOS do
			if tLOS and tLOS[i] and tLOS[i].unit==target 
			--and (tLOS[i].x - 5) <= x1 and (tLOS[i].x + 5) >= x1 and (tLOS[i].y - 5) <= y1 and (tLOS[i].y + 5) >= y1  
			then
				--PQR_WriteToChat("\124cFFFF55FFLoS Name: "..UnitName(target)) 
				return true
			end
		end
	end
end

-- Healing Potions
HealPots = {
		76097,	-- Master Healing Potion
        80040,	--Endless Master Healing Potion
        63144,	--Baradin's Wardens Healing Potion
        64994,	--Hellscream's Reach Healing Potion
        57193,	--Mighty Rejuvenation Potion
        57191,	--Mythical Healing Potion
        63300,	--Rogue's Draught
        67145,	--Draught of War
        33447,	--Runic Healing Potion
        40077,	--Crazy Alchemist's Potion
        40081,	--Potion of Nightmares
        40087,	--Powerful Rejuvenation Potion
        41166,	--Runic Healing Injector
        43569,	--Endless Healing Potion
        22850,	--Super Rejuvenation Potion
        34440,	--Mad Alchemist's Potion
        39671,	--Resurgent Healing Potion
        31838,	--Major Combat Healing Potion
        31839,	--Major Combat Healing Potion
        31852,	--Major Combat Healing Potion
        31853,	--Major Combat Healing Potion
        32784,	--Red Ogre Brew
        32910,	--Red Ogre Brew Special
        31676,	--Fel Regeneration Potion
        23822,	--Healing Potion Injector
        33092,	--Healing Potion Injector
        22829,	--Super Healing Potion
        32763,	--Rulkster's Secret Sauce
        32904,	--Cenarion Healing Salve
        32905,	--Bottled Nethergon Vapor
        32947,	--Auchenai Healing Potion
        39327,	--Noth's Special Brew
        43531,	--Argent Healing Potion
        18253,	--Major Rejuvenation Potion
        28100,	--Volatile Healing Potion
        33934,	--Crystal Healing Potion
        13446,	--Major Healing Potion
        17384,	--Major Healing Draught
        3928,	--Superior Healing Potion
        9144,	--Wildvine Potion
        12190,	--Dreamless Sleep Potion
        17349,	--Superior Healing Draught
        18839,	--Combat Healing Potion
        1710,	--Greater Healing Potion
        929,		--Healing Potion
        4596,	--Discolored Healing Potion
        858,	--Lesser Healing Potion
        118 	--Minor Healing Potion
}   

function CanHealPot()
	for i=1, #HealPots do
		if GetItemCount(HealPots[i],false,false) > 0 and (select(2,GetItemCooldown(HealPots[i]))==0) then
			drinkme = HealPots[i]
			return true
		end
	end
end
  
------Boss Check------
PQ_BossUnits = {
	-- Cataclysm Dungeons --
	-- Abyssal Maw: Throne of the Tides
	40586,		-- Lady Naz'jar
	40765,		-- Commander Ulthok
	40825,		-- Erunak Stonespeaker
	40788,		-- Mindbender Ghur'sha
	42172,		-- Ozumat
	-- Blackrock Caverns
	39665,		-- Rom'ogg Bonecrusher
	39679,		-- Corla, Herald of Twilight
	39698,		-- Karsh Steelbender
	39700,		-- Beauty
	39705,		-- Ascendant Lord Obsidius
	-- The Stonecore
	43438,		-- Corborus
	43214,		-- Slabhide
	42188,		-- Ozruk
	42333,		-- High Priestess Azil
	-- The Vortex Pinnacle
	43878,		-- Grand Vizier Ertan
	43873,		-- Altairus
	43875,		-- Asaad
	-- Grim Batol
	39625,		-- General Umbriss
	40177,		-- Forgemaster Throngus
	40319,		-- Drahga Shadowburner
	40484,		-- Erudax
	-- Halls of Origination
	39425,		-- Temple Guardian Anhuur
	39428,		-- Earthrager Ptah
	39788,		-- Anraphet
	39587,		-- Isiset
	39731,		-- Ammunae
	39732,		-- Setesh
	39378,		-- Rajh
	-- Lost City of the Tol'vir
	44577,		-- General Husam
	43612,		-- High Prophet Barim
	43614,		-- Lockmaw
	49045,		-- Augh
	44819,		-- Siamat
	-- Zul'Aman
	23574,		-- Akil'zon
	23576,		-- Nalorakk
	23578,		-- Jan'alai
	23577,		-- Halazzi
	24239,		-- Hex Lord Malacrass
	23863,		-- Daakara
	-- Zul'Gurub
	52155,		-- High Priest Venoxis
	52151,		-- Bloodlord Mandokir
	52271,		-- Edge of Madness
	52059,		-- High Priestess Kilnara
	52053,		-- Zanzil
	52148,		-- Jin'do the Godbreaker
	-- End Time
	54431,		-- Echo of Baine
	54445,		-- Echo of Jaina
	54123,		-- Echo of Sylvanas
	54544,		-- Echo of Tyrande
	54432,		-- Murozond
	-- Hour of Twilight
	54590,		-- Arcurion
	54968,		-- Asira Dawnslayer
	54938,		-- Archbishop Benedictus
	-- Well of Eternity
	55085,		-- Peroth'arn
	54853,		-- Queen Azshara
	54969,		-- Mannoroth
	55419,		-- Captain Varo'then
	
	-- Mists of Pandaria Dungeons --
	-- Scarlet Halls
	59303,		-- Houndmaster Braun
	58632,		-- Armsmaster Harlan
	59150,		-- Flameweaver Koegler
	-- Scarlet Monastery
	59789,		-- Thalnos the Soulrender
	59223,		-- Brother Korloff
	3977,		-- High Inquisitor Whitemane
	60040,		-- Commander Durand
	-- Scholomance
	58633,		-- Instructor Chillheart
	59184,		-- Jandice Barov
	59153,		-- Rattlegore
	58722,		-- Lilian Voss
	58791,		-- Lilian's Soul
	59080,		-- Darkmaster Gandling
	-- Stormstout Brewery
	56637,		-- Ook-Ook
	56717,		-- Hoptallus
	59479,		-- Yan-Zhu the Uncasked
	-- Tempe of the Jade Serpent
	56448,		-- Wise Mari
	56843,		-- Lorewalker Stonestep
	59051,		-- Strife
	59726,		-- Peril
	58826,		-- Zao Sunseeker
	56732,		-- Liu Flameheart
	56762,		-- Yu'lon
	56439,		-- Sha of Doubt
	-- Mogu'shan Palace
	61444,		-- Ming the Cunning
	61442,		-- Kuai the Brute
	61445,		-- Haiyan the Unstoppable
	61243,		-- Gekkan
	61398,		-- Xin the Weaponmaster
	-- Shado-Pan Monastery
	56747,		-- Gu Cloudstrike
	56541,		-- Master Snowdrift
	56719,		-- Sha of Violence
	56884,		-- Taran Zhu
	-- Gate of the Setting Sun
	56906,		-- Saboteur Kip'tilak
	56589,		-- Striker Ga'dok
	56636,		-- Commander Ri'mok
	56877,		-- Raigonn
	-- Siege of Niuzao Temple
	61567,		-- Vizier Jin'bak
	61634,		-- Commander Vo'jak
	61485,		-- General Pa'valak
	62205,		-- Wing Leader Ner'onok

	-- Training Dummies --
	46647,		-- Level 85 Training Dummy
	67127		-- Level 90 Training Dummy
}

SpecialUnit = nil
function SpecialUnit()
	local PQ_BossUnits = PQ_BossUnits
	
	if UnitExists("target") then
		local npcID = tonumber(UnitGUID("target"):sub(6,10), 16)
		
		if UnitLevel("target") == -1 then return true else
			for i=1,#PQ_BossUnits do
				if PQ_BossUnits[i] == npcID then return true end
			end
			return false
		end
	else return false end
end

-- Switch
CD_BossOnly = 1
CD_Auto = 2
PQ_CD = CD_BossOnly
PQ_CDTimer = 0
PP_Auto = 1
PP_Only = 2
PQ_PP = PP_Auto
PQ_PPTimer = 0
PQ_AOE = false
PQ_AOETimer = 0
PQ_Sym = false
PQ_SymTimer = 0
custTars = {"target","focus"}

-- Dem Bleeds
-- In a run once environment we shall create the Tooltip that we will be reading
-- all of the spell details from
nGTT = CreateFrame( "GameTooltip", "MyScanningTooltip", nil, "GameTooltipTemplate" ); -- Tooltip name cannot be nil
nGTT:SetOwner( WorldFrame, "ANCHOR_NONE" );
-- Allow tooltip SetX() methods to dynamically add new lines based on these
nGTT:AddFontStrings(
   nGTT:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
   nGTT:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" ) );
nDbDmg = nil
--print(issecure()) -- before function is ran, but after TT is created
function nDbDmg(tar, spellID, player)
   if GetCVar("DotDamage") == nil then
      RegisterCVar("DotDamage", 0)
   end
   nGTT:ClearLines()
   for i=1, 40 do
      if UnitDebuff(tar, i, player) == GetSpellInfo(spellID) then
         nGTT:SetUnitDebuff(tar, i, player)
         scanText=_G["MyScanningTooltipTextLeft2"]:GetText()
         local DoTDamage = scanText:match("([0-9]+%.?[0-9]*)")
		 if not issecure() then print(issecure()) end -- function is called inside the profile
         SetCVar("DotDamage", tonumber(DoTDamage))
         return tonumber(GetCVar("DotDamage"))
      end
   end
end
