-- PQR_PQI.lua
-- V2.22
-- ~~| Ini |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print("Loading PQI")
_G['PQI'] = {}
local PQI = _G['PQI']
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local print, type, select, tostring, tonumber						= print, type, select, tostring, tonumber
local ipairs, pairs	 														= ipairs, pairs
local table_remove, table_concat 										= table.remove, table.concat
local gsub, sub, format, match, lower									= string.gsub, string.sub, string.format, string.match, string.lower
local floor, ceil, min, max, modf										= math.floor, math.ceil, math.min, math.max, math.modf
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local GetSpellInfo, GetTime  														= GetSpellInfo, GetTime
local UnitExists, UnitGUID, UnitLevel											= UnitExists, UnitGUID, UnitLevel 
local IsLeftShiftKeyDown, IsRightShiftKeyDown, IsLeftAltKeyDown		= IsLeftShiftKeyDown, IsRightShiftKeyDown, IsLeftAltKeyDown
local IsRightAltKeyDown, IsLeftControlKeyDown, IsRightControlKeyDown = IsRightAltKeyDown, IsLeftControlKeyDown, IsRightControlKeyDown
local GetSpecialization, GetSpecializationInfo								= GetSpecialization, GetSpecializationInfo
local GetCVar, SetCVar																= GetCVar, SetCVar
-- ~~| Constants |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RegisterCVar('PQI_AddRotation','')	
local DEBUG = false
local CVAR_RVBUFFER = 10
local UPDATE_THROTTLE = .3
local COLORS = {
	green 	= '|cff00ff00',
	yellow 	= '|cffffff00',	
	blue	 	= '|cff00aaff',	 	
	orange	= '|cffffaa00',	
}
local BOSS_UNITS = {
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
	3977,			-- High Inquisitor Whitemane
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
	67127			-- Level 90 Training Dummy
}
local KEY_VALUES = {
  ls = 1,
  lc = 2,
  la = 4,
  rs = 8,
  rc = 16, 
  ra = 32, 
}


-- ~~| Private functions |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
do	-- Serializer ---------------------------	
	local lua_keywords = { 
		["and"] = true,    ["break"] = true,  ["do"] = true,
		["else"] = true,   ["elseif"] = true, ["end"] = true,
		["false"] = true,  ["for"] = true,    ["function"] = true,
		["if"] = true,     ["in"] = true,     ["local"] = true,
		["nil"] = true,    ["not"] = true,    ["or"] = true,
		["repeat"] = true, ["return"] = true, ["then"] = true,
		["true"] = true,   ["until"] = true,  ["while"] = true
	}
	local t = {
		[tostring(1/0)] = "1/0";
		[tostring(-1/0)] = "-1/0";
		[tostring(0/0)] = "0/0";
	}	
	local function serialize_number(number)
		-- no argument checking - called very often
		local text = ("%.17g"):format(number)
		-- on the same platform tostring() and string.format()
		-- return the same results for 1/0, -1/0, 0/0
		-- so we don't need separate substitution table
		return t[text] or text
	end
	local function impl(t, cat, visited)
	local t_type = type(t)
	if t_type == "table" then
		if not visited[t] then
			visited[t] = true

			cat("{")
			-- Serialize numeric indices
			local next_i = 0
			for i, v in ipairs(t) do 
				if i > 1 then -- TODO: Move condition out of the loop
					cat(",")
				end
				impl(v, cat, visited)
				next_i = i
			end
			next_i = next_i + 1
			-- Serialize hash part
			-- Skipping comma only at first element iff there is no numeric part.
			local need_comma = (next_i > 1)
			for k, v in pairs(t) do
				local k_type = type(k)
				if k_type == "string" then
					if need_comma then
						cat(",")
					end
					need_comma = true
					-- TODO: Need "%q" analogue, which would put quotes
					--       only iff string does not match regexp below
					if not lua_keywords[k] and match(k, "^[%a_][%a%d_]*$") then
						cat(k) cat("=")
					else
						cat(format("[%q]=", k))
					end
					impl(v, cat, visited)
				else
					if
					k_type ~= "number" or -- non-string non-number
					k >= next_i or k < 1 or -- integer key in hash part of the table
					k % 1 ~= 0 -- non-integer key
					then
						if need_comma then
							cat(",")
						end
						need_comma = true

						cat("[")
						impl(k, cat, visited)
						cat("]=")
						impl(v, cat, visited)
					end
				end
			end
			cat("}")
			visited[t] = nil
		else
			-- this loses information on recursive tables
			cat('"table (recursive)"')
		end
		elseif t_type == "number" then
			cat(serialize_number(t))
		elseif t_type == "boolean" then
			cat(tostring(t))
		elseif t == nil then
			cat("nil")
		else
			-- this converts non-serializable (functions) types to strings
			cat(format("%q", tostring(t)))
		end
	end
	local function tstr_cat(cat, t)
		impl(t, cat, {})
	end
	PQI.implode = impl	
end 
-- ~~ Variable Printer ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function valueCompare(v1,v2)
	if type(v1) ~= 'table' or type(v2) ~='table' then
		if v1 == v2 then return true else return false end
	end		
	return table_concat(v1) == table_concat(v2)	
end
local function tprint(t)
	local ts = format('%s{ ',COLORS.orange)
	for i=1,#t do
		if type(t[i]) =='string' then
			ts = format('%s%s"%s"%s%s',ts,COLORS.green,t[i],COLORS.orange,t[i+1] and ',' or ' ')
		elseif type(t[i]) =='number' then 
			ts = format('%s%s%s%s%s',ts,COLORS.yellow,t[i],COLORS.orange,t[i+1] and ',' or ' ')		
		end		
	end	
	return format('%s%s}',ts,COLORS.orange)
end
local function printVariable(var, value, PQI_VarDebug)
	--[1] = 'Disabled', [2] = 'variable changes', [3] = 'All Updates' 
	if PQI_VarDebug == '1' then return true end
	if PQI_VarDebug == '2' then if valueCompare(_G[var],value) then return end 
	elseif PQI_VarDebug ~= '3' then return end	
	
	if type(value) =='boolean' then 
		PQI:Print(format('%s |cffffaa00= %s%s',var,COLORS.blue,tostring(value)))	
	elseif type(value) =='table' then		
		PQI:Print(format('%s |cffffaa00= %s',var,tprint(value)))		 		
	elseif type(value) =='string' then
		PQI:Print(format('%s |cffffaa00= %s"%s"',var,COLORS.green,value ))
	elseif type(value) =='number' then 
		PQI:Print(format('%s |cffffaa00= %s%s',var,COLORS.yellow,value ))
	else	-- nil		 
		--PQI:Print(format('%s |cffffaa00= %s%s',var,value or keyword,value or 'nil'))	
	end
end
-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function updateRotationVariables(serialData)				
	local rotation = PQI:Deserialize(serialData)		 
	local PQI_VarDebug = GetCVar('PQI_VarDebug')		
	
	for i=1,#rotation.abilities do		
		printVariable(rotation.abilities[i].id..'_enable',rotation.abilities[i].enable,PQI_VarDebug )
		printVariable(rotation.abilities[i].id..'_boss',rotation.abilities[i].boss,PQI_VarDebug )  	
		printVariable(rotation.abilities[i].id..'_value',rotation.abilities[i].value,PQI_VarDebug)				
		_G[rotation.abilities[i].id..'_enable'] = rotation.abilities[i].enable			
		_G[rotation.abilities[i].id..'_boss'] = rotation.abilities[i].boss
		_G[rotation.abilities[i].id..'_value'] = rotation.abilities[i].value			
	end
	for i=1,#rotation.hotkeys do	
		printVariable(rotation.hotkeys[i].id..'_enable',rotation.hotkeys[i].enable,PQI_VarDebug) 
		printVariable(rotation.hotkeys[i].id..'_key',rotation.hotkeys[i].keys,PQI_VarDebug)		
		_G[rotation.hotkeys[i].id..'_enable'] = rotation.hotkeys[i].enable
		_G[rotation.hotkeys[i].id..'_key'] = rotation.hotkeys[i].keys			
	end		
end
do -- OnUpdate -----------------------------
	local throttle 	= UPDATE_THROTTLE
	local lastUpdate	= 0
	local onUpdateFrame = CreateFrame('Frame',nil,UIParent)
	onUpdateFrame:SetScript('OnUpdate',function(this,elapsed)
		lastUpdate = lastUpdate + elapsed;
		while (lastUpdate > throttle) do
---------------- update ------------------------------------------------------
			if not GetCVar('PQInterface_Update') then return end
			--Listen for PQInterface Config Updates
			for buffer = 1, CVAR_RVBUFFER do		 		
				if GetCVar('PQI_RVUpdate'..buffer) and GetCVar('PQI_RVUpdate'..buffer) ~= '' then
					 updateRotationVariables(GetCVar('PQI_RVUpdate'..buffer))
					 SetCVar('PQI_RVUpdate'..buffer,'')
				end			
			end	
------------------------------------------------------------------------------			
			lastUpdate = lastUpdate - elapsed
		end
	end)
end 
-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function rotationAddError(config,section,name,helper)
	if not name then print(format("|cffff0000<PQInterface Error> |cff00a8ffConfig:|cffffff00%s|cffff0000 %s",config,section))
	else
		print(format("|cffff0000<PQInterface Error> |cff00a8ffConfig:|cffffff00%s|cff00a8ff %s:|cffffff00%s|cffff0000 %s",config,section,name,helper))
	end
end
local function tableLength(t)
	local count = 0
	for _ in pairs(t) do count = count + 1 end
  	return count
end		
-- ~~| PQR DEV API |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Caller(level)
	local match, _, file, line, func
	for trace in debugstack(level,1, 0):gmatch("(.-)\n") do
		--print(trace)		
		match, _, file, line, func = trace:find('^.-%[string "(.-)..."%]:(%d+):.-`(.*)$')
		if not match then 
			match, _, file, line = trace:find('^.-%[string "(.-)..."%]:(%d+):.-$')			
		end
		if match then			
			if file =='-- PQR_PQI.lua --' then file ='PQR_PQI.lua' end
			return file, line 
		end
	end
	return 'Unknown Caller:',''
end
function PQI.P(...)
	local file, line = Caller(3)
	local caller = format("|cfffd7fff[%s: %s] ",file,line) 
	
	local white
	--_D.P((select(1, ...)))
	txt = format("|cff00aaff %s|r ",tostring(select(1, ...)or nil))
	for i = 2, select('#', ...) do		
		if white then
			txt = txt..format("|cff00aaff %s|r ",tostring(select(i, ...) or nil))				
		else
			txt = txt..tostring(select(i, ...))							
		end
		white = not white
	end
	print(format(caller.."|r %s",txt))
end
-- ~~| PQI API |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function PQI:Print(s,...)
	-- weakauras doing an unsecure hook to chatframe1, use print!
	if not s then return end
	print(format("|cff00ffff<|cff00aaff%s|cff00ffff>|r %s",'PQInterface',s))
	return self:Print(...)
end
function PQI:Error(s,...)
	
	if not s then return end	
	print(format("|cffff0000<PQInterface Error> %s",s))
	return self:Error(...)
end
function PQI:IsBoss(check)
	if not check then return false end
	if not UnitExists("target") then return false end
	if UnitLevel("target") == -1 then return true end
	for i=1,#BOSS_UNITS do
		if BOSS_UNITS[i] == tonumber(UnitGUID("target"):sub(-13, -9), 16) then return true end
	end
	return false
end 
function PQI:IsHotkeys(hotKeyTable)
if not hotKeyTable then return false end
	local keyTotal 		= 0
	local hotKeyTotal 	= 0
	if IsLeftShiftKeyDown()		then keyTotal = keyTotal + 1 	end
	if IsLeftControlKeyDown()	then keyTotal = keyTotal + 2 	end
	if IsLeftAltKeyDown() 		then keyTotal = keyTotal + 4 	end
	if IsRightShiftKeyDown()	then keyTotal = keyTotal + 8 	end
	if IsRightControlKeyDown()	then keyTotal = keyTotal + 16 end
	if IsRightAltKeyDown() 		then keyTotal = keyTotal + 32 end
		
	for h=1, #hotKeyTable do hotKeyTotal = hotKeyTotal + KEY_VALUES[hotKeyTable[h]] end	
	
	if hotKeyTotal == 0 then return true end
	return keyTotal == hotKeyTotal	
end 
function PQI:IsSpec(spec)
	local currentSpec = GetSpecialization()	
	return currentSpec and select(2, GetSpecializationInfo(currentSpec)) == spec or false
end
function PQI:Serialize(t)
	local buf = {}
	local cat = function(v) buf[#buf + 1] = v end
	PQI.implode(t, cat, {})
	return 'return '..table_concat(buf)
end
function PQI:Deserialize(s)
	local func,err = loadstring(s)
	if err then ADDON:Error(err) end
	return func()
end
function PQI:AddRotation(rotation)
	
	rotation.abilityCount 	= rotation.abilities and #rotation.abilities 	or 0 
	rotation.hotkeyCount 	= rotation.hotkeys   and #rotation.hotkeys 		or 0 	
	-------- Configuration Helper -------------------------
	
	if type(rotation) ~='table' 	then PQI:Error('Config is required to be a Table?!.') return end	
	if not rotation.name 			then PQI:Error('Config Requires a Name.') return end	
	if not rotation.author 			then rotationAddError(rotation.name,' Requires an Author.') return end	
	for i=1, rotation.abilityCount do
		local ability = rotation.abilities[i]
		if not ability.name 							then rotationAddError(rotation.name,'Ability',i,' Requires a name') return end				
		if type(ability.enable) ~='boolean' 	then rotationAddError(rotation.name,'Ability',ability.name,'Missing required option ( enable = true|false )')  return end
		if ability.widget then
			if type(ability.widget) ~='table'	then rotationAddError(rotation.name,'Ability',ability.name,'The widget field is required to be a table ie.( widget = {type="numbox",value=10}') return end
			if not ability.widget.type 			then rotationAddError(rotation.name,'Ability',ability.name,'Widget requires a type ( type = "txtbox"|"select"|"numbox"') return end
			ability.widget.type = string.lower(ability.widget.type)			
			if ability.widget.type ~= 'txtbox' and ability.widget.type ~= 'select'
			and ability.widget.type ~= 'numbox'	then rotationAddError(rotation.name,'Ability',ability.name,'Widget type not valid. ( type = "txtbox"|"select"|"numbox" )') return end
			if ability.widget.type == 'select' then
				if not ability.widget.values or type(ability.widget.values) ~='table'
															then rotationAddError(rotation.name,'Ability',ability.name,'Requies a Selection Table ie. ( values = {"option1","option2","option3"} )') return end
				
				if tableLength(ability.widget.values) < 2	then rotationAddError(rotation.name,'Ability',ability.name,'Selection Table is required to contain atleast 2 options to be valid') return end
	 		end 		
 		end
  	end 		
	for i=1, rotation.hotkeyCount do
		local hotkey = rotation.hotkeys[i]
		if not hotkey.name 							then rotationAddError(rotation.name,'Hotkey',i,' Requires a name') return end		
		if type(	hotkey.enable ) ~='boolean' 	then rotationAddError(rotation.name,'Hotkey',hotkey.name,'Missing required option ( enable = true|false )')  return end
				
		if not hotkey.hotkeys 						then rotationAddError(rotation.name,'Hotkey',hotkey.name,'Requries a default hotkey list ie.( hotkeys = {"ls"} )') return end
		if type(hotkey.hotkeys) ~='table'		then rotationAddError(rotation.name,'Hotkey',hotkey.name,'hotkeys is required to be a table ie.( hotkeys = {"ls"} )') return end
		for i=1, #hotkey.hotkeys do
			hotkey.hotkeys[i] = string.lower(hotkey.hotkeys[i])
			if not KEY_VALUES[hotkey.hotkeys[i]] 		then rotationAddError(rotation.name,'Hotkey',hotkey.name,'Table entry "'..hotkey.hotkeys[i]..'" is invalid, valid options: ls, rs, la, ra, lc, rc') return end
		end		
	end	
	--------------------------------------------------------
	
	local name = gsub((gsub(rotation.name,'[^%w]','')),'c%x%x%x%x%x%x%x%x','')
	local author = gsub((gsub(rotation.author,'[^%w]','')),'c%x%x%x%x%x%x%x%x','')	
	rotation.id = format('PQI_%s%s',author,name)
	--- write variables with default settings incase addon isnt found and give each abilty and hotkey there own unique id
	for a=1,rotation.abilityCount do	
		local ability = rotation.abilities[a]
			ability.id = (format('%s_%s',rotation.id,gsub((gsub(ability.name,'[^%w]','')),'c%x%x%x%x%x%x%x%x','')	))			
			_G[ability.name..'_enable'] = ability.enable		
			_G[ability.name..'_boss'] = ability.boss
			_G[ability.name..'_value'] = ability.value			
		end
	for h=1,rotation.hotkeyCount do
		local hotkey = rotation.hotkeys[h]
		hotkey.id = (format('%s_%s',rotation.id,gsub((gsub(hotkey.name,'[^%w]','')),'c%x%x%x%x%x%x%x%x','')))
		_G[hotkey.name..'_enable'] = hotkey.enable			
		_G[hotkey.name..'_key'] = hotkey.keys 			
	end	
	
	SetCVar('PQI_AddRotation',PQI:Serialize(rotation))
	return true	
end