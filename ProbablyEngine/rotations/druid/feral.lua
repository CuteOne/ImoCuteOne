-- ProbablyEngine Rotation Packager
-- Custom Feral Combat Druid Rotation
-- Created on Nov 2nd 2013 10:35 pm

 ProbablyEngine.rotation.register_custom(103, "CuteOne - Feral", 

 {	 --In Combat

 { 'pause', cute.checkDummy },	--5 Minute Dummy Test

 
 {"/pe aoe", {	--Toggle AoE
	"modifier.rshift"
 }},
 
 {"/pe cd", {	--Toggle Cooldowns
	"modifier.rcontrol",
 }},
 
 {{				--Cat Form
	{"/cancelform /run CastSpellByID("..cf..")", { --In Shapeshift
		"player.form !=0"
	}},
	{cf, {	--Not In Shapeshift
		"player.form = 0"
	}},
 },{
		"target.exists", 
		"target.alive", 
		"target.enemy",
		"!player.buff("..cf..")",
		"player.health > 20",
		"!modifier.last("..cf..")"
 }},

 {{		--Interrupts
	{{
		{cy, {		--Cyclone: Focus Target
			"player.spell("..cy..").cooldown = 0",
			"player.level >= 78",
		}, "focus"},
		{mb, {		--Mighty Bash
			"player.spell("..mb..").cooldown = 0",	--Mighty Bash
			"player.range <= 8",
			"player.spell("..sb..").cooldown != 0",	--Skull Bash
			"player.spell("..sb..").cooldown <= 14",	--Skull Bash
			"player.level >= 75",
		}, "target"},
		{sb, {		--Skull Bash
			"player.spell("..sb..").cooldown = 0",	--Skull Bash
			"player.level >= 64",
		}, "target"},	
		{ma, {		--Maim
			"target.player",
			"player.spell("..sb..").cooldown != 0",	--Skull Bash
			"player.combopoints > 0",
			"player.power >= 35",
			"player.level >= 82",
		}, "target"}, 
	},{
		"target.casting"
	}},
  }, "modifier.interrupts"},
  
 {{		--Defensives
	{{
		{bar, {		--Barkskin
			"player.health <= 50",
			"player.level >= 44",
		}}, 
		{mu, {	--Might of Ursoc
			"player.health <= 30",
			"player.level >= 72",
		}}, 
		{si, {		--Survival Instincts
			"player.health <= 25",
			"player.level >= 56",
		}},
		{"/cancelform /run CastSpellByID("..rej..")", {		--Rejuvination
			"player.form != 0",
			"!player.buff("..rej..")",
			"!player.buff("..how..")",
			"player.health <= 20",
		}},
		{rej, {
			"player.form = 0",
			"!player.buff("..rej..")",
			"player.health <= 20",
		}},
		{fr, {		--Frenzied Regeneration
			"player.buff("..mu..")",
			"player.level >= 72",
			"player.spell("..fr..").casted < 1",
		}}, 
		{"/cancelform", { --(Return from Might of Ursoc)
			"player.buff("..bf..")",
			"!player.buff("..how..")",
		}},	
	},{
		"!player.buff("..prl..")",	--Prowl
		"!player.buff(80169)",	--Food
		"!player.buff(87959)",	--Drink
		"!player.casting",
		"player.alive",
	}}, 
 }},
 
 {{		--Multitarget Rotation
	
	{ff, {		--Faerie Fire AoE
		"player.level >= 28",
		"target.range <= 8",
		"target.health > 25",
		"player.spell("..ff..").cooldown = 0", --Faerie Fire
		"!target.debuff("..wa..")", --Weakened Armor
		"!player.buff("..prl..")" --Prowl
	}, "target"},
	
	{{				--Savage Roar AoE
		{{			--In-Combat - No Savage Roar
			{svr, {	--No Glyph
				"player.combopoints > 0",
				"!player.glyph(127540)"
			}}, 
			{svg, {--Glyph
				"player.glyph(127540)"
			}},
		},{
			"player.srr <= 1",
			"player.power >= 25"
		}},
	},{
		"!player.buff("..how..")",
		"player.buff("..cf..")",
		"target.enemy",
		"target.alive",
		"target.range < 10",
		"player.level >= 18"
	}},
	
	{tf, {  	--Tiger's Fury AoE
		"player.buff("..cf..")", --Cat Form
		"player.spell("..tf..").cooldown = 0", --Tiger's Fury
		"player.range <= 8",
		"player.power < 35",
		"!player.buff("..ber..")", --Berserk
		"!player.buff("..cc..")" --Clearcasting
	}}, 
	
	{{				--Thrash AoE
		{thr, {	
			"player.rrr > 0",
		}},
		{thr, {	
			"player.thrr < 3",
		}},
		{thr, {	
			"player.buff("..tf..")",
		}},
	},{
		"player.thrr < 9",
		"player.power >= 50",
		"player.buff("..cf..")", --Cat Form
		"player.level >= 28",
		"player.range <= 8"
	}},
	
	{rp, {		--Rip AoE
		"player.rpr < 2",
		"player.power >= 30",
		"target.ttd > 4",
		"player.combopoints >= 5",
		"player.buff("..cf..")", --Cat Form
		"player.srr > 0", --Savage Roar
		"!player.buff("..cc..")", --Clearcasting
		"player.range <= 8"
	}},
	
	{rk, {		--Rake AoE
		"player.rkr < 3",
		"player.power >= 35",
		"!player.buff("..cc..")",	--Clearcasting
		"player.srr > 0",
		"target.ttd >= 15",
		"target.enemy",
		"target.alive",
		"target.range < 8"
	}, "target"}, 
	
	{sw, {		--Swipe
		"player.srr > 0",
		"player.power >= 45",
		"target.enemy",
		"target.alive",
		"target.range < 8",
		"player.level >= 22"
	}},
		
 }, "modifier.multitarget"},
 
 {{		--Single Rotation
 
	{thr, {	--Thrash - Clearcasting Proc
		"player.buff("..cc..")",
		"player.thrr <= 3",
		"player.rpr > 3",
		"player.rkr > 3",
		"player.buff("..cf..")",
		"player.level >= 28",
		"target.range < 8",
		"target.ttd >= 6",
	}},
	
	{ff, {		--Faerie Fire
		"player.level >= 28",
		"target.range <= 8",
		"target.health > 25",
		"player.spell("..ff..").cooldown = 0", --Faerie Fire
		"!target.debuff("..wa..")", --Weakened Armor
		"!player.buff("..prl..")" --Prowl
	}, "target"},
	
	{{				--Savage Roar
		{{			--In-Combat - No Savage Roar
			{svr}, 
			{svg},
		},{
			"player.srr <= 1",
			"player.power >= 25"
		}},
		{{			--Advanced Refresh Logic
			{svr}, 
			{svg},
		},{
			"player.power >= 25",
			"player.srrpdiff <= 4",
			"player.srt",
			"player.rpr < 10",
			"player.rpr > 0"
		}},
	},{
		"!player.buff("..how..")",
		"player.buff("..cf..")",
		"target.enemy",
		"target.alive",
		"target.range < 10",
		"player.level >= 18"
	}},
	
	{tf, {  	--Tiger's Fury
		"player.power <= 35",
		"player.spell("..tf..").cooldown = 0",
		"target.range < 8",
		"!player.buff("..ber..")",
		"!player.buff("..cc..")",
	}}, 
	
 {{		--Cooldowns
	{{
		{{
			{rber, {		--Racial: Troll Berserking
				"player.power >= 75",
			}}, 
			{"#gloves", {	--Profession: Engineering Hands
				"player.power >= 75",
				"!player.buff("..ber..")",	--Berserk
			}}, 
			{ber, {			--Berserk
				"player.energy >= 75",
				"player.spell("..tf..").cooldown > 6",
				"target.ttd >= 18",
				"target.boss(true)"
			}}, 
			{inb, {			--Tier 4 Talent: Incarnation - King of the Jungle
				"target.ttd >= 15",
				"player.buff("..ber..")",	--Berserk
			}},
			{nv, {	--Tier 6 Talent: Nature's Vigil
				"target.ttd >= 15",
				"player.power >= 75",
			}}, 
		},{
			"player.srr > 0",			--Savage Roar
			"player.buff("..tf..")",			--Tiger's Fury
		}},
		{{					--Tier 4 Talent: Force of Nature
			{{
				{fon, {	
					"player.dex > 0",
					"player.dex <= 1",
				}},
				{fon, {	
					"player.buff(146310)",
				}},
				{fon, {
					"player.rscr < 5",
					"player.rscbuff = 10",
				}},
				{fon, {
					"player.rrr > 0",
					"player.rrr < 1",
				}},
				{fon, {	
					"target.ttd < 20",
				}},
			},{			
				"player.spell("..fon..").charges > 0"
			}},
			{fon, {	
				"player.spell("..fon..").charges = 3",
				"player.rrr = 0",
				"player.rscr = 0",
				"player.spell("..fon..").casted < 1",
			}},
		},{
			"player.level >= 60",
			"player.spell("..fon..").cooldown = 0",	--Force of Nature
		}}, 
	},{
		"player.buff("..cf..")",				--Cat Form
		"!player.buff("..prl..")",			--Prowl
		"player.range <= 8"
	}}	
 }, "modifier.cooldowns"},

	{{				--Thrash
		{thr, {	--Rune of Reorigination
			"player.thrr < 9",
			"player.rrr > 0",
			"player.rrr <= 1.5",
			"player.rpr > 0",
		}},
		{thr, {	--About to Expire/Expired
			"player.thrr <= 3",
			"player.rpr > 3",
			"player.rkr > 3",
		}},
	},{
		"!player.buff("..cc..")",
		"player.buff("..cf..")",
		"player.level >= 28",
		--"player.power >= 50",
		"target.range < 8",
		"target.ttd >= 6",
	}},
	
	{{				--Ferocious Bite	
		{{
			{fb, {
				"target.ttd <= 4"
			}},
			{fb, {
				"player.rpr > 0",
				"player.rpr <= 4"
			}},
		},{
			"target.health <= 25"
		}},
		{fb, {
			"player.rpp < 108",
			"player.rpr > 6",
			"player.combopoints >= 5",
			"player.power >= 50"
		}},
	},{
		"player.buff("..cf..")",
		"player.power >= 25",
		"player.rrr = 0",
		"player.srr > 0",
		"target.enemy",
		"target.alive",
		"target.range < 8"
	}, "target"},
		
	{{				--Healing Touch
		{ht, {	--Buff about to Expire
			"player.buff("..ps..").duration < 1.5",
		}, "lowest"},
		{ht, {	--4 Combo Points (buffed Bleeds)
			"player.combopoints >= 4",
		}, "lowest"},
	},{
		"player.buff("..ps..")",	--Predatory Swiftness
		"!player.buff("..dcd..")",	--Dream of Cenarious
		"player.level >= 26"
	}},
	
	{{				--Rip
		{rp, {	--Rune of Reorigination
			"player.combopoints = 4", 
			"player.rpp >= 95",
			"target.ttd > 30",
			"player.rrr > 0",
			"player.rrr <= 1.5",
		}, "target"},
		{{
			{rp, {	--Doesn't Exists
				"player.rpr = 0",
			}, "target"},
			{{
				{rp, {	--About to Expire
					"player.rpr < 6",
					"target.health > 25",
				}, "target"},
				{rp, {	--MOAR BLEEDS!
					"player.rpp > 108",
					"player.rscbuff = 0",
				}, "target"},
				{rp, {	--Fail-a-taki's Soul Charm
					"player.rpp > 108",
					"player.rscbuff >= 7",
				}, "target"},
			},{
				"target.ttd >= 15",
			}},
		},{
			"player.combopoints >= 5",
		}},
	},{
		--"player.power >= 30",
		"player.level >= 20",
		"player.srr > 1",
		"target.ttd > 4",
	}},
	
	{{				--Rake
		{rk, {		--Rune of Reorigination
			"player.rrr > 0.5",
			"player.rkr < 9",
			"player.rrr <= 1.5",
		}, "target"}, 
		{rk, {		--About to Fall Off
			"player.rkr < 3",
		}, "target"},
		{rk, {		--MOAR BLEEDS!
			"player.rerk",
			"player.rscbuff = 0",
		}, "target"},
		{rk, {		--Fail-a-taki's Soul Charm
			"player.rerk",
			"player.rscbuff >= 9",
		}, "target"},
	},{
		"target.range < 8",
		"player.srr > 1",
		"player.power >= 35",
	}},

	{{				--Filler
		{rvf, {		--Ravage - King of the Jungle
			"player.buff("..inb..")",
			--"player.power >= 45",
		}},
		{rvf, {		--Ravage - Stampede Buff
			"player.buff("..spd..")",
		}},
		{rk, {		--Rake Filler
			"player.rkfil",
		}},
		{{			--Shred
			{{	--Berserk
				{shg, {	--Berserk (w/ Glyph)
					"player.glyph(114234)",
				}},
				{shr, {		--Berserk (w/o Glyph)
					"!player.glyph(114234)",
				}},
			},{
				"player.buff("..ber..")",
			}},
			{{	--Clearcasting
				{shg, {	--Clearcasting (w/ Glyph)
					"player.glyph(114234)",
				}},
				{shr, {		--Clearcasting (w/o Glyph)
					"!player.glyph(114234)",
				}},
			},{
				"player.buff("..cc..")",
			}},
			{{	--High Regen
				{shg, {	--High Regen (w/ Glyph)
					"player.glyph(114234)",
				}},
				{shr, {		--High Regen (w/o Glyph)
					"!player.glyph(114234)",
				}},
			},{
				"player.regen >= 15",
			}},
		},{
			"player.canshr",
			--"player.power >= 45",
			"!player.buff("..inb..")",
		}},
		{mgl, {		--Mangle
			--"player.power >= 35",
			"!player.buff("..inb..")",
		}},
	},{
		"player.buff("..cf..")",
		"target.range < 8",
		"player.combopoints < 5",
		"target.enemy",
		"target.alive",
	}, "target"},
	
 }, "!modifier.multitarget"},
 
 },
 
 {	-- Out of Combat

	{"/pe aoe", {	--Toggle AoE
		"modifier.rshift"
	}},
 
	{"/pe cd", {	--Toggle Cooldowns
		"modifier.rcontrol"
	}},
	
	{{	--Aquatic Form
		{"/cancelform /run CastSpellByID("..af..")", {		--In Shapeshift
			"player.form != 0"
		}, "player"},
		{"af", {	--Not In Shapeshift
			"player.form = 0",
		}},
	},{
		"player.swimming", 
		"!player.buff(af)" 
	}},
	
	{{				--Mark of the Wild
		{"/cancelform /run CastSpellByID("..mow..")", {		--In Shapeshift
			"player.form != 0"
		}, "player"},		
		{mow, {  --Not In Shapeshift	
			"player.form = 0",
		}, "player"},
	},{
		"!player.buff(115921).any",
		"!player.buff(20217).any",
		"!player.buff(1126).any",
		"!player.buff(90363).any",
		"!player.buff("..sff..")",
		"player.level >= 62",
		"!player.buff(104934)", --Eating
		"!player.buff(104269)", --Drinking	
	}},  
	
	{{				--Revive
		{"/cancelform /run CastSpellByID("..rv..")", {		--In Shapeshift
			"player.form != 0"
		}},
		{rv, {	--Not In Shapeshift
			"player.form = 0"
		}},
	},{
		"mouseover.exists",
		"mouseover.dead",
		"mouseover.isPlayer",
		"mouseover.range < 40",
		"player.level >= 12"
	}, "mouseover"},
	
	{{				--Remove Corruption
		{"/cancelform /run CastSpellByID("..rc..")", {		--In Shapeshift
			"player.form != 0"
		}},
		{rc, {	--Not In Shapeshift
			"player.form = 0"
		}},
	},{
		"player.dispellable("..rc..")"
	}},
 
	{{				--Cat Form
		{"/cancelform /run CastSpellByID("..cf..")", { --In Shapeshift
			"player.form !=0"
		}},
		{cf, {	--Not In Shapeshift
			"player.form = 0"
		}},
	},{
		"target.exists", 
		"target.alive", 
		"target.enemy",
		"!player.buff(768)",
		"player.health > 20",
		"!modifier.last(768)"
	}},
 
	{{				--Rejuvination
		{"/cancelform /run CastSpellByID("..rej..")", {		--In Shapeshift
			"player.form != 0"
		}},
		{rej, {	--Not In Shapeshift
			"player.form = 0"
		}},
	},{
		"!player.buff("..prl..")",	--Prowl
		"!player.buff(80169)",	--Food
		"!player.buff(87959)",	--Drink
		"!player.casting",
		"player.alive",
		"!player.buff("..rej..")",
		"player.health <= 70"
		--"player.level < 26"
	}}, 

	{{				--Savage Roar
		{svr}, 
		{svg},
	},{
		"player.srr <= 1",
		"player.buff("..prl..")",
		"!player.buff("..how..")",
		"player.buff("..cf..")",
		"target.enemy",
		"target.alive",
		"target.range < 10",
	}},
	
	{prl, {		--Prowl
		"!player.buff("..prl..")",
		"target.enemy",
		"target.alive",
		"target.range < 20"
	}},
	
	{rvg, {		--Ravage
		"target.behind",
		"player.buff("..prl..")",
		"player.srr > 1",
		"!target.player",
		"player.combopoints < 5",
		"player.power >= 45",
		"target.enemy",
		"target.alive",
		"target.range < 8",
	}, "target"},
	
	{pnc, {		--Pounce
		"player.buff("..prl..")",
		"target.player",
		"target.behind",
		"player.combopoints < 5",
		"player.power >= 50",
		"target.enemy",
		"target.alive",
		"target.range < 8"
	}},
	
	{{				--Shred
		{shr, {		--Shred (No Glyph)
			"target.behind"			
		}, "target"},
		{shg, {		--Shred (Glyphed)
			"player.buff("..ber..")",
			"player.glyph(114234)"
		}, "target"},
	},{
		"player.combopoints < 5",
		"player.power >= 40",
		"target.enemy",
		"target.alive",
		"target.range < 8",
		"player.level >= 16"
	}},
			
	{mgl, { 	--Mangle: Combo Point Building
		"player.combopoints < 5",
		"player.power >= 35",
		"target.enemy",
		"target.alive",
		"target.range < 8"
	}, "target"}, 
 
 }
 )