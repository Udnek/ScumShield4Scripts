



RpgU_equipable_mobs_data:
    type: data

    mobs:
        zombie:
            - 1.3
            - overword
        zombie_villager:
            - 1
            - overword
        skeleton:
            - 1
            - overword
        husk:
            - 1.7
            - overword
        stray:
            - 1.3
            - overword
        drowned:
            - 1
            - underwater

        #evoker: 2
        #pillager: 2
        #vindicator: 2

        piglin_brute:
            - 3
            - piglin
        piglin:
            - 2
            - piglin
        zombified_piglin:
            - 2
            - piglin
        wither_skeleton:
            - 3
            - nether

    equipment:
        overword:
            armor:
                1:
                    leather_helmet: 5
                    chainmail_helmet: 8
                    golden_helmet: 5
                    iron_helmet: 3
                    diamond_helmet: 1
                2:
                    leather_chestplate: 5
                    chainmail_chestplate: 8
                    golden_chestplate: 5
                    iron_chestplate: 3
                    diamond_chestplate: 1
                3:
                    leather_leggings: 5
                    chainmail_leggings: 8
                    golden_leggings: 5
                    iron_leggings: 3
                    diamond_leggings: 1
                4:
                    leather_boots: 5
                    chainmail_boots: 8
                    golden_boots: 5
                    iron_boots: 3
                    diamond_boots: 1

        underwater:
            armor:
                1:
                    leather_helmet: 8
                    turtle_helmet: 4
                    iron_helmet: 1
                    diamond_helmet: 1
                2:
                    leather_chestplate: 8
                    iron_chestplate: 1
                    diamond_chestplate: 1
                3:
                    leather_leggings: 8
                    iron_leggings: 1
                    diamond_leggings: 1
                4:
                    leather_boots: 8
                    iron_boots: 1
                    diamond_boots: 1

        piglin:
            armor:
                1:
                    golden_helmet: 1
                    diamond_helmet: 1
                    netherite_helmet: 1
                2:
                    golden_chestplate: 1
                    diamond_chestplate: 1
                    netherite_helmet: 1
                3:
                    golden_leggings: 1
                    diamond_leggings: 1
                    netherite_helmet: 1
                4:
                    golden_boots: 1
                    diamond_boots: 1
                    netherite_helmet: 1

        nether:
            armor:
                1:
                    iron_helmet: 1
                    diamond_helmet: 1
                    netherite_helmet: 1
                2:
                    iron_chestplate: 1
                    diamond_chestplate: 1
                    netherite_helmet: 1
                3:
                    iron_leggings: 1
                    diamond_leggings: 1
                    netherite_helmet: 1
                4:
                    iron_boots: 1
                    diamond_boots: 1
                    netherite_helmet: 1


RpgU_choose_random_equipment:
    type: procedure
    debug: false
    definitions: type|number
    script:
        - define data <static[<script[rpgu_equipable_mobs_data].data_key[equipment]>]>
        - define equip_data <[data].deep_get[<[type]>.armor.<[number]>]>
        - define roll <list[]>
        - foreach <[equip_data]> key:item_name as:weight:
            - define roll <[roll].include[<[item_name].repeat_as_list[<[weight]>]>]>

        - determine <[roll].random>


RpgU_generate_equipment_for_mob:
    type: procedure
    debug: false
    definitions: entity
    script:
        - define loc <[entity].location>
        - if <[loc].world.environment> == NORMAL:
            - define altitude_mul <element[1].sub[<[loc].y.add[64].div[<static[<[loc].world.max_height.add[64]>]>]>].round_to[2].add[0.4]>
            - define altitude_mul:*:<[altitude_mul]>
        - else:
            - define altitude_mul 1

        - define local_diff_mul <[loc].local_difficulty.div[1.5].round_to[2]>
        - define mob_data <script[rpgu_equipable_mobs_data].data_key[mobs.<[entity].entity_type>]>
        - define mob_diff_mul <[mob_data].get[1]>
        - define mob_type <[mob_data].get[2]>
        - define level <[altitude_mul].mul[<[local_diff_mul]>].mul[<[mob_diff_mul]>]>

        #- announce alt_mul=<[altitude_mul]><&nl>local_diff_mul=<[local_diff_mul]><&nl>mob_diff_mul=<[mob_diff_mul]><&nl><red>lvl=<[level]>

        - define eqiupment <list[]>
        - foreach <[entity].equipment> as:item:
            - if <[item].material.name> == air && <util.random_chance[<[level].mul[7]>]>:
                - define new_item <item[<[mob_type].proc[rpgu_choose_random_equipment].context[<element[5].sub[<[loop_index]>]>]>]>
                - define item_type <[new_item].proc[rpgu_item_type]>
                - define item_slot <[new_item].proc[rpgu_get_default_attributes].proc[rpgu_attributes_to_slot]>
                - define new_item <[new_item].proc[rpgu_generate_attributes].context[<[item_type]>|<[level]>|NULL|<[item_slot]>]>
                - define eqiupment:->:<[new_item]>
            - else:
                - define eqiupment:->:<[item].material.name>

        - determine <[eqiupment]>


RpgU_is_equippable:
    type: procedure
    debug: false
    definitions: entity
    script:
        - if <static[<script[rpgu_equipable_mobs_data].data_key[mobs].keys>].contains[<[entity].entity_type>]>:
            - determine true
        - determine false


RpgU_spawn_events:
    type: world
    debug: false
    events:
        on entity spawns:
            - if <context.entity.proc[rpgu_is_equippable]>:
                - adjust <context.entity> equipment:<context.entity.proc[rpgu_generate_equipment_for_mob]>


        on entity dies:
            - if !<context.entity.proc[rpgu_is_equippable]>:
                - stop

            - define new_drops <list[]>
            - foreach <context.drops> as:item:
                - if <[item].proc[rpgu_can_have_upgrades]>:
                    - if <util.random_chance[90]>:
                        - define new_drops:->:<[item].proc[rpgu_stone_from_item]>
                    - else:
                        - define new_drops:->:<[item]>
                - else:
                    - define new_drops:->:<[item]>

            - determine <[new_drops]>

