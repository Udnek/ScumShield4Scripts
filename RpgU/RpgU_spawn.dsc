RpgU_equipable_mobs_data:
    type: data

    mobs:
        zombie:
            level_mul: 1.3
            type: overword
        zombie_villager:
            level_mul: 1
            type: overword
        skeleton:
            level_mul: 1
            type: overword
        husk:
            level_mul: 1.7
            type: overword
        stray:
            level_mul: 1.3
            type: overword
        drowned:
            level_mul: 1
            type: underwater

        #evoker: 2
        #pillager: 2
        #vindicator: 2

        piglin_brute:
            level_mul: 3
            type: piglin
        piglin:
            level_mul: 2
            type: piglin
        zombified_piglin:
            level_mul: 2
            type: piglin
        wither_skeleton:
            level_mul: 3
            type: nether

    equipment:
        overword:
            armor:
                1:
                    air: 20
                    leather_helmet: 5
                    chainmail_helmet: 8
                    golden_helmet: 5
                    iron_helmet: 3
                    diamond_helmet: 1
                2:
                    air: 20
                    leather_chestplate: 5
                    chainmail_chestplate: 8
                    golden_chestplate: 5
                    iron_chestplate: 3
                    diamond_chestplate: 1
                3:
                    air: 20
                    leather_leggings: 5
                    chainmail_leggings: 8
                    golden_leggings: 5
                    iron_leggings: 3
                    diamond_leggings: 1
                4:
                    air: 20
                    leather_boots: 5
                    chainmail_boots: 8
                    golden_boots: 5
                    iron_boots: 3
                    diamond_boots: 1

            weapon:
                air: 30
                wooden_sword: 3
                stone_sword: 10
                golden_sword: 3
                iron_sword: 3
                diamond_sword: 1

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

            weapon:
                air: 30
                wooden_sword: 3
                iron_sword: 3
                diamond_sword: 1
                trident: 3

        piglin:
            armor:
                1:
                    air: 10
                    golden_helmet: 1
                    diamond_helmet: 1
                    netherite_helmet: 1
                2:
                    air: 10
                    golden_chestplate: 1
                    diamond_chestplate: 1
                    netherite_helmet: 1
                3:
                    air: 10
                    golden_leggings: 1
                    diamond_leggings: 1
                    netherite_helmet: 1
                4:
                    air: 10
                    golden_boots: 1
                    diamond_boots: 1
                    netherite_helmet: 1

            weapon:
                air: 30
                wooden_sword: 3
                stone_sword: 3
                golden_sword: 10
                iron_sword: 3
                diamond_sword: 1
                netherite_sword: 1

        nether:
            armor:
                1:
                    air: 10
                    iron_helmet: 1
                    diamond_helmet: 1
                    netherite_helmet: 1
                2:
                    air: 10
                    iron_chestplate: 1
                    diamond_chestplate: 1
                    netherite_helmet: 1
                3:
                    air: 10
                    iron_leggings: 1
                    diamond_leggings: 1
                    netherite_helmet: 1
                4:
                    air: 10
                    iron_boots: 1
                    diamond_boots: 1
                    netherite_helmet: 1

            weapon:
                air: 30
                stone_sword: 14
                golden_sword: 3
                iron_sword: 3
                diamond_sword: 2
                netherite_sword: 1

#----------------------

RpgU_choose_random_armor:
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


RpgU_choose_random_weapon:
    type: procedure
    debug: false
    definitions: type
    script:
        - define data <static[<script[rpgu_equipable_mobs_data].data_key[equipment]>]>
        - define equip_data <[data].deep_get[<[type]>.weapon]>
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
        - define mob_diff_mul <[mob_data].get[level_mul]>
        - define mob_type <[mob_data].get[type]>

        - define level <[altitude_mul].mul[<[local_diff_mul]>].mul[<[mob_diff_mul]>]>

        #- announce <red>lvl=<[level]>>

        - define armor <list[]>
        - foreach <[entity].equipment> as:item:
            - if <[item].material.name> != air:
                - define new_item <[item]>
            - else:
                - define new_item <item[<[mob_type].proc[rpgu_choose_random_armor].context[<element[5].sub[<[loop_index]>]>]>]>

            - if <[new_item].material.name> != air:
                - define item_type <[new_item].proc[rpgu_item_type]>
                - define item_slot <[new_item].proc[rpgu_get_default_attributes].proc[rpgu_attributes_to_slot]>
                - define new_item <[new_item].proc[rpgu_generate_attributes].context[<[item_type]>|<[level]>|NULL|<[item_slot]>]>
                - define armor:->:<[new_item]>
            - else:
                - define armor:->:<item[air]>

        - if <[entity].item_in_hand.material.name> == air:
            - define weapon <item[<[mob_type].proc[rpgu_choose_random_weapon]>]>
            - if <[weapon].proc[rpgu_can_have_upgrades]>:
                - define item_type <[weapon].proc[rpgu_item_type]>
                - define weapon <[weapon].proc[rpgu_generate_attributes].context[<[item_type]>|<[level]>|NULL|HAND]>
        - else:
            - define weapon <[entity].item_in_hand>

        - determine <map[armor=<[armor]>;weapon=<[weapon]>]>


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
                - define equipment <context.entity.proc[rpgu_generate_equipment_for_mob]>
                - adjust <context.entity> equipment:<[equipment].get[armor]>
                - adjust <context.entity> item_in_hand:<[equipment].get[weapon]>


        on entity dies:
            - if !<context.entity.proc[rpgu_is_equippable]>:
                - stop

            - define new_drops <list[]>
            - foreach <context.drops> as:item:
                - if <[item].proc[rpgu_can_have_upgrades]>:
                    - define stone <[item].proc[rpgu_item_to_stone]>
                    - if !<[stone].attribute_modifiers.proc[rpgu_is_attributes_zero]>:
                        - define new_drops:->:<[item].proc[rpgu_item_to_stone]>
                    #- if <util.random_chance[90]>:
                    #    - define new_drops:->:<[item].proc[rpgu_item_to_stone]>
                    #- else:
                    #    - define new_drops:->:<[item]>
                - else:
                    - define new_drops:->:<[item]>

            - determine <[new_drops]>

