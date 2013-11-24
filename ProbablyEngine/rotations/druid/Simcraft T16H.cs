actions.precombat=flask,type=spring_blossoms
actions.precombat+=/food,type=sea_mist_rice_noodles
actions.precombat+=/mark_of_the_wild,if=!aura.str_agi_int.up
actions.precombat+=/healing_touch,if=!buff.dream_of_cenarius.up&talent.dream_of_cenarius.enabled
actions.precombat+=/cat_form
actions.precombat+=/savage_roar
actions.precombat+=/stealth
# Snapshot raid buffed stats before combat begins and pre-potting is done.
actions.precombat+=/snapshot_stats
actions.precombat+=/virmens_bite_potion

# Executed every time the actor is available.

actions.advanced=swap_action_list,name=aoe,if=active_enemies>=5
actions.advanced+=/tigers_fury,if=time=0&set_bonus.tier16_4pc_melee
actions.advanced+=/savage_roar,if=time=0&set_bonus.tier16_4pc_melee
actions.advanced+=/auto_attack
actions.advanced+=/skull_bash_cat
actions.advanced+=/force_of_nature,if=charges=3|(buff.ticking_ebon_detonator.react&buff.ticking_ebon_detonator.remains<1)|(buff.rune_of_reorigination.react&buff.rune_of_reorigination.remains<1)|target.time_to_die<20
actions.advanced+=/blood_fury
actions.advanced+=/berserking
actions.advanced+=/arcane_torrent
actions.advanced+=/ravage,if=buff.stealthed.up
# Keep Rip from falling off during execute range.
actions.advanced+=/ferocious_bite,if=dot.rip.ticking&dot.rip.remains<=3&target.health.pct<=25
actions.advanced+=/faerie_fire,if=debuff.weakened_armor.stack<3
# Proc Dream of Cenarius at 4+ CP or when PS is about to expire.
actions.advanced+=/healing_touch,if=talent.dream_of_cenarius.enabled&buff.predatory_swiftness.up&buff.dream_of_cenarius.down&(buff.predatory_swiftness.remains<1.5|combo_points>=4)
actions.advanced+=/savage_roar,if=buff.savage_roar.down
actions.advanced+=/tigers_fury,if=energy<=35&!buff.omen_of_clarity.react
actions.advanced+=/berserk,if=buff.tigers_fury.up|(target.time_to_die<18&cooldown.tigers_fury.remains>6)
actions.advanced+=/thrash_cat,if=buff.omen_of_clarity.react&dot.thrash_cat.remains<3&target.time_to_die>=6
actions.advanced+=/ferocious_bite,if=target.time_to_die<=1&combo_points>=3
actions.advanced+=/savage_roar,if=buff.savage_roar.remains<=3&combo_points>0&target.health.pct<25
# Potion near or during execute range when Rune is up and we have 5 CP.
actions.advanced+=/virmens_bite_potion,if=(combo_points>=5&(target.time_to_die*(target.health.pct-25)%target.health.pct)<15&buff.rune_of_reorigination.up)|target.time_to_die<=40
# Overwrite Rip if it's at least 15% stronger than the current.
actions.advanced+=/rip,if=combo_points>=5&action.rip.tick_damage%dot.rip.tick_dmg>=1.15&target.time_to_die>30
# Use 4 or more CP to apply Rip if Rune of Reorigination is about to expire and it's at least close to the current rip in damage.
actions.advanced+=/rip,if=combo_points>=4&action.rip.tick_damage%dot.rip.tick_dmg>=0.95&target.time_to_die>30&buff.rune_of_reorigination.up&buff.rune_of_reorigination.remains<=1.5
# Pool 50 energy for Ferocious Bite.
actions.advanced+=/pool_resource,if=combo_points>=5&target.health.pct<=25&dot.rip.ticking&!(energy>=50|(buff.berserk.up&energy>=25))
actions.advanced+=/ferocious_bite,if=combo_points>=5&dot.rip.ticking&target.health.pct<=25
actions.advanced+=/rip,if=combo_points>=5&target.time_to_die>=6&dot.rip.remains<2&(buff.berserk.up|dot.rip.remains+1.9<=cooldown.tigers_fury.remains)
actions.advanced+=/savage_roar,if=buff.savage_roar.remains<=3&combo_points>0&buff.savage_roar.remains+2>dot.rip.remains
actions.advanced+=/savage_roar,if=buff.savage_roar.remains<=6&combo_points>=5&buff.savage_roar.remains+2<=dot.rip.remains&dot.rip.ticking
# Savage Roar if we're about to energy cap and it will keep our Rip from expiring around the same time as Savage Roar.
actions.advanced+=/savage_roar,if=buff.savage_roar.remains<=12&combo_points>=5&energy.time_to_max<=1&buff.savage_roar.remains<=dot.rip.remains+6&dot.rip.ticking
# Refresh Rake as Re-Origination is about to end if Rake has <9 seconds left.
actions.advanced+=/rake,if=buff.rune_of_reorigination.up&dot.rake.remains<9&buff.rune_of_reorigination.remains<=1.5
# Rake if we can apply a stronger Rake or if it's about to fall off and clipping the last tick won't waste too much damage.
actions.advanced+=/rake,cycle_targets=1,if=target.time_to_die-dot.rake.remains>3&(action.rake.tick_damage>dot.rake.tick_dmg|(dot.rake.remains<3&action.rake.tick_damage%dot.rake.tick_dmg>=0.75))
# Pool energy for and maintain Thrash.
actions.advanced+=/pool_resource,for_next=1
actions.advanced+=/thrash_cat,if=target.time_to_die>=6&dot.thrash_cat.remains<3&(dot.rip.remains>=8&buff.savage_roar.remains>=12|buff.berserk.up|combo_points>=5)&dot.rip.ticking
# Pool energy for and clip Thrash if Rune of Re-Origination is expiring.
actions.advanced+=/pool_resource,for_next=1
actions.advanced+=/thrash_cat,if=target.time_to_die>=6&dot.thrash_cat.remains<9&buff.rune_of_reorigination.up&buff.rune_of_reorigination.remains<=1.5&dot.rip.ticking
# Pool to near-full energy before casting Ferocious Bite.
actions.advanced+=/pool_resource,if=combo_points>=5&!(energy.time_to_max<=1|(buff.berserk.up&energy>=25)|(buff.feral_rage.up&buff.feral_rage.remains<=1))&dot.rip.ticking
# Ferocious Bite if we reached near-full energy without spending our CP on something else.
actions.advanced+=/ferocious_bite,if=combo_points>=5&dot.rip.ticking
# Conditions under which we should execute a CP generator.
actions.advanced+=/run_action_list,name=filler,if=buff.omen_of_clarity.react
actions.advanced+=/run_action_list,name=filler,if=buff.feral_fury.react
actions.advanced+=/run_action_list,name=filler,if=(combo_points<5&dot.rip.remains<3.0)|(combo_points=0&buff.savage_roar.remains<2)
actions.advanced+=/run_action_list,name=filler,if=target.time_to_die<=8.5
actions.advanced+=/run_action_list,name=filler,if=buff.tigers_fury.up|buff.berserk.up
actions.advanced+=/run_action_list,name=filler,if=cooldown.tigers_fury.remains<=3
actions.advanced+=/run_action_list,name=filler,if=energy.time_to_max<=1.0

actions.filler=ravage
# Rake if it hits harder than Mangle and we won't apply a weaker bleed to the target.
actions.filler+=/rake,if=target.time_to_die-dot.rake.remains>3&action.rake.tick_damage*(dot.rake.ticks_remain+1)-dot.rake.tick_dmg*dot.rake.ticks_remain>action.mangle_cat.hit_damage
actions.filler+=/shred,if=(buff.omen_of_clarity.react|buff.berserk.up|energy.regen>=15)&buff.king_of_the_jungle.down
actions.filler+=/mangle_cat,if=buff.king_of_the_jungle.down

actions.aoe=swap_action_list,name=default,if=active_enemies<5
actions.aoe+=/auto_attack
actions.aoe+=/faerie_fire,cycle_targets=1,if=debuff.weakened_armor.stack<3
actions.aoe+=/savage_roar,if=buff.savage_roar.down|(buff.savage_roar.remains<3&combo_points>0)
actions.aoe+=/blood_fury,if=buff.tigers_fury.up
actions.aoe+=/berserking,if=buff.tigers_fury.up
actions.aoe+=/arcane_torrent,if=buff.tigers_fury.up
actions.aoe+=/tigers_fury,if=energy<=35&!buff.omen_of_clarity.react
actions.aoe+=/berserk,if=buff.tigers_fury.up
actions.aoe+=/pool_resource,for_next=1
actions.aoe+=/thrash_cat,if=buff.rune_of_reorigination.up
actions.aoe+=/pool_resource,wait=0.1,for_next=1
actions.aoe+=/thrash_cat,if=dot.thrash_cat.remains<3|(buff.tigers_fury.up&dot.thrash_cat.remains<9)
actions.aoe+=/savage_roar,if=buff.savage_roar.remains<9&combo_points>=5
actions.aoe+=/rip,if=combo_points>=5
actions.aoe+=/rake,cycle_targets=1,if=(active_enemies<8|buff.rune_of_reorigination.up)&dot.rake.remains<3&target.time_to_die>=15
actions.aoe+=/swipe_cat,if=buff.savage_roar.remains<=5
actions.aoe+=/swipe_cat,if=buff.tigers_fury.up|buff.berserk.up
actions.aoe+=/swipe_cat,if=cooldown.tigers_fury.remains<3
actions.aoe+=/swipe_cat,if=buff.omen_of_clarity.react
actions.aoe+=/swipe_cat,if=energy.time_to_max<=1