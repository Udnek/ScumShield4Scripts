ToughAsNailsU_blocks_data:
    type: data

    blocks_around_radius: 6

    blocks_around:
        magma_block: 0.5
        lava: 12
        fire: 5
        soul_fire: 10
        lava_cauldron: 11
        small_amethyst_bud: -3
        medium_amethyst_bud: -7
        large_amethyst_bud: -10
        amethyst_cluster: -15

    blocks_around_lit:
        soul_campfire: 14
        campfire: 9
        furnace: 9
        smoker: 9
        blast_furnace: 9

    respawn_anchor_blue_ice_around:
        respawn_anchor: -3000

    blocks_below:
        powder_snow: -6
        snow_block: -3
        magma_block: 3
        ice: -3
        packed_ice: -5
        blue_ice: -10
        amethyst_block: -5
        budding_amethyst: -15

ToughAsNailsU_armor_data:
    type: data

    armor_mul:
        leather_helmet: 0.87
        leather_chestplate: 0.87
        leather_leggings: 0.87
        leather_boots: 0.87

        chainmail_helmet: 0.9
        chainmail_chestplate: 0.9
        chainmail_leggings: 0.9
        chainmail_boots: 0.9

        golden_helmet: 1.07
        golden_chestplate: 1.07
        golden_leggings: 1.07
        golden_boots: 1.07

        iron_helmet: 1.1
        iron_chestplate: 1.1
        iron_leggings: 1.1
        iron_boots: 1.1

        diamond_helmet: 1.15
        diamond_chestplate: 1.15
        diamond_leggings: 1.15
        diamond_boots: 1.15

        netherite_helmet: 0.99
        netherite_chestplate: 0.99
        netherite_leggings: 0.99
        netherite_boots: 0.99

    armor_add:
        leather_helmet: 3
        leather_chestplate: 3
        leather_leggings: 3
        leather_boots: 3

        chainmail_helmet: -2.5
        chainmail_chestplate: -2.5
        chainmail_leggings: -2.5
        chainmail_boots: -2.5

#--------------------------------
ToughAsNailsU_anabiosis_entity:
    debug: false
    type: entity
    entity_type: block_display
    mechanisms:
        material: ice
        scale: 1.0,2.0,1.0
        translation: -0.5,-1.38,-0.5
        view_range: 1

#--------------------------------
ToughAsNailsU_normalize_time:
    type: procedure
    debug: false
    definitions: time
    script:
        - define pi:3.14159
        - define time:/:24000
        - determine <[time].mul[20].div[<[pi]>].sin>

ToughAsNailsU_true_sunlight:
    type: procedure
    debug: false
    definitions: location
    script:
        - define max_sunlight <[location].light.sky>
        - define surface_sunlight <[location].with_y[1000].light>
        - if <[surface_sunlight]> >= <[max_sunlight]>:
            - determine <[max_sunlight].div[15].round_to[5]>
        - determine <[surface_sunlight].div[15].round_to[5]>

ToughAsNailsU_in_water:
    type: procedure
    debug: false
    definitions: __player
    script:
        - if <player.swimming>:
            - determine true
        - else if <player.is_inside_vehicle>:
            - determine false
        - else:
            - define water_blocks <list[water|kelp|seagrass|tall_seagrass|bubble_column]>
            - define block <player.location.material>
            - if ( ( <[block].name> matches <[water_blocks]> ) || ( <[block].waterlogged.if_null[false]> ) ):
                - determine true
            - define block <player.location.above.material>
            - if ( ( <[block].name> matches <[water_blocks]> ) || ( <[block].waterlogged.if_null[false]> ) ):
                - determine true

        - determine false

ToughAsNailsU_blocks_around_calculator:
    type: procedure
    debug: false
    definitions: location
    script:
        - define blocks_around_data <script[toughasnailsu_blocks_data].data_key[blocks_around]>
        - define blocks_around_lit_data <script[toughasnailsu_blocks_data].data_key[blocks_around_lit]>
        - define blocks_extra_data <script[toughasnailsu_blocks_data].data_key[respawn_anchor_blue_ice_around]>
        - define blocks_around <[location].find_blocks[<[blocks_around_data].keys.include[<[blocks_around_lit_data].keys>].include[<[blocks_extra_data].keys>]>].within[<script[toughasnailsu_blocks_data].data_key[blocks_around_radius]>]>
        - define blocks_around_impact 0
        - foreach <[blocks_around]> as:block_loc:
            - if <[blocks_around_data].contains[<[block_loc].material.name>]>:
                - define blocks_around_impact:+:<[blocks_around_data].get[<[block_loc].material.name>]>
            - else if <[blocks_extra_data].contains[<[block_loc].material.name>]>:
                - if <[block_loc].above.material.name> == blue_ice:
                    - if <[block_loc].material.count> > 0:
                        - define blocks_around_impact:+:<[blocks_extra_data].get[<[block_loc].material.name>]>
            - else:
                - if <[block_loc].material.switched>:
                    - define blocks_around_impact:+:<[blocks_around_lit_data].get[<[block_loc].material.name>]>
        - determine <[blocks_around_impact]>

ToughAsNailsU_temperature_color_calculator:
    type: procedure
    debug: false
    definitions: color|n
    script:
        - define inverted_color:<color[<element[255].sub[<[color].red>]>,<element[255].sub[<[color].green>]>,<element[255].sub[<[color].blue>]>]>
        - define red <element[255].sub[<[inverted_color].red.mul[<[n].div[1020]>].round>]>
        - define green <element[255].sub[<[inverted_color].green.mul[<[n].div[1020]>].round>]>
        - define blue <element[255].sub[<[inverted_color].blue.mul[<[n].div[1020]>].round>]>
        - determine <&color[<[red]>,<[green]>,<[blue]>]>

ToughAsNailsU_armor_impact_calculator:
    type: procedure
    debug: false
    definitions: equipment_map
    script:
        - define data <script[toughasnailsu_armor_data]>
        - define mul 1
        - define add 0
        - foreach <[equipment_map]> as:item:
            - define name <[item].proc[utilsu_item_actual_name]>
            - define mul:*:<element[1].sub[<[item].enchantment_map.get[ToughAsNailsU_nailer].if_null[0].mul[0.12]>]>

            - define mul:*:<[data].data_key[armor_mul].get[<[name]>].if_null[1]>
            - define add:+:<[data].data_key[armor_add].get[<[name]>].if_null[0]>
        - determine <map[mul=<[mul].round_to[3]>;add=<[add]>]>

ToughAsNailsU_water_type:
    type: procedure
    debug: false
    definitions: location
    script:
        - if !( ( <[location].material.name> matches water|kelp|seagrass|tall_seagrass|bubble_column ) || ( <[location].material.waterlogged.if_null[false]> ) ):
            - determine null

        - define biome <[location].biome.name>
        - define sea_water <list[beach]>
        - define pure_water <list[river]>

        - if <[biome].contains_any_text[ocean]> || <[sea_water].contains[<[biome]>]>:
            - define item <item[toughasnailsu_sea_water_bottle]>
        - else if <[biome].contains_any_text[river]> || <[pure_water].contains[<[biome]>]>:
            - define item <item[toughasnailsu_pure_water_bottle]>
        - else:
            - define item <item[toughasnailsu_dirty_water_bottle]>

        - determine <[item]>

ToughAsNailsU_weather_type:
    type: procedure
    debug: false
    definitions: location
    script:
        - if !<[location].world.has_storm>:
            - determine 0

        - if <[location].downfall_type> == NONE:
            - determine 0

        - if <[location].y> < <[location].highest.y>:
            - determine 0

        - determine 1


ToughAsNailsU_leaf_type:
    type: procedure
    debug: false
    definitions: location|material
    script:
        - if <[location].biome.name.contains[:]>:
            - define lore <gray><&translate[lore.toughasnailsu.collected_in].with[<&translate[<[location].biome.name>]>]>
        - else:
            - define lore <gray><&translate[lore.toughasnailsu.collected_in].with[<&translate[biome.minecraft.<[location].biome.name>]>]>

        - choose <[material]>:
            - case azalea_leaves flowering_azalea_leaves:
                - define item <item[toughasnailsu_azalea_leaf]>
            - case birch_leaves:
                - define item <item[toughasnailsu_birch_leaf]>
            - case cherry_leaves:
                - define item <item[toughasnailsu_cherry_leaf]>
            - case spruce_leaves:
                - define item <item[toughasnailsu_spruce_leaf]>

            - case acacia_leaves:
                - define item <item[toughasnailsu_acacia_leaf]>
            - case dark_oak_leaves:
                - define item <item[toughasnailsu_dark_oak_leaf]>
            - case mangrove_leaves:
                - define item <item[toughasnailsu_mangrove_leaf]>
            - case oak_leaves:
                - define item <item[toughasnailsu_oak_leaf]>
            - case jungle_leaves:
                - define item <item[toughasnailsu_jungle_leaf]>

            - default:
                - determine <item[air]>

        - define color <[location].biome.foliage_color>
        - determine <[item].with[lore=<[lore]>;firework=[color=<[color]>];flag=toughasnailsu_biome:<[location].biome.name>]>

ToughAsNailsU_get_food_stats:
    type: procedure
    debug: false
    definitions: item
    script:
        - define item_name <[item].script.name.if_null[<[item].material>]>
        - define data <script[toughasnailsu_items_data].data_key[stats]>
        #- debug debug <[data].contains[<[item]>]>
        - if <[data].contains[<[item_name]>]>:
            - define stats <list[<[data].get[<[item_name]>]>]>
            - determine <[stats]>
            #- determine <map[thirst=<[stats].get[1]>;effect=<[stats].get[2]>;duration=<[stats].get[3]>]>
        - determine null

ToughAsNailsU_food_effect_lore:
    type: procedure
    debug: false
    definitions: item_name
    script:
        - define stats <list[<script[toughasnailsu_items_data].data_key[stats.<[item_name]>]>]>
        - define duration <duration[<[stats].get[3]>].proc[utilsu_lore_duration]>
        - define buff <[stats].get[2]>

        - if <[buff]> > 0:
            - determine <&color[#FFAA00]><&translate[lore.toughasnailsu.effect_heat].with[<[stats].get[2]>|<[duration]>]>
        - else:
            - determine <&color[#55FFFF]><&translate[lore.toughasnailsu.effect_freeze].with[<[stats].get[2]>|<[duration]>]>

ToughAsNailsU_food_thirst_lore:
    type: procedure
    debug: false
    definitions: item_name
    script:
        - define stats <list[<script[toughasnailsu_items_data].data_key[stats.<[item_name]>]>]>
        - determine <reset><&font[toughasnailsu:font]><&translate[toughasnailsu.thirst.lore.level.<[stats].get[1]>]>

ToughAsNailsU_food_lore:
    type: procedure
    debug: false
    definitions: item_name
    script:
        - define first_line <proc[ToughAsNailsU_food_effect_lore].context[<[item_name]>]>
        - define second_line <proc[ToughAsNailsU_food_thirst_lore].context[<[item_name]>]>
        - determine <[first_line]><&nl><[second_line]>
        #- determine <list_single[<[first_line]>|<[second_line]>]>

ToughAsNailsU_is_fixed_bottle:
    type: procedure
    debug: false
    definitions: item
    script:
        - define item_name <[item].script.name.if_null[<[item].material>]>
        - define data <script[toughasnailsu_items_data].data_key[fixed_bottle]>
        - if <[data].contains[<[item_name]>]>:
            - determine true
        - determine false

ToughAsNailsU_is_fixed_leaf:
    type: procedure
    debug: false
    definitions: item
    script:
        - define item_name <[item].script.name.if_null[<[item].material>]>
        - define data <script[toughasnailsu_items_data].data_key[fixed_leaf]>
        - if <[data].contains[<[item_name]>]>:
            - determine true
        - determine false

ToughAsNailsU_is_flaskable:
    type: procedure
    debug: false
    definitions: item
    script:
        - define item_name <[item].script.name.if_null[<[item].material>]>
        - define data <script[toughasnailsu_items_data].data_key[flaskable]>
        - if <[data].contains[<[item_name]>]>:
            - determine true
        - determine false

ToughAsNailsU_get_special_bone_meal:
    type: procedure
    debug: false
    definitions: item|leaf|biome
    script:
        - if <[biome].contains[:]>:
            - define lore <gray><&translate[lore.toughasnailsu.leaf_from].with[<&translate[<[biome]>]>]>
        - else:
            - define lore <gray><&translate[lore.toughasnailsu.leaf_from].with[<&translate[biome.minecraft.<[biome]>]>]>
        - define lore <[lore]><&nl><gray><&translate[lore.toughasnailsu.leaf_type].with[<item[<[leaf]>].display>]>
        - determine <[item].with[lore=<[lore]>].with_flag[toughasnailsu_biome:<[biome]>].with_flag[toughasnailsu_leaf:<[leaf].script.name>]>

#--------------------------------
ToughAsNailsU_send_to_anabiosis:
    type: task
    debug: false
    script:
        - definemap attributes:
            GENERIC_MOVEMENT_SPEED:
                1:
                    operation: ADD_SCALAR
                    amount: -1

        - flag <player> ToughAsNailsU.anabiosis
        - adjust <player> add_attribute_modifiers:<[attributes]>
        #- adjust <player> passenger:<entity[ToughAsNailsU_anabiosis_entity]>
        - mount <entity[ToughAsNailsU_anabiosis_entity]>|<player> save:display
        - look <entry[display].mounted_entities.get[1]> pitch:0

        - run toughasnailsu_advancement_anabiosis
        #- adjust <player> spectate:<player.passenger>
        #/ex adjust <player> passenger:<entity[ToughAsNailsU_anabiosis_entity]>
        #- cast <player> jump durathide_particles no_icon no_clear
        #- wait 3s
        #- adjust <player> remove_attribute_modifiers:GENERIC_MOVEMENT_SPEED

ToughAsNailsU_remove_anabiosis:
    type: task
    debug: false
    script:
        - flag <player> ToughAsNailsU.anabiosis:!
        - adjust <player> remove_attribute_modifiers:GENERIC_MOVEMENT_SPEED
        #- adjust <player> spectate:<player>
        #- adjust <player> remove_attribute_modifiers:GENERIC_ATTACK_SPEED
        - if <player.has_passenger>:
            - if <player.passenger.name> == BLOCK_DISPLAY:
                - remove <player.passenger>

ToughAsNailsU_show_hud:
    type: task
    debug: false
    script:
        - define temperature <player.flag[ToughAsNailsU.temperature]>
        - define freeze_color <color[55,92,197]>
        - define heat_color <color[#f89523]>

        - if <player.has_flag[ToughAsNailsU.anabiosis]>:
            - define output_color <&color[255,255,255]>
            - define icon <&translate[hud.toughasnailsu.temperature.anabiosis]>
        - else:
            - define temperature_grows <player.has_flag[ToughAsNailsU.temperature_grows]>

            - if <player.has_flag[ToughAsNailsU.temperature_stabilization]>:
                - define icon <&translate[hud.toughasnailsu.temperature.body.normal]>
            - else if <[temperature_grows]>:
                - define icon <&translate[hud.toughasnailsu.temperature.body.grows]>
            - else:
                - define icon <&translate[hud.toughasnailsu.temperature.body.falls]>

            - if <[temperature]> > 0:
                - if <[temperature]> == 1020:
                    - define output_color <&color[255,255,255]>
                    - define icon <&translate[hud.toughasnailsu.temperature.heat.<util.random.int[1].to[3]>]>
                - else:
                    - define output_color <proc[toughasnailsu_temperature_color_calculator].context[<[heat_color]>|<[temperature]>]>
            - else:
                - if <[temperature]> == -1020:
                    - define output_color <&color[255,255,255]>
                    - define icon <&translate[hud.toughasnailsu.temperature.freeze.<util.random.int[1].to[3]>]>
                - else:
                    - define output_color <proc[toughasnailsu_temperature_color_calculator].context[<[freeze_color]>|<[temperature].mul[-1]>]>

        - define temperature_message <&font[toughasnailsu:font]><[output_color]><&font[toughasnailsu:font]><[icon]>
        - define temperature_message <[temperature_message].proc[hudu_get_ready_message].context[16|-8]>

        #-------------------------
        - if <player.has_effect[luck]>:
            - define thirst_type thirst_thirsty
        - else:
            - define thirst_type thirst

        - define thirst_message <&font[toughasnailsu:font]><&translate[toughasnailsu.<[thirst_type]>.hud.level.<player.flag[ToughAsNailsU.thirst].round>]>
        - define thirst_message <[thirst_message].proc[hudu_get_ready_message].context[82|8]>
        #-------------------------

        #- define oxygen:<player.oxygen.in_seconds>
        #- define max_oxygen:<player.max_oxygen.in_seconds>
        #
        #- if ( <[oxygen]> == <[max_oxygen]> ) || ( <[oxygen]> <= 0 ):
        #    - define oxygen_message:<&translate[space.-81]><&font[toughasnailsu]><&translate[toughasnailsu.oxygen.level.0]>
        #- else:
        #    - define oxygen_message:<&translate[space.-81]><&font[toughasnailsu]><&translate[toughasnailsu.oxygen.level.<[oxygen].div[<[max_oxygen]>].mul[20].round>]>

        #----------------------------
        - define overlay_message <&translate[space.-1024]><&translate[space.-1024]><&font[toughasnailsu:font]><&translate[hud.toughasnailsu.temperature.overlay]><&translate[space.-1024]><&translate[space.-1024]><&translate[space.-1]>
        - if <[temperature]> < -768:
            - define overlay_message <&color[<[freeze_color]>]><[overlay_message]>
        - else if <[temperature]> > 768:
            - define overlay_message <&color[<[heat_color]>]><[overlay_message]>
        - else:
            - define overlay_message <empty>

        #----------------------------
        - define final_message <[temperature_message]><&color[#4e5c24]><[thirst_message]><[overlay_message]>
        #<[temperature_message]><&color[#4e5c24]><[thirst_message]><[overlay_message]>

        - run hudu_create_ticket def:ToughAsNailsU|<[final_message]>

        ###- actionbar <[temperature_message]><&color[#4e5c24]><[thirst_message]><&color[#4e5c24]><[oxygen_message]><[overlay_message]> targets:<player>
        #- actionbar <&color[#4e5c24]><[thirst_message]> targets:<player>



ToughAsNailsU_adjust_thirst:
    type: task
    debug: false
    definitions: amount
    script:
        - define result:<player.flag[ToughAsNailsU.thirst].add[<[amount]>]>
        - if <[result]> < 20:
            - if <[result]> > 0:
                - flag <player> ToughAsNailsU.thirst:+:<[amount]>
            - else:
                - flag <player> ToughAsNailsU.thirst:0
        - else:
            - flag <player> ToughAsNailsU.thirst:20


ToughAsNailsU_adjust_temperature:
    type: task
    debug: false
    definitions: amount
    script:
        - define result <player.flag[ToughAsNailsU.temperature].add[<[amount]>]>
        - if <[result]> <= 1020:
            - if <[result]> >= -1020:
                - flag <player> ToughAsNailsU.temperature:+:<[amount]>
            - else:
                - flag <player> ToughAsNailsU.temperature:-1020
        - else:
            - flag <player> ToughAsNailsU.temperature:1020

ToughAsNailsU_autoupdate_hud:
    type: task
    debug: false
    script:
        - while <player.is_online>:
            - if <player.gamemode> matches SURVIVAL|ADVENTURE:
                - run ToughAsNailsU_show_hud def:<player>
            - else:
                - run hudu_clear_ticket def:ToughAsNailsU
            - wait 5t

ToughAsNailsU_autoupdate_thirst:
    type: task
    debug: false
    script:
        - while <player.is_online>:
            - if <player.is_spawned> && ( <player.gamemode> matches SURVIVAL|ADVENTURE ):

                - if <player.has_effect[luck]>:
                    - foreach <player.effects_data> as:effect:
                        - if <[effect].get[type]> == luck:
                            - run toughasnailsu_adjust_thirst def:<element[-0.05].mul[<[effect].get[amplifier].add[1]>]>
                            - foreach stop

                - if <player.flag[ToughAsNailsU.thirst]> == 0:
                    - hurt 0.3 <player> cause:STARVATION

            - wait 3t


ToughAsNailsU_autoupdate_temperature:
    type: task
    debug: false
    script:
        - define blocks_below_data <script[toughasnailsu_blocks_data].data_key[blocks_below]>
        - define blocks_around_impact 0

        - define armor_mul 1
        - define armor_add 0

        - define biome_humidity 0
        - define biome_temperature 0
        - define sun_final 0
        - define step 1

        - while <player.is_online>:
            - if <player.is_spawned> && ( <player.gamemode> matches SURVIVAL|ADVENTURE ):
                - define step:--

                - if <[step]> == 0:
                    - define step 21
                    - define blocks_around_impact <proc[ToughAsNailsU_blocks_around_calculator].context[<player.location>]>

                - else if <[step].mod[10]> == 0:
                    - define armor <proc[ToughAsNailsU_armor_impact_calculator].context[<player.equipment_map>]>
                    - define armor_mul <[armor].get[mul]>
                    - define armor_add <[armor].get[add]>

                - else if <[step].mod[7]> == 0:
                    - define biome_humidity <player.location.biome.humidity.round_to[5]>
                    - define biome_temperature <player.location.biome.base_temperature.round_to[5]>

                    - define sun <proc[toughasnailsu_true_sunlight].context[<player.location>]>
                    - define sun_final <[sun].sub[0.65].mul[11]>


                - define altitude_impact <player.location.y.round.sub[62].mul[-0.05]>

                - define block_below_impact <[blocks_below_data].get[<player.location.below[0.6].material.name>].if_null[0]>
                - define activity <player.is_sprinting.or[<player.swimming>].if_true[1].if_false[0]>
                - define wet <proc[ToughAsNailsU_in_water].context[<player>].if_true[1].if_false[0]>
                - define food <player.flag[ToughAsNailsU.food_temperature].if_null[0]>
                - define weather <proc[toughasnailsu_weather_type].context[<player.location>]>

                - define add_impact <[blocks_around_impact].add[<[block_below_impact]>].add[<[biome_temperature].sub[0.69].mul[38]>].add[<[altitude_impact]>].add[<[activity].mul[5]>].add[<[sun_final]>].add[<[armor_add]>].add[<[weather].mul[-10]>].add[<[wet].mul[-45]>]>
                - define mull_impact <[biome_humidity].add[0.8].mul[<[armor_mul]>]>
                - define result <[add_impact].mul[<[mull_impact]>].add[<[food]>]>


                ## FIRE RESISTANCE
                - if <player.has_effect[fire_resistance]> && <[result]> > 0:
                    - define result 0

                #- else:

                - define temperature <player.flag[ToughAsNailsU.temperature]>

                ## ADOPTATION
                - if ( <[temperature]> >= 0 && <[result]> > 0 ) || ( <[temperature]> <= 0 && <[result]> < 0 ):
                    - define result:*:0.5

                ## NATURAL RESTORE
                - if <[result].abs> < 13:
                    - flag <player> ToughAsNailsU.temperature_stabilization:true
                    - if <[temperature].abs> < 6:
                        - define final_result <[temperature].mul[-1]>
                    - else:
                        - define final_result <[temperature].is_less_than[0].if_true[6].if_false[-6]>

                - else:
                    - flag <player> ToughAsNailsU.temperature_stabilization:!
                    - define final_result <[result].mul[0.15]>



                ## APPLYING

                - define old_temperature <player.flag[ToughAsNailsU.temperature]>
                - run ToughAsNailsU_adjust_temperature def:<[final_result]>
                - define temperature <player.flag[ToughAsNailsU.temperature]>

                - if !<player.has_flag[ToughAsNailsU.anabiosis]>:
                    - if <[temperature]> == -1020:
                        - if <[old_temperature]> >= 0:
                            - run toughasnailsu_send_to_anabiosis
                        - else:
                            - adjust <player> freeze_duration:5s
                            - hurt 1 <player> cause:FREEZE
                            - run toughasnailsu_advancement_overfreeze
                    - else if <[temperature]> == 1020:
                        - adjust <player> fire_time:2s
                        - run toughasnailsu_advancement_overheat
                - else:
                    - if <[final_result]> > 0:
                        - run toughasnailsu_remove_anabiosis


                - if <[result]> > 0:
                    - flag <player> ToughAsNailsU.temperature_grows:true
                - else:
                    - flag <player> ToughAsNailsU.temperature_grows:!


                - if <server.has_flag[ToughAsNailsU.debug]>:
                    - define string "<green>temp:<player.flag[ToughAsNailsU.temperature]><white>|step:<[step]>|b_around:<[blocks_around_impact]> b_below:<[block_below_impact]>|biome:<player.location.biome.name> <yellow>hum:<[biome_humidity]> <green>temp:<[biome_temperature]><white>|altitude:<[altitude_impact]>|sun:<[sun]> sun_final:<[sun_final]>|activity:<[activity]>|wet:<[wet]>|food:<[food]> expire:<player.flag_expiration[ToughAsNailsU.food_temperature].from_now.formatted.if_null[0]>|weather:<[weather]>|armor_mul:<[armor_mul]>  armor_add:<[armor_add]>|result:<[result]>|<red>final_result:<[final_result]>"
                    - sidebar set title:ToughAsNailsU_autoupdate values:<[string]> players:<player>


            - else:
                - define step 1
                - define blocks_around_impact 0

            - wait 3t


#--------------------------------
ToughAsNailsU_base_actions:
    type: world
    debug: false
    events:
        after player joins:
            - if !<player.has_flag[ToughAsNailsU.thirst]>:
                - flag <player> ToughAsNailsU.thirst:20
            - if !<player.has_flag[ToughAsNailsU.temperature]>:
                - flag <player> ToughAsNailsU.temperature:0

            - run ToughAsNailsU_autoupdate_temperature
            - run ToughAsNailsU_autoupdate_thirst
            - run ToughAsNailsU_autoupdate_hud

            - if <player.has_flag[ToughAsNailsU.anabiosis]>:
                - run toughasnailsu_send_to_anabiosis

        after player respawns:
            - adjust <player> food_level:10
            - flag <player> ToughAsNailsU.thirst:10
            - flag <player> ToughAsNailsU.temperature:0
            - flag <player> ToughAsNailsU.food_temperature:0

            - if <player.has_flag[ToughAsNailsU.anabiosis]>:
                - run toughasnailsu_remove_anabiosis

        after player changes gamemode to creative:
            - sidebar remove
            - actionbar <empty>


ToughAsNailsU_actions:
    type: world
    debug: false
    events:
        on player changes food level:
            - define new <context.food>
            - define old <player.food_level>
            - if <context.item.if_null[null]> == null:
                - if <[new]> < <[old]>:
                    - run ToughAsNailsU_adjust_thirst def:-1

        after player consumes potion:
            - if <context.item.proc[utilsu_item_actual_name]> == FoodifyU_soup:
                - stop
            - run ToughAsNailsU_adjust_thirst def:3
            - if <context.item.effects_data.get[1].get[type]> matches WATER|MUNDANE|THICK:
                - if <util.random_chance[80]>:
                    - cast luck duration:20s amplifier:0 <player>

        on player consumes ToughAsNailsU_*:
            - determine cancelled passively
            - define item <context.item>
            - if <player.item_in_hand> == <[item]>:
                - define slot <player.held_item_slot>
            - else:
                - define slot 41

            - take slot:<[slot]> quantity:1

            - define item_stats <proc[toughasnailsu_get_food_stats].context[<[item]>]>
            - if <[item_stats]> != null:
                - run ToughAsNailsU_adjust_thirst def:<[item_stats].get[1]>
                - flag <player> ToughAsNailsU.food_temperature:<[item_stats].get[2]> expire:<[item_stats].get[3]>

            - if <[item].has_flag[ToughAsNailsU_dirty]>:
                - if <util.random_chance[80]>:
                    - cast luck duration:20s amplifier:0 <player> no_clear

            - if <[item].has_flag[ToughAsNailsU_beer]>:
                - if <util.random_chance[20]>:
                    - cast INCREASE_DAMAGE duration:15s amplifier:0 <player> no_clear
                - if <util.random_chance[20]>:
                    - cast blindness duration:7s amplifier:0 <player> no_clear

            - if <[item].has_flag[ToughAsNailsU_flask]>:
                - itemcooldown bundle duration:15t
                - inventory set o:<[item].flag[ToughAsNailsU_flask]> slot:<[slot]>
            - else:
                - give ToughAsNailsU_drinking_glass_bottle

        after player clicks block with:ToughAsNailsU_drinking_glass_bottle:
            - define location <player.eye_location.ray_trace[range=3.5;fluids=true;entities=*;ignore=<player>]||null>
            - if <[location]> == null:
                - stop
            - define item <proc[toughasnailsu_water_type].context[<[location].with_pose[<player>].forward[0.01]>]>
            - if <[item]> == null:
                - stop
            - take slot:<player.held_item_slot> quantity:1
            - give <[item]>

        on dispenser dispenses ToughAsNailsU_drinking_glass_bottle:
            - define item <proc[toughasnailsu_water_type].context[<context.location.with_facing_direction.forward[1]>]>
            - if <[item]> != null:
                - determine cancelled

        after dispenser dispenses ToughAsNailsU_drinking_glass_bottle cancelled:true:
            - define item <proc[toughasnailsu_water_type].context[<context.location.with_facing_direction.forward[1]>]>
            - if <[item]> != null:
                - take item:toughasnailsu_drinking_glass_bottle from:<context.location.inventory> quantity:1
                - drop <[item]> <context.location.center.with_facing_direction.forward[0.6]> delay:0 save:bottle
                - adjust <entry[bottle].dropped_entity> velocity:<context.velocity>

        after leaves decay:
            - if <util.random_chance[7]>:
                - drop <proc[toughasnailsu_leaf_type].context[<context.location>|<context.material.name>]> <context.location> quantity:1
        after player breaks *leaves:
            - if <context.material.persistent>:
                - stop
            - if <util.random_chance[<player.item_in_hand.enchantment_map.get[fortune].if_null[0].add[1].mul[7]>]>:
                - drop <proc[toughasnailsu_leaf_type].context[<context.location>|<context.material.name>]> <context.location> quantity:1

        on feather spawns:
            - if <context.item.has_flag[item]>:
                - determine cancelled

ToughAsNailsU_anabiosis_actions:
    type: world
    debug: false
    events:
        #on player walks flagged:ToughAsNailsU.anabiosis:
        #    - determine cancelled

        on player jumps flagged:ToughAsNailsU.anabiosis:
            - determine cancelled

        on player clicks block flagged:ToughAsNailsU.anabiosis:
            - determine cancelled

        on player damages entity flagged:ToughAsNailsU.anabiosis:
            - determine cancelled

        on ToughAsNailsU_anabiosis_entity exits vehicle:
            - if <context.entity.is_spawned>:
                - remove <context.entity>

        #on player kicked for flying:
        #    - determine cancelled passively
        #    - narrate <context.reason>

ToughAsNailsU_crafting_actions:
    type: world
    debug: false
    events:
        on ToughAsNailsU_special_bone_meal recipe formed:
            - if <context.inventory.contains[firework_star]>:
                - determine cancelled
            - define leaf <context.inventory.slot[<context.inventory.find_item[*leaf]>]>
            - determine <proc[ToughAsNailsU_get_special_bone_meal].context[<context.item>|<[leaf]>|<[leaf].flag[toughasnailsu_biome]>]>


        on firework_rocket recipe formed:
            - if <context.inventory.quantity_item[ToughAsNailsU_*_leaf]> != 0:
                - determine cancelled

        on ToughAsNailsU_* recipe formed:
            - if <proc[ToughAsNailsU_is_fixed_leaf].context[<context.item>]>:
                - if <context.inventory.contains[firework_star]>:
                    - determine cancelled

        on player crafts ToughAsNailsU_*:
            - define bottle_before <player.inventory.quantity_item[glass_bottle]>
            - wait 1t
            - define bottle_after <player.inventory.quantity_item[glass_bottle]>
            - take from:<context.inventory> item:glass_bottle quantity:1
            - take item:glass_bottle quantity:<[bottle_after].sub[<[bottle_before]>]>


        after item despawns:
            - if !<context.item.has_flag[ToughAsNailsU_to_beer]>:
                - stop

            - announce OK

            - if <context.location.light> <= 5:
                - define item <item[<context.item.flag[ToughAsNailsU_to_beer]>]>
                - drop <[item]> <context.location> speed:0 quantity:<context.item.quantity>
                - remove <context.entity>
            - else:
                - adjust <player> time_lived:0t
                - drop <context.item> <context.location> speed:0

            - playeffect spit <context.location> quantity:4 velocity:0,0.2,0
            - playsound <context.location> BLOCK_FIRE_EXTINGUISH volume:0.15

        ## TODO FIX IT
        #after cauldron level raises:
        #    - announce <context.cause>
        #    - define hopper <context.location.below>
        #    - if <context.location.below.material.name> != hopper:
        #        - stop
        #    - if !<context.location.below.material.switched>:
        #        - stop
        #    #- announce hopper_ok
#
        #    - if <context.cause> == NATURAL_FILL:
        #        #- announce natural
        #        - define output toughasnailsu_pure_water_bottle
        #    - else:
        #        #- announce dirty
        #        - define output toughasnailsu_dirty_water_bottle
#
        #    - repeat <context.new_level>:
        #        - if !<[hopper].inventory.contains_item[ToughAsNailsU_drinking_glass_bottle]>:
        #            - stop
        #        #- announce bottle_ok
#
        #        - if !<[hopper].inventory.can_fit[<[output]>].quantity[1]>:
        #            - stop
        #        #- announce availeble_slot
#
        #        - if <context.location.material.level.sub[1]> == 0:
        #            - modifyblock <context.location> cauldron
        #        - else:
        #            - adjustblock <context.location> level:<context.location.material.level.sub[1]>
#
        #        - take item:ToughAsNailsU_drinking_glass_bottle quantity:1 from:<[hopper].inventory>
        #        - give <[output]> quantity:1 to:<[hopper].inventory> ignore_leftovers
        #        #- announce OK



        #on player prepares anvil craft item:
        #    - define level:<context.item.enchantment_map.get[ToughAsNailsU_nailer].if_null[null]>
        #    - if <[level]> != null:
        #        - define lore:<context.item.lore.if_null[<list[]>]>
        #        - repeat <[lore].size> as:i:
        #            - if <[lore].get[<[i]>].contains[<&translate[toughasnailsu.enchantment.nailer]>]>:
        #                - define lore:<[lore].remove[<[i]>]>
        #                - repeat stop
        #        - define lore:<[lore].insert[<enchantment[ToughAsNailsU_nailer].full_name[<[level]>]>].at[1]>
        #        - determine <context.item.with[lore=<[lore]>]>
        #
        #on player prepares grindstone craft item:
        #    - define lore:<context.result.lore.if_null[<list[]>]>
        #    - repeat <[lore].size> as:i:
        #        - if <[lore].get[<[i]>].contains[<&translate[toughasnailsu.enchantment.nailer]>]>:
        #            - define lore:<[lore].remove[<[i]>]>
        #            - repeat stop
        #    - determine RESULT:<context.result.with[lore=<[lore]>]>


ToughAsNailsU_recipes_gui_actions:
    type: world
    debug: false
    events:
        after player right clicks item in ToughAsNailsU_recipes_gui:
            - run enoughitemsu_open_new_used_in_gui def:<context.item>|true|<context.inventory.script.name>
        after player left clicks item in ToughAsNailsU_recipes_gui:
            - run enoughitemsu_open_new_recipes_gui def:<context.item>|true|<context.inventory.script.name>

#------------------------
ToughAsNailsU_flask_put_in:
    type: procedure
    debug: false
    definitions: flask|item
    script:
        - define item_f <item[feather].with[custom_model_data=<[item].custom_model_data>;flag=item:<[item].script.name>]>

        - if <element[64].sub[<[flask].inventory_contents.size>]> >= <[item].quantity>:
            - define amount <[item].quantity>
            - define item <item[air]>
        - else:
            - define amount <element[64].sub[<[flask].inventory_contents.size>]>
            - define item <[item].with[quantity=<[item].quantity.sub[<[amount]>]>]>

        - define new_flask_content <[item_f].repeat_as_list[<[amount]>]>
        - define flask <[flask].with[inventory_contents=<[new_flask_content].include[<[flask].inventory_contents>]>]>

        - determine <map[flask=<[flask]>;item=<[item]>;amount=<[amount]>]>


ToughAsNailsU_flask_get_item:
    type: procedure
    debug: false
    definitions: flask
    script:
        - define item <[flask].inventory_contents.get[1]>
        - define flask <[flask].with[inventory_contents=<[flask].inventory_contents.remove[1]>]>

        - define item <item[<[item].flag[item]>]>
        - define item <[item].with[custom_model_data=<[flask].custom_model_data>]>
        - define item <[item].with[display=<[flask].display> <reset>[<[item].display><reset>]]>

        - define item <[item].with[flag=ToughAsNailsU_flask:<[flask]>]>
        - define item <[item].with[flag=ToughAsNailsU_unstackable:<util.random_uuid>]>

        - determine <[item]>


ToughAsNailsU_flask_back_to_flask:
    type: procedure
    debug: false
    definitions: item
    script:
        - define flask <[item].flag[ToughAsNailsU_flask]>
        - define item_f <item[feather].with[custom_model_data=<item[<[item].script.name>].custom_model_data>;flag=item:<[item].script.name>]>
        - define flask <[flask].with[inventory_contents=<[flask].inventory_contents.include[<[item_f]>]>]>

        - determine <[flask]>


ToughAsNailsU_flask_actions:
    type: world
    debug: false
    events:
        on ToughAsNailsU_flask_colored recipe formed:
            - define materials <context.recipe.parse_tag[<[parse_value].material.name>]>
            - define flask <context.recipe.get[<[materials].find[bundle]>]>
            - if <[flask].script.if_null[null]> != null:
                - define dye <[materials].get[<[materials].find_match[*_dye]>]>
                - define data <script[toughasnailsu_flask_data]>
                - define cmd <[data].data_key[flask_color_codes].get[<[dye]>].if_null[null]>
                - if <[cmd]> != null:
                    - define name <[data].data_key[flask_color_names].get[<[dye]>]>
                    - adjust def:flask custom_model_data:<[cmd]>
                    - adjust def:flask display:<reset><&translate[<[name]>]>
                    - determine <[flask]>
            - determine cancelled

        on player right clicks block with:ToughAsNailsU_flask using:either_hand:
            - determine cancelled passively
            - if <player.item_cooldown[bundle].in_ticks> == 0:
                - if <context.item.inventory_contents.size> > 0:
                    - inventory set slot:<context.hand> o:<context.item.proc[toughasnailsu_flask_get_item]>

        on player right clicks ToughAsNailsU_* in inventory with:air:
            - if <context.item.has_flag[ToughAsNailsU_flask]>:
                - determine cancelled passively
                - inventory set slot:<context.slot> o:<context.item.proc[toughasnailsu_flask_back_to_flask]> destination:<context.clicked_inventory>

        on player right clicks item in inventory with:ToughAsNailsU_flask:
            - determine cancelled passively

            - define flask <context.cursor_item>
            - define item <context.item>
            - if <[flask].inventory_contents.size> < 64:
                - if <proc[ToughAsNailsU_is_flaskable].context[<[item]>]>:
                    - define result <[flask].proc[toughasnailsu_flask_put_in].context[<[item]>]>
                    - adjust <player> item_on_cursor:<[result].get[flask]>
                    - inventory set o:<[result].get[item]> slot:<context.slot> d:<context.clicked_inventory>
                    - give toughasnailsu_drinking_glass_bottle quantity:<[result].get[amount]> to:<context.clicked_inventory>
                    - if <[result].get[flask].inventory_contents.size> == 64:
                        - run toughasnailsu_advancement_flask_full def:<[result].get[flask]>


        on player right clicks ToughAsNailsU_flask in inventory:
            - determine cancelled passively

            - define flask <context.item>
            - define item <context.cursor_item>
            - if <[flask].inventory_contents.size> < 64:
                - if <[item].proc[ToughAsNailsU_is_flaskable]>:
                    - define result <[flask].proc[toughasnailsu_flask_put_in].context[<[item]>]>
                    - adjust <player> item_on_cursor:<[result].get[item]>
                    - inventory set o:<[result].get[flask]> slot:<context.slot> d:<context.clicked_inventory>
                    - give toughasnailsu_drinking_glass_bottle quantity:<[result].get[amount]> to:<context.clicked_inventory>
                    - if <[result].get[flask].inventory_contents.size> == 64:
                        - run toughasnailsu_advancement_flask_full def:<[result].get[flask]>

#-------------------------------
ToughAsNailsU_recipes_gui:
    type: inventory
    inventory: CHEST
    title: <blue><bold>ToughAsNailsU
    size: 54
    gui: true
    definitions:
        a1: ToughAsNailsU_acacia_leaf
        a2: ToughAsNailsU_azalea_leaf
        a3: ToughAsNailsU_birch_leaf
        a4: ToughAsNailsU_cherry_leaf
        a5: ToughAsNailsU_dark_oak_leaf
        a6: ToughAsNailsU_jungle_leaf
        a7: ToughAsNailsU_mangrove_leaf
        a8: ToughAsNailsU_oak_leaf
        a9: ToughAsNailsU_spruce_leaf

        b1: ToughAsNailsU_drinking_glass_bottle
        b2: ToughAsNailsU_flask
        b3: ToughAsNailsU_flask_colored
        b4: ToughAsNailsU_nailer_enchanted_book
        b5: ToughAsNailsU_special_bone_meal

        c1: ToughAsNailsU_dirty_water_bottle
        c2: ToughAsNailsU_sea_water_bottle
        c3: ToughAsNailsU_pure_water_bottle
        c4: ToughAsNailsU_boiling_water_bottle

        d1: ToughAsNailsU_green_sweet_berry_tea_bottle
        d2: ToughAsNailsU_green_glow_berry_tea_bottle
        d3: ToughAsNailsU_green_sugar_tea_bottle

        e1: ToughAsNailsU_melon_juice_bottle
        e2: ToughAsNailsU_carrot_juice_bottle
        e3: ToughAsNailsU_sweet_berries_juice_bottle
        e4: ToughAsNailsU_amethyst_water_bottle

        f1: ToughAsNailsU_wheat_wort_bottle
        f2: ToughAsNailsU_wheat_beer_bottle

        f3: ToughAsNailsU_raw_milk_cacao_bottle
        f4: ToughAsNailsU_milk_cacao_bottle

    slots:
    - [a1] [a2] [a3] [a4] [a5] [a6] [a7] [a8] [a9]
    - [b1] [b2] [b3] [b4] [] [] [] [] [b5]
    - [c1] [c2] [c3] [c4] [] [] [] [] []
    - [d1] [d2] [d3] [] [] [] [] [] []
    - [e1] [e2] [e3] [e4] [] [] [] [] []
    - [f1] [f2] [f3] [f4] [] [] [] [] []

#-------------------------------
ToughAsNailsU_commands:
    type: command
    debug: false
    name: ToughAsNailsU
    description: ToughAsNailsU
    usage: /ToughAsNailsU
    aliases:
        - tanu
    tab completions:
        1: items

    #permission: ToughAsNailsU.admin
    script:
        - inventory open destination:ToughAsNailsU_recipes_gui


ToughAsNailsU_debug_command:
    type: command
    name: tdebug
    description: tdebug
    usage: /tdebug
    permission: ToughAsNailsU.admin
    debug: false
    script:
        - if <server.has_flag[ToughAsNailsU.debug]>:
            - flag server ToughAsNailsU.debug:!
            - sidebar remove players:<server.online_players>
        - else:
            - flag server ToughAsNailsU.debug:true