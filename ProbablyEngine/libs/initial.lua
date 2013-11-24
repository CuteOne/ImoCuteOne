-- Initialize tables
if not cute then cute = {} end

-- Data File Functions
-- cute.ttd(cute.t())
 --cute.GroupInfo()
 --cute.behind()
-- --cute.SymMem()
--cute.dummy()
--cute.timecheck()


-- cute.SpellList = {  
-- ------ABILITIES-------
-- af	=	1066,	--Aquatic Form
-- bar	=	22812,	--Barkskin
-- bf	=	5487,	--Bear Form
-- ber	=	106951,	--Berserk
-- cf 	= 	768,	--Cat Form
-- cy	=	33786,	--Cyclone
-- dsh	=	1850,	--Dash
-- er	=	339,	--Entangling Roots
-- ff	=	770,	--Faerie Fire
-- fb	=	22568,	--Ferocious Bite
-- fr	=	22842,	--Frenzied Regeneration
-- grl	=	6795,	--Growl
-- ht	=	5185,	--Healing Touch
-- hib	=	2637,	--Hibernate
-- hur	=	16914,	--Hurricane
-- inn	=	29166,	--Innervate
-- lac =	33745,	--Lacerate
-- ma	=	22570,	--Maim
-- mgl	=	33876,	--Mangle
-- mbf	=	33878,	--Mangle: Bear Form
-- mow	=	1126,	--Mark of the Wild
-- ml	=	6807,	--Maul
-- mu	=	106922,	--Might of Ursoc
-- mf	=	8921,	--Moonfire
-- ng	=	16689,	--Nature's Grasp
-- pnc	=	9005,	--Pounce
-- prl	=	5215,	--Prowl
-- rk	=	1822,	--Rake
-- rvf =	102545,	--Ravage!
-- rvg	=	6785,	--Ravage
-- rb	=	20484,	--Rebirth
-- rej	=	774,	--Rejuvenation
-- rc	=	2782,	--Remove Corruption
-- rv	=	50769,	--Revive
-- rp	=	1079,	--Rip
-- sr	=	52610,	--Savage Roar
-- shr	=	5221,	--Shred
-- sb	=	80965,	--Skull Bash
-- sth	=	2908,	--Soothe
-- str	=	77764,	--Stampeding Roar
-- si	=	61336,	--Survival Instincts
-- sff	=	40120,	--Swift Flight Form
-- sw	=	62078,	--Swipe
-- swb	=	779,	--Swipe: Bear Form
-- sym	=	110309,	--Symbiosis
-- thr	=	106830,	--Thrash
-- thb	=	77758,	--Thrash: Bear Form
-- tf	=	5217,	--Tiger's Fury
-- tq	=	740,	--Tranquility
-- trf	=	783,	--Travel Form
-- wth =	5176,	--Wrath

-- ------Talents------
-- inc	=	106731,	--Incarnation: King of the Jungle
-- fon	=	106737,	--Force of Nature
-- how	=	108288,	--Heart of the Wild
-- mb	=	5211,	--Mighty Bash
-- nv	=	124974,	--Nature's Vigil
-- ty	=	132469,	--Typhoon

-- ------Racials------
-- rber =	26297,	--Troll Racial - Berserking	

-- ------PROCS------
-- ps	= 	69369,	--Predatory Swiftness
-- wa	= 	113746,	--Weakened Armor - Faerie Fire Debuff
-- cc 	= 	135700,	--Clearcasting
-- dcd	=	145152,	--Dream of Cenarius Damage Buff
-- srf =	114236,	--Shred Glyph
-- inb = 	102543,	--Incarnation: King of the Jungle buff
-- ro1	=	139121,	--Rune of Re-Origination: Haste
-- ro2	=	139117,	--Rune of Re-Origination: Critical Strike
-- ro3	=	139120,	--Rune of Re-Origination: Mastery
-- frf =	144865,	--Feral Fury
-- spd	=	81022,	--Stampede

-- -----SYMBIOSIS SPELLS------
-- symdk	=	122282,	--Death Coil
-- symhtr	=	110597,	--Play Dead
-- symmag	=	110693,	--Frost Nova
-- symmon	=	126449,	--Clash
-- sympal	=	110700,	--Divine Shield
-- sympri	=	110715,	--Dispersion
-- symrog	=	110730,	--Redirect
-- symsha	=	110807,	--Feral Spirit
-- symloc	=	110810,	--Soul Swap
-- symwar	=	112997,	--Shattering Blow
-- }

------BUFF/DEBUFF TRACKING------
-- Damage Formulas	
function cute.dcb() 		--Dream of Cenarius Damage Modifier
	if select(4,cute.ubid(cute.p(),145152)) == nil then
		return 1
	else 
		return 1.3
	end
end

function cute.mgld() 		--Potential Mangle Damage
	return (((((select(1, UnitDamage(cute.p())) + select(2, UnitDamage(cute.p())))/2)/2)*5)+(390*select(7,UnitDamage(cute.p()))))*cute.dcb()
end

function cute.crkd() 		--Potential Rake Dot Damage
	return ((118 + (0.368 * UnitAttackPower(cute.p()))) * (1 + GetMasteryEffect() / 100) * 0.8154868 * select(7, UnitDamage(cute.p())))*cute.dcb()
	--return floor((99 + (0.3*UnitAttackPower(cute.p())))*(1+(GetMasteryEffect()/100))*select(7, UnitDamage('player')))*cute.dcb()
end

function cute.rkd() 		--Active Rake Dot Damage
	if cute.nDbDmg(cute.t(),1822,cute.p())~=nil then
		return cute.nDbDmg(cute.t(),1822,cute.p())
	else
		return 1
	end
end

function cute.rkp() 		--Percent Potential Rake Dot to Active Rake Dot
	return cute.round2(((cute.crkd() / cute.rkd())*100),2)
end

function cute.crpd() 		--Potential Rip Dot Damage
	return (floor(113 + 320 * cute.cp() * (1+(GetMasteryEffect()/100)) + 0.04851 * cute.cp() * UnitAttackPower(cute.p()) * (1+(GetMasteryEffect()/100)))*select(7, UnitDamage(cute.p())))*cute.dcb()
end
	
function cute.rpd() 		--Active Rip Dot Damage
	if cute.nDbDmg(cute.t(),1079,cute.p())~=nil then
		return cute.nDbDmg(cute.t(),1079,cute.p())
	else
		return 1
	end
end

function cute.rpp() 		--Percent Potential Rip Dot to Active Rip Dot 
	return cute.round2(((cute.crpd() / cute.rpd())*100),2)
end

-- Duration Tracking
function cute.rpr() 		--Rip Duration Tracking
	if cute.udbid(cute.t(),1079,cute.p()) and cute.plvl() >= 20 then
		return (select(7, cute.udbid(cute.t(),1079,cute.p())) - GetTime())
	else
		if cute.plvl() < 20 then
			return 999
		else
			return 0
		end
	end
end

function cute.rkr()			--Rake Duration Tracking
	if cute.udbid(cute.t(),1822,cute.p()) then
		return (select(7, cute.udbid(cute.t(),1822,cute.p())) - GetTime())
	else
		return 0
	end
end

function cute.srr() 		--Savage Roar Duration Tracking
	if cute.ubid(cute.p(),127538) and cute.plvl() >= 18 then
		return (select(7, cute.ubid(cute.p(),127538)) - GetTime())
	else
		if UnitLevel(cute.p()) < 18 then
			return 999
		else
			return 0
		end
	end
end

function cute.thrr()		--Trash Duration Tracking
	if cute.udbid(cute.t(),106830,cute.p()) then
		return (select(7, cute.udbid(cute.t(),106830,cute.p())) - GetTime())
	else
		return 0
	end
end

function cute.rrr() 		--Rune of Reorigination Duration Tracking
	if cute.ubid(cute.p(),139121) then
		return (select(7, cute.ubid(cute.p(),139121)) - GetTime())
	elseif cute.ubid(cute.p(),139117) then
		return (select(7, cute.ubid(cute.p(),139117)) - GetTime())
	elseif cute.ubid(cute.p(),139120) then
		return (select(7, cute.ubid(cute.p(),139120)) - GetTime())
	else
		return 0
	end
end

function cute.psr()			--Predatory Swiftness Duration Tracking
	if cute.ubid(cute.p(),69369) then
		return (select(7, cute.ubid(cute.p(),69369)) - GetTime())
	else
		return 0
	end
end

function cute.war()			-- Weakened Armor Duration Tracking
	if cute.udbid(cute.t(),113746) then
		return (select(7, cute.udbid(cute.t(),113746)) - GetTime())
	else
		return 0
	end
end

function cute.dex()			-- Assurance of Consequence Duration Tracking
	if cute.ubid(cute.p(),146308) then
		return (select(7,cute.ubid(cute.p(),146308)) - GetTime())
	else
		return 0
	end
end

function cute.rscr()		-- Renataki's Soul Charm Duration Tracking
	if cute.ubid(cute.p(), 138756) then
		return (select(7, cute.ubid(cute.p(), 138756)) - GetTime())
	else
		return 0
	end
end

-- Stack Counts
function cute.rscbuff() 	--Renataki's Soul Charm Buff Count
	if cute.ubid(cute.p(), 138756) then
		return select(4,cute.ubid(cute.p(),138737))
	else
		return 0
	end
end

function cute.wac()			--Weakened Armer Stack Count
	if cute.udbid(cute.t(),113746) then
		return select(4, cute.udbid(cute.t(),113746))	
	else
		return 0
	end
end

-- Other
function cute.srrpdiff()	--Savage Roar / Rip Tracking Comparison
	if cute.plvl() >= 20 then
		if (cute.rpr() - cute.srr()) < 0 then
			return -(cute.rpr() - cute.srr())
		else
			return (cute.rpr() - cute.srr())
		end
	else
		return 0
	end
end

function cute.bossID() 		--Target ID Check
	if cute.exists() then
		return tonumber(UnitGUID(cute.t()):sub(-13, -9), 16)
	else
		return 0
	end
end

function cute.canshr()		--Shred Check
	if ((cute.ubid(cute.p(),106951) or cute.ubid(cute.p(),5217)) and cute.GlyphCheck(114234)) or cute.behind(cute.t()) then
		return true
	else
		return false
	end
end
