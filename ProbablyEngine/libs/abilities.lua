-- Initialize tables
if not cute then cute = {} end

function cute.dummytest()	-- Dummy 5min DPS Test
	local cTime = cute.timecheck()
	local cDummy = cute.dummy()
	if cute.exists(cute.t()) then			
		if cTime >= 300 and cDummy then  
			return true
		else
			return false
		end
	end
end

function cute.Ber()	--Berserk
	if cute.ubid(cute.p(),768)	--Cat Form
		and cute.pow() >= 70
		and cute.ubid(cute.p(), 52610)	--Savage Roar
		and cute.ubid(cute.p(), 5217)	--Tiger's Fury
		and cute.sir(cute.gsi(33876),cute.t())
		and cute.cd(5217) > 6
		and cute.ttd(cute.t())>=18
	then
		return true
	else
		return false
	end
end

function cute.TF()	--Tiger's Fury
	if cute.combat()
		and cute.ubid(cute.p(),768)
		and cute.pow()<=35
		and cute.cd(5217)
		and cute.sir(cute.gsi(33876),cute.t())
		and not cute.ubid(cute.p(),106951)
		and not cute.ubid(cute.p(),135700)
	then
		return true
	else
		return false
	end
end

function cute.Cy() --Cyclone
	if cute.exists(cute.foc()) 
		and cute.sir(cute.gsi(33786),cute.foc())
	then
		return true
	else
		return false
	end
end

function cute.RB() --Rebirth
	if cute.exists("mouseover") 
		and UnitIsDeadOrGhost("mouseover") 
		and not cute.attack(cute.p(), "mouseover")   
		--and not cute.LineOfSight("mouseover")
		and not cute.pcasting()
		and UnitChannelInfo(cute.p())==nil
		and cute.sir(cute.gsi(20484),"mouseover") 
		and cute.ubid(cute.p(),69369)
		and cute.cd(20484)==0
	then
		return true
	else
		return false
	end
end

function cute.RV() --Revive
	if not UnitAffectingCombat(cute.p())
		and cute.exists("mouseover") 
		and UnitIsDeadOrGhost("mouseover") 
		and not cute.attack(cute.p(), "mouseover")   
		--and not cute.LineOfSight("mouseover")
		and not cute.pcasting()
		and not cute.pchannel()
		and cute.sir(cute.gsi(20484),"mouseover")
	then
		return true
	else
		return false
	end
end

function cute.FF() --Faerie Fire
	if (cute.combat() or (not cute.combat() and select(2,IsInInstance())=="none")) 
		and (cute.war()==0 or cute.wac() < 3) 
	then 
		return true
	else
		return false
	end
end

function cute.FB() --Ferocious Bite
	if cute.ubid(cute.p(), 768)
		and cute.pow() >= 25
		and not cute.HaveBuff(cute.p(), {139121,139117,139120})
		and cute.srr() > 0
	then
		if cute.thp()<=25 and ((cute.rpr() > 0 and cute.rpr()<=4) or cute.ttd(t)<=4) then
			return true
		elseif cute.rpp() < 108 and cute.rpr() > 6 and cute.cp()>=5 and cute.pow()>=50 then
			return true
		else
			return false
		end
	else
		return false
	end
end

function cute.CF() --Cat Form
	if not cute.pcasting() and not cute.pchannel() then
		if (((cute.combat() or IsOutdoors()==nil or (cute.exists(cute.t()) and not cute.ubid(cute.p(),768)))
			and not cute.ubid(cute.p(),768) 
			and not (IsMounted() or cute.ubid(cute.p(),40120)))) 
				--or (cute.exists(cute.t()) and not cute.ubid(cute.p(),768)))
		then
			return true
		else
			return false
		end
	else
		return false
	end
end

function cute.AF() --Aquatic Form
	if IsSwimming() then 
		return true
	else
		return false
	end
end

function cute.TrF() --Travel Form
	if not IsFlyableArea() 
		and IsOutdoors() 
		and not IsSwimming() 
	then
		return true
	else
		return false
	end
end

function cute.HT() --Healing Touch
	if cute.combat() 
		and cute.plvl()>=26 
		and cute.TalentCheck(145152) 
		and cute.psr() > 0 
		and not cute.ubid(cute.p(), 145152) 
		and (cute.psr() < 1.5 or cute.cp()>=4) 
	then
		return true
	else
		return false
	end
end

function cute.MA() --Maim
	if (select(2,GetInstanceInfo())=="arena" or select(2,GetInstanceInfo())=="pvp") then
		return true
	else
		return false
	end
end

-- function cute.Lac() --Lacerate
	-- cute.initial()
	-- if incom and ubid(p,bf) and cd(lac)==0 then
		-- return true
	-- else 
		-- return false
	-- end
-- end

function cute.MglOp() --Mangle: Opener
	if not SpellIsTargeting() 
		and (cute.plvl() < 54 or cute.GlyphCheck(127540)==false	or not cute.behind(cute.t())) 
		and UnitIsPVP(cute.p())==nil
		and cute.attack()  
	then
		return true
	else
		return false
	end
end

-- function cute.Mbf() --Mangle: Bear Form
	-- cute.initial()
	-- if incom and ubid(p,bf) and cd(mbf)==0 and hastar then
		-- return true
	-- else
		-- return false
	-- end
-- end

function cute.MotW() --Mark of the Wild
	cute.GroupInfo()
	if (not IsMounted() or cute.ubid(cute.p(),40120)) 
		and not cute.combat() 
		and cute.plvl()>=62 
		and not cute.ubid(cute.p(),104934) 
		and not cute.ubid(cute.p(),104269) 
	then
		for i=1,#cutemembers do 
			if not cute.HaveBuff(cutemembers[i].Unit,{115921,20217,1126,90363}) 
				and (#cutemembers==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") 
			then 
				return true 
			else
				return false
			end
		end
	else
		return false
	end
end

-- function cute.ML() --Maul
	-- cute.initial()
	-- if incom and ubid(p,bf) and cd(ml)==0 and pow>=60 then
		-- return true
	-- else
		-- return false
	-- end
-- end

function cute.Pause() --Pause
	if IsMounted()
		or SpellIsTargeting()
		or not cute.exists(cute.t())
		or cute.ubid(cute.p(),80169)
		or cute.ubid(cute.p(),87959)
		or cute.pcasting()
		or cute.pchannel()
		or UnitIsDeadOrGhost(cute.p()) 
		or UnitIsDeadOrGhost(cute.t())
		or cute.ubid(cute.t(),117961) --Impervious Shield - Qiang the Merciless
		or cute.udbid(cute.p(),135147) --Dead Zone - Iron Qon: Dam'ren
		or cute.ubid(cute.t(),143593) --Defensive Stance - General Nagrazim
		or cute.ubid(cute.t(),140296) --Conductive Shirld - Thunder Lord / Lightning Guardian
		or not cute.combat
	then 
		return true 
	else
		return false
	end
end

function cute.Pnc() --Pounce
	if not SpellIsTargeting() 
		and UnitIsPVP(cute.p()) --Code better checks for PvP Servers
		and cute.combat()
		and cute.behind(cute.t())
	then
		return true
	else
		return false
	end	
end

function cute.Prl() --Prowl
	if not cute.combat() and not IsStealthed() and cute.attack() and cute.ubid(cute.p(),768) then
		return true
	else
		return false
	end
end

function cute.RK() --Rake
	if cute.ubid(cute.p(),768) 
		and cute.sir(cute.gsi(33876),cute.t()) 
		and (cute.srr()>1 or cute.GlyphCheck(127540)==false) 
		and cute.pow()>=35 
	then
		if cute.rrr() > 0.5 
			and cute.rkr() < 9 
			and cute.rrr()<=1.5 
		then
			return true
		elseif cute.rkr() < 3 then
			return true
		elseif (cute.ttd(cute.t())-cute.rkr()) > 3 
			and (cute.crkd() > cute.rkd() or (cute.rkr() < 3 and cute.rkp()>=75)) 
		then
			return true
		else
			return false
		end
	else
		return false
	end
end

function cute.RkAoE()	--Rake AoE
	if cute.rkr() < 3 
		and cute.ttd(cute.t()) >= 15 
	then
		return true
	else
		return false
	end
end

function cute.Rvg() --Ravage: Opener
	if not SpellIsTargeting() 
		and (cute.ubid(cute.p(),81022) or IsStealthed()) 
		and cute.attack()
		and UnitIsPVP(cute.p())==nil 
		and cute.behind(cute.t())
	then
		return true
	else
		return false
	end
end

function cute.Rej() --Rejuvination
	if  not SpellIsTargeting()
		and (not cute.combat() or cute.plvl()<26) 
		and not cute.ubid(cute.p(),774) 
	then 
		return true
	else
		return false
	end
end

-- function cute.RC() --Remove Corruption
	-- cute.initial()
	-- if ValidDispel(cute.p()) and cd(rc)==0 and cp > 0 and pow>=35 and ((select(2,GetInstanceInfo())~="arena" and select(2,GetInstanceInfo())~="pvp") or outcom) then
		-- return true
	-- elseif ValidDispel("mouseover") and cd(rc)==0 then
		-- return true
	-- else
		-- return false
	-- end
-- end

function cute.RP() --Rip
	if cute.ubid(cute.p(),768) 
		and cute.pow()>=30 
		and cute.srr() > 1 
		and cute.bossID()~=63053 
		and cute.ttd(cute.t()) > 4 
	then
		if cute.cp()>=4 
			and cute.rpp()>=95 
			and cute.ttd(cute.t()) > 30 
			and cute.rrr() > 0 
			and cute.rrr()<=1.5
		then
			return true
		elseif cute.cp()>=5 
			and cute.rpr()==0
		then
			return true
		elseif cute.cp()>=5 
			and	((cute.rpr() < 6 and cute.thp() > 25) 
				or (cute.rpp() > 108 and (cute.rscbuff() == 0 or cute.rscbuff>=7)) 
			and cute.ttd(cute.t())>=15)
		then
			return true
		else
			return false
		end
	else
		return false
	end
end

function cute.SR() --Savage Roar
	if cute.ubid(cute.p(),768) then
		if cute.cp()>=1 and cute.rpr()<=3 and cute.thp()<=25 then
			return false
		else
			if not cute.ubid(cute.p(),108288) then
				if (IsStealthed() or cute.combat()) 
					and cute.attack() 
					and cute.srr()<=1 
					and cute.pow()>=25 
					and (cute.GlyphCheck(127540) or cute.cp() > 0) 
				then
					return true
				elseif	cute.combat() 
					and (cute.GlyphCheck(127540) or cute.cp() > 0) 
					and cute.rpr() > 0 
					and cute.rpr() < 10 
					and (12+(cute.cp()*6))>=(cute.srr()+12) 
					and cute.srrpdiff()<=4 
					and cute.pow()>=25 
				then
					return true
				else
					return false
				end
			else
				return false
			end
		end
	else
		return false
	end
end

function cute.FRvg() --Ravage: Filler
	if cute.ubid(cute.p(),768) 
		and cute.combat() 
		and not IsStealthed() 
		and cute.sir(cute.gsi(33876),cute.t()) 
		and cute.cp() < 5 
	then
		if (cute.ubid(cute.p(),102543) and cute.pow()>=45) 
			or cute.ubid(cute.p(),81022) 
		then
			return true
		else
			return false
		end
	else
		return false
	end
end

function cute.RkF() --Rake: Filler
	if cute.ubid(cute.p(),768) 
		and cute.combat() 
		and not IsStealthed() 
		and cute.sir(cute.gsi(33876),cute.t()) 
		and cute.cp() < 5 
	then
		if (cute.ttd(cute.t()) - cute.rkr()) > 3 
			--and ((cute.crkd() * ((cute.rkr()/3) + 1)) - (cute.rkd() * (cute.rkr()/3))) > cute.mgld()
			and ((cute.crkd() * ((cute.rkr()/3) + 1)) - (cute.rkd() * (cute.rkr()/3))) > cute.mgld()
		then
			return true
		else
			return false
		end
	else
		return false
	end
end

function cute.ShrF() --Shred: Filler (Glyph)
	if cute.ubid(cute.p(),768) 
		and cute.combat() 
		and not IsStealthed() 
		and cute.sir(cute.gsi(33876),cute.t()) 
		and cute.cp() < 5 
	then
		if cute.canshr() 
			and (cute.ubid(cute.p(),106951) or cute.ubid(cute.p(),106951) or cute.repow()>=15) 
			and cute.pow()>=45
			and not cute.ubid(cute.p(),102543)
		then
			return true
		else
			return false
		end
	else
		return false
	end
end

function cute.MglF() --Mangle: Filler
	if cute.ubid(cute.p(),768) 
		and cute.combat() 
		and not IsStealthed() 
		and cute.sir(cute.gsi(33876),cute.t()) 
		and cute.cp() < 5 
	then
		if cute.pow()>=35 
			and not cute.ubid(cute.p(),106731)
		then
			return true
		else
			return false
		end
	else
		return false
	end
end

-- function cute.SWB() --Swipe: Bear Form
	-- cute.initial()
	-- if ubid(p,bf) and incom and pow>=15 and cd(sw)==0 then
		-- return true
	-- else
		-- return false
	-- end
-- end
function cute.ThrCC()	--Thrash: Clearcasting Proc
	if cute.ubid(cute.p(),135700) then
		if cute.combat() 
			and cute.sir(cute.gsi(33876),cute.t()) 
			and cute.ubid(cute.p(),768) 
		then
			if cute.plvl()>=28 
				and cute.thrr() < 3
				and cute.ttd(cute.t())>=6
				and cute.rpr() > 3
				and cute.rkr() > 3
			then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function cute.Thr() --Thrash
	if cute.combat()
		and cute.ubid(cute.p(),768)
		and cute.plvl()>=28
		and cute.pow()>=50
		and cute.sir(cute.gsi(33876),cute.t())
		and cute.ttd(cute.t())>=6
		and (cute.bossID()~=69700 or cute.bossID()~=69701)
	then
		if cute.thrr() < 9 
			and cute.rrr() > 0 
			and cute.rrr()<=1.5 
			and cute.rpr() > 0
		then
			return true
		elseif cute.thrr()<=3 
			and cute.rpr() > 3 
			and cute.rkr() > 3
		then
			return true
		else
			return false
		end
	else
		return false
	end
end

-- function cute.ThrB() --Thrash: Bear Form
	-- cute.initial()
	-- if incom and ubid(p,bf) and cd(thb)==0 then
		-- return true
	-- else
		-- return false
	-- end
-- end

function cute.ThrAoE() --Thrash: AoE
	if cute.pow()>=50 and cute.rrr() > 0 or cute.thrr() < 3 or (cute.ubid(cute.p(),5217) and cute.thrr() < 9) then 
		return true
	else
		return false
	end
end

function cute.KotJ() --Tier 4 Talent: King of the Jungle
	if cute.ttd(cute.t())>=15 then 
		return true
	else
		return false
	end
end

function cute.FoN() --Tier 4 Talent: Force of Nature
	if (((cute.dex() > 0 and cute.dex()<=1) or cute.ubid(cute.p(),146310)) and GetSpellCharges(106737)> 0)
		or (GetSpellCharges(106737) == 3 and cute.rrr()==0 and cute.rscr()==0 and cute.Nova_CheckLastCast(106737,1))
		or (((cute.rscr() < 5 and cute.rscbuff()==10) or (cute.rrr() > 0 and cute.rrr() < 1)) and GetSpellCharges(106737) > 0)
		or (cute.ttd(cute.t()) < 20 and GetSpellCharges(106737) > 0)
	then
		return true
	else
		return false
	end
end

function cute.HotW() --Tier 6 Talent: Heart of the Wild
--	cute.initial()
--	if ubid(p,how) then
--		if check(mf) and not udbid(t,mf) then
--			cast(gsi(mf))
--		elseif check(wth) then
--			cast(gsi(wth))
--		end
--	else
		return false
--	end
end

function cute.NV() --Tier 6 Talent: Nature's Vigil
	if cute.ttd(cute.t())>=15 then 
		return true
	else
		return false
	end
end
