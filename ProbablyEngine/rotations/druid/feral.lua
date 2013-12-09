-- ProbablyEngine Rotation Packager
-- Custom Feral Combat Druid Rotation
-- Created on Nov 2nd 2013 10:35 pm
cute.crkd()
cute.rkd()
cute.crpd()
cute.rpd()

 ProbablyEngine.rotation.register_custom(103, "ImoCuteOne - Feral", 
 
 {	 --In Combat
 {{	--Dummy Rotation Test
	--{"!/print(5 Minute Dummy Test Concluded - Profile Stopped)"},
	--{"!/stopattack"},
	{"!/cleartarget"},
 }, {"player.time >= 300", "@cute.dummy()"}},
 
 {"pause", {	--Pause Rotation
	"@cute.Pause()"
}}, 

 {"!/click PE_Buttons_multitarget", {	--Toggle AoE
	"modifier.rshift",
 }},
 
 {"!/pe cd", {	--Toggle Cooldowns
	"modifier.rcontrol",
 }},
 
 {"768", { 		--Cat Form
	"@cute.CF()",
 }},
 
 {{		--Interrupts
 
	{"33786", {		--Cyclone: Focus Target
		"@cute.Cy()",
		"player.spell(33786).cooldown = 0",
		"player.spell(33786).exists"
	}, "focus"},
	
	{"5211", {		--Mighty Bash
		"player.spell(5211).cooldown = 0",	--Mighty Bash
		"player.range <= 8",
		"player.spell(80965).cooldown != 0",	--Skull Bash
		"player.spell(80965).cooldown <= 14",	--Skull Bash
		"target.casting",
		"player.spell(5211).exists"
	}, "target"}, 
	
	{"80965", {		--Skull Bash
		"player.spell(80965).cooldown = 0",	--Skull Bash
		"target.casting",
		"player.spell(80965).exists"
	}, "target"},
	
	-- {"132469", {	--Typhoon
		-- "player.spell(132469).cooldown = 0",	--Typhoon
		-- "player.spell(80965).cooldown != 0",
		-- "player.spell(5211).cooldown != 0",
		-- "target.casting"
	-- }, "target"}, 
	
	{"22570", {		--Maim
		"@cute.MA()",
		"player.spell(22570).cooldown != 0",	--Skull Bash
		"target.casting",
		"player.combopoints > 0",
		"player.energy >= 35"
	}, "target"}, 
	
  }, "modifier.interrupts"},
  
 {{		--Defensives
 
	{"22812", {		--Barkskin
		"!player.buff(5215)",	--Prowl
		"player.health <= 50",
		"player.spell(22812).exists"
	}}, 
	
	{"106922", {	--Might of Ursoc
		"!player.buff(5215)",	--Prowl
		"player.health <= 30",
		"player.spell(106922).exists"
	}}, 
	
	{"61336", {		--Survival Instincts
		"!player.buff(5215)",	--Prowl
		"player.health <= 25",
		"player.spell(61336).exists"
	}}, 
	
	{"22842", {		--Frenzied Regeneration
		"!player.buff(5215)",	--Prowl
		"player.buff(106922)",
		"player.spell(22842).exists"
	}}, 
	
	{"768", {		--Cat Form (Return from Might of Ursoc)
		"!player.buff(768)",
		"player.buff(106922)",
		"player.buff(22842)",
	}},
	
	{"20484", {		--Rebirth
		"@cute.RB()",
		"!player.casting",
		"player.buff(69369)",	--Predatory Swiftness
		--"player.spell(20484).cooldown = 0"
	}, "mouseover"}, 
	
 },},
 
 {{		--Cooldowns
 
	{"26297", {		--Racial: Troll Berserking
		"player.spell(26297).exists",	--Racial: Troll Berserking
		"!player.buff(5215)",			--Prowl
		"player.energy >= 75",
		"player.buff(127538)",			--Savage Roar
		"player.buff(5217)",			--Tiger's Fury
		"player.range <= 8"
	}}, 
	
	{"#gloves", {	--Profession: Engineering Hands
		"!player.buff(5215)",	--Prowl
		"player.energy >= 75",
		"player.buff(127538)",	--Savage Roar
		"player.buff(5217)",	--Tiger's Fury
		"!player.buff(106951)",	--Berserk
		"player.range <= 8"
	}}, 
	
	{"106951", {	--Berserk
		"@cute.Ber()",
	}}, 
	
	{"106731", {	--Tier 4 Talent: Incarnation - King of the Jungle
		"@cute.KotJ()",
		"player.spell(106731).exists",	--King of the Jungle
		"!player.buff(5215)",	--Prowl
		"player.buff(127538)",	--Savage Roar
		"player.buff(5217)",	--Tiger's Fury
		"player.buff(106951)",	--Berserk
		"player.range <= 8",
		"player.spell(106731).exists"	--Incarnation
	}}, 
	
	{"106737", {	--Tier 4 Talent: Force of Nature
		"@cute.FoN()",
		"player.spell(106737).exists",	--Force of Nature
		"!player.buff(5215)",				--Prowl
		"player.spell(106737).cooldown = 0",	--Force of Nature
		"player.range <= 8"
	}}, 

	{"124974", {	--Tier 6 Talent: Nature's Vigil
		"@cute.NV()",
		"player.spell(124974).exists",	--Nature's Vigil
		"!player.buff(5215)",			--Prowl
		"player.energy >= 75",
		"player.buff(127538)",			--Savage Roar
		"player.buff(5217)",			--Tiger's Fury
		"player.range <= 8"
	}}, 
	
 }, "modifier.cooldowns"},
 
 {{		--Multitarget Rotation
	 
	{"770", {	--Faerie Fire AoE
		"@cute.FF()",
		"player.range <= 8",
		"target.health > 25",
		"player.spell(770).cooldown = 0", --Faerie Fire
		"!target.debuff(113746)", --Weakened Armor
		"!player.buff(5215)" --Prowl
	}, "target"}, 
	
	{"127538", {	--Savage Roar AoE
		"@cute.SR()",
		"player.buff(768)", --Cat Form
		"player.range <= 20"
	}},
	
	{"5217", {  	--Tiger's Fury AoE
		"player.buff(768)", --Cat Form
		"player.spell(5217).cooldown = 0", --Tiger's Fury
		"player.range <= 8",
		"player.energy < 35",
		"!player.buff(106951)", --Berserk
		"!player.buff(135700)" --Clearcasting
	}}, 
	
	{"106830", {	--Thrash AoE
		"@cute.ThrAoE()",
		"player.buff(768)", --Cat Form
		"player.level >= 28",
		"player.range <= 8"
	}},
	
	{"1079", {		--Rip AoE
		"player.combopoints >= 5",
		"player.buff(768)", --Cat Form
		"player.buff(127538)", --Savage Roar
		"!player.buff(135700)", --Clearcasting
		"player.range <= 8"
	}},
	
	{"1822", {		--Rake AoE
		"@cute.RkAoE()",
		"player.buff(768)", --Cat Form
		"player.range <= 8",
		"!player.buff(135700)",	--Clearcasting
		"player.buff(127538)" --Savage Roar
	}},
	
	{"62078", {		--Swipe
		"player.buff(768)", --Cat Form
		"player.range <= 8",
		"player.buff(127538)", --Savage Roar
		"target.debuff(106830).duration > 0",	--Thrash
	}},
	
 }, "modifier.multitarget"},
 
 {{		--Single Rotation
	{"106830", {	--Thrash - Clearcasting Proc
		"@cute.ThrCC()"
	}},
 
	{"127538", {	--Savage Roar
		"@cute.SR()",
	}}, 
	
	{"770", {		--Faerie Fire
		"@cute.FF()",
		"player.range <= 8",
		"target.health > 25",
		"player.spell(770).cooldown = 0", --Faerie Fire
		"!target.debuff(113746)", --Weakened Armor
		"!player.buff(5215)" --Prowl
	}, "target"},
	
	{"5217", {  	--Tiger's Fury
		"@cute.TF()",
	}}, 
	
	{"106830", { 	--Thrash
		"@cute.Thr()",
	}, "target"}, 
	
	{"22568", { 	--Ferocious Bite
		"@cute.FB()",
	}, "target"},
	
	-- {"5185", { --Healing Touch - Lowest Raid Member
		-- "@cute.HT()",
		-- "lowest.exists",
	-- }, "lowest"},
	
	{"5185", {		--Healing Touch - Self Default
		"@cute.HT()",
	}, "player"}, 
	
	{"1079", {		--Rip
		"@cute.RP()",
	}, "target"}, 
	
	{"1822", {		--Rake
		"@cute.RK()",
	}, "target"}, 
	
	{"6785", {		--Ravage: Combo Point Building
		"@cute.FRvg()",
	}, "target"},
	
	{"1822", {		--Rake: Combo Point Building
		"@cute.RkF()",
	}, "target"},
	
	{"5221", {		--Shred: Combo Point Building
		"@cute.ShrF()",
	}, "target"}, 
	
	{"33876", { 	--Mangle: Combo Point Building
		"@cute.MglF()",
	}, "target"}, 
	
 }, "!modifier.multitarget"},
 
 },
 
 {	-- Out of Combat
 
	{"!/click PE_Buttons_multitarget", {	--Toggle AoE
		"modifier.rshift",
	}},
 
	{"!/pe cd", {	--Toggle Cooldowns
		"modifier.rcontrol",
	}},
 
	-- {"50769", {	--Revive
		-- "@cute.RV()",
		-- "!player.casting",
	-- }, "mouseover"},
 
	{"768", { 		--Cat Form
		"@cute.CF()",
		"target.enemy",
		"target.alive",
	}},
 
	{"1066", {		--Aquatic Form
		"@cute.AF()",
		"!player.casting",
		"!player.buff(1066)"	--Aquatic Form
	}}, 
 
	-- {"783", {		--Travel Form
		-- "@cute.TrF()",
		-- "!player.buff(768)",		--Cat Form
		-- "player.moving"
	-- }}, 

	{"!/cancelform", {	--Unshapeshift - Rejuvination Cast
		"!modifier.alt",
		"!player.buff(5215)",	--Prowl
		"!player.buff(80169)",	--Food
		"!player.buff(87959)",	--Drink
		"!player.casting",
		"player.alive",
		"!player.buff(774)",
		"player.health <= 70",
		"player.form != 0"
	}}, 
 
	{"774", {		--Rejuvination
		"@cute.Rej()",
		"!modifier.alt",
		"!player.buff(5215)",	--Prowl
		"!player.buff(80169)",	--Food
		"!player.buff(87959)",	--Drink
		"!player.casting",
		"player.alive",
		"!player.buff(774)",
		"player.health <= 70"
	}}, 
 
	{"!/cancelform", {	--Unshapeshift - Mark of the Wild Cast
		"@cute.MotW()",
		"!player.buff(40120)",
		"player.level >= 62",
		"!player.buff(1126)",
		"!player.buff(104934)", --Eating
		"!player.buff(104269)", --Drinking	
		"player.form != 0"
	}}, 
 
	{"1126", {  	--Mark of the Wild
		"@cute.MotW()",
		"!player.buff(40120)",
		"player.level >= 62",
		"player.form = 0",
		"!player.buff(104934)", --Eating
		"!player.buff(104269)", --Drinking	
	}, "player"},  
 
	{"5215", {		--Prowl
		"@cute.Prl()",
		"target.enemy",
		"target.alive"
	}}, 
 
	{"127538", {	--Savage Roar
		"@cute.SR()",
		"target.enemy",
		"target.alive"
	}}, 
 
	{"Ravage", {		--Ravage - Opener
		"@cute.Rvg()",
	}, "target"}, 
 
	{"9005", {		--Pounce
		"@cute.Pnc()",
	}, "target"}, 
 
	{"33876", {	--Mangle: Opener
		"@cute.MglOp()",
	}, "target"}, 
 
	{"pause", {	--Pause Rotation
		"@cute.Pause()",
	}}, 
 
 }
 )