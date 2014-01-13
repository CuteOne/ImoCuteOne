-- Initialize tables
if not cute then cute = {} end

-- Convert Spell ID to Spell Name
function UnitBuffID(unit, spell, filter)
	if not unit or unit == nil or not UnitExists(unit) then 
		return false 
	end
	if spell then 
		spell = GetSpellInfo(spell) 
	else 
		return false 
	end
	if filter then 
		return UnitBuff(unit, spell, nil, filter) 
	else 
		return UnitBuff(unit, spell) 
	end
end
function UnitDebuffID(unit, spell, filter)
	if not unit or unit == nil or not UnitExists(unit) then 
		return false 
	end
	if spell then 
		spell = GetSpellInfo(spell) 
	else 
		return false 
	end
	if filter then 
		return UnitDebuff(unit, spell, nil, filter) 
	else 
		return UnitDebuff(unit, spell) 
	end
end

function round2(cutenum, cuteidp)	-- Round
  cutemult = 10^(cuteidp or 0)
  return math.floor(cutenum * cutemult + 0.5) / cutemult
end

-- Dem Bleeds
-- In a run once environment we shall create the Tooltip that we will be reading
-- all of the spell details from
nGTT = CreateFrame( "GameTooltip", "MyScanningTooltip", nil, "GameTooltipTemplate" ); -- Tooltip name cannot be nil
nGTT:SetOwner( WorldFrame, "ANCHOR_NONE" );
-- Allow tooltip SetX() methods to dynamically add new lines based on these
nGTT:AddFontStrings(
   nGTT:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
   nGTT:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" ) );
cute.nDbDmg = nil
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
		 --if not issecure() then print(issecure()) end -- function is called inside the profile
         SetCVar("DotDamage", tonumber(DoTDamage))
         return tonumber(GetCVar("DotDamage"))
      end
   end
end

-- Register library
ProbablyEngine.library.register("cute", cute)