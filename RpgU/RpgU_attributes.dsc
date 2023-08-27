RpgU_is_attributes_zero:
    type: procedure
    debug: false
    definitions: attributes
    script:
        - foreach <[attributes]> key:attr_name as:attrs_list:
            - foreach <[attrs_list]> as:attr:
                - if <[attr].get[amount]> != 0:
                    - determine false
        - determine true


RpgU_attributes_to_slot:
    type: procedure
    debug: false
    definitions: attributes
    script:
        - determine <[attributes].get[<[attributes].keys.first>].get[1].get[slot]>


RpgU_attributes_sum:
    type: procedure
    debug: false
    definitions: attributes
    script:
        - define attrs_sum <map[]>
        - foreach <[attributes]> key:attr_name as:attrs_list:
            - foreach <[attrs_list]> as:attr:
                - define attrs_sum.<[attr_name]>.<[attr].get[slot]>.<[attr].get[operation]>:+:<[attr].get[amount]>
        - determine <[attrs_sum]>


RpgU_attack_speed_to_percent:
    type: procedure
    debug: false
    definitions: number
    script:
        - determine <[number].div[4]>


RpgU_merge_attributes:
    type: procedure
    debug: false
    definitions: item
    script:
        - define attrs <[item].attribute_modifiers>
        - define attrs_sum <[attrs].proc[rpgu_attributes_sum]>
        - adjust def:item remove_attribute_modifiers:<[attrs].keys>

        - foreach <[attrs_sum]> key:attr_name as:values1:
            - foreach <[values1]> key:slot as:values2:
                - foreach <[values2]> key:operation as:amount:
                    - define attribute <map[<[attr_name]>=<map[operation=<[operation]>;amount=<[amount]>;slot=<[slot]>]>]>
                    - adjust def:item add_attribute_modifiers:<[attribute]>

        - determine <[item]>


RpgU_get_default_attributes:
    type: procedure
    debug: false
    definitions: item
    script:
        - define result <map[]>
        - foreach <list[HAND|OFF_HAND|FEET|LEGS|CHEST|HEAD]> as:slot:
            - foreach <[item].default_attribute_modifiers[<[slot]>]> key:attr_name as:attr_list:
                - foreach <[attr_list]> as:attr:
                    - if <[attr_name]> == GENERIC_ATTACK_SPEED:
                        - define attr.operation ADD_SCALAR
                        - define attr.amount <[attr].get[amount].proc[rpgu_attack_speed_to_percent]>
                    - define attr.id:!
                    - define result.<[attr_name]>:->:<[attr]>
        - determine <[result]>


RpgU_generate_attributes:
    type: procedure
    debug: false
    definitions: item|item_type|level|level_type|slot
    script:

        #- define level <[level].round>
        #generic_knockback_resistance
        #- define all_attr <list[generic_max_health|generic_armor|generic_armor_toughness|generic_attack_damage|generic_attack_speed|generic_movement_speed|generic_knockback_resistance]>
        - definemap attributes:
            sword:
                - generic_attack_damage
                - generic_attack_speed
                - generic_movement_speed

            axe:
                - generic_attack_damage
                - generic_attack_speed
                - generic_movement_speed

            trident:
                - generic_attack_damage
                - generic_attack_speed
                - generic_movement_speed

            tool:
                - generic_attack_damage
                - generic_attack_speed
                - generic_movement_speed

            armor:
                - generic_max_health
                - generic_movement_speed
                - generic_attack_damage
                - generic_armor
                - generic_armor_toughness
                - generic_knockback_resistance

            #shield: generic_armor|generic_armor_toughness|generic_attack_damage|generic_attack_speed|generic_movement_speed|generic_knockback_resistance]>

        - define appl_attr <[attributes].get[<[item_type]>]>
        - define appl_attr <[appl_attr].random[<util.random.int[1].to[<[level].round>]>]>

        - if <[item].attribute_modifiers.keys.size> == 0:
            - adjust def:item add_attribute_modifiers:<[item].proc[rpgu_get_default_attributes]>


        - foreach <[appl_attr]> as:attr_name:
            - choose <[attr_name]>:

                - case generic_max_health:
                    - define amount <util.random.decimal[-0.4].to[0.5].mul[<[level]>].round>
                    - define operation ADD_NUMBER

                - case generic_armor:
                    - define amount <util.random.decimal[-0.5].to[0.3].mul[<[level]>].round>
                    - define operation ADD_NUMBER

                - case generic_armor_toughness:
                    - define amount <util.random.decimal[-0.4].to[0.5].mul[<[level]>].round>
                    - define operation ADD_NUMBER

                - case generic_attack_damage:
                    - define operation ADD_NUMBER
                    - choose <[item_type]>:
                        - case sword:
                            - define amount <util.random.decimal[-0.4].to[0.5].mul[<[level]>].round>
                        - case axe:
                            - define amount <util.random.decimal[-0.6].to[0.7].mul[<[level]>].round>
                        - case trident:
                            - define amount <util.random.decimal[-0.6].to[0.9].mul[<[level]>].round>

                        # armor and tool
                        - default:
                            - define amount <util.random.decimal[-0.01].to[0.01].mul[<[level]>].round_to[2]>
                            - define operation ADD_SCALAR

                - case generic_attack_speed:
                    - choose <[item_type]>:
                        - case sword:
                            - define amount <util.random.decimal[-0.05].to[0.06].mul[<[level]>].round_to[2]>
                        - case axe:
                            - define amount <util.random.decimal[-0.03].to[0.04].mul[<[level]>].round_to[2]>
                        - case trident:
                            - define amount <util.random.decimal[-0.06].to[0.07].mul[<[level]>].round_to[2]>
                        # armor and tool
                        - default:
                            - define amount <util.random.decimal[-0.03].to[0.04].mul[<[level]>].round_to[2]>
                    - define operation ADD_SCALAR

                - case generic_movement_speed:
                    - if <[item_type]> == sword:
                        - define amount <util.random.decimal[-0.1].to[0.1].mul[<[level]>].round_to[2]>
                    - else:
                        - define amount <util.random.decimal[-0.015].to[0.02].mul[<[level]>].round_to[2]>
                    - define operation ADD_SCALAR

                - case generic_knockback_resistance:
                    - define amount <util.random.decimal[-0.04].to[0.05].mul[<[level]>].round_to[2]>
                    - define operation ADD_NUMBER


            - define attribute <map[<[attr_name]>=<map[operation=<[operation]>;amount=<[amount]>;slot=<[slot]>]>]>
            - adjust def:item add_attribute_modifiers:<[attribute]>

        - define item <[item].proc[RpgU_merge_attributes]>

        - determine <[item]>


RpgU_item_type:
    type: procedure
    debug: false
    definitions: item
    script:
        - define item_name <[item].material.name>

        - if <[item_name]> matches *sword:
            - determine sword
        - else if <[item_name]> matches *axe:
            - determine axe
        - else if <[item_name]> == trident:
            - determine trident
        - else if <[item_name]> matches *hoe|*shovel|*pickaxe:
            - determine tool

        - determine armor


RpgU_can_have_upgrades:
    type: procedure
    debug: false
    definitions: item
    script:
        - if <[item].proc[rpgu_get_default_attributes].size> == 0:
            - determine false
        - determine true

RpgU_real_attributes:
    type: procedure
    debug: false
    definitions: item
    script:
        - if <[item].attribute_modifiers.size> == 0:
            - determine <[item].proc[rpgu_get_default_attributes]>
        - determine <[item].attribute_modifiers>
#----------------------------- STONE
RpgU_can_apply_stone:
    type: procedure
    debug: false
    definitions: item|stone
    script:
        - if <[stone].attribute_modifiers.size> == 0:
            - determine false
        - if <[item].proc[rpgu_real_attributes].proc[rpgu_attributes_to_slot]> == <[stone].attribute_modifiers.proc[rpgu_attributes_to_slot]>:
            - if <[item].proc[rpgu_stones_applied_amount]> < 3:
                - determine true
        - determine false

RpgU_apply_upgrade_stone:
    type: procedure
    debug: false
    definitions: item|stone
    script:
        - define attrs_sum_stone <[stone].attribute_modifiers.proc[rpgu_attributes_sum]>

        - if <[item].attribute_modifiers.size> == 0:
            - adjust def:item add_attribute_modifiers:<[item].proc[rpgu_get_default_attributes]>

        - define attrs_main_slot <[item].attribute_modifiers.proc[rpgu_attributes_to_slot]>

        - foreach <[attrs_sum_stone]> key:attr_name as:values1:
            - foreach <[values1]> key:slot as:values2:
                - foreach <[values2]> key:operation as:amount:
                    - if <[slot]> == <[attrs_main_slot]>:
                        - define attribute <map[<[attr_name]>=<map[operation=<[operation]>;amount=<[amount]>;slot=<[slot]>]>]>
                        - adjust def:item add_attribute_modifiers:<[attribute]>

        - define item <[item].with_flag[RpgU.upgrade_stones:+:1].proc[rpgu_merge_attributes].proc[rpgu_generate_lore]>
        - determine <[item]>

RpgU_stones_applied_amount:
    type: procedure
    debug: false
    definitions: item
    script:
        - if <[item].has_flag[RpgU.upgrade_stones]>:
            - determine <[item].flag[RpgU.upgrade_stones]>
        - determine 0

RpgU_item_to_stone:
    type: procedure
    debug: false
    definitions: item
    script:
        - define default_attr_sum <[item].proc[rpgu_get_default_attributes].proc[rpgu_attributes_sum]>

        - if <[item].attribute_modifiers.size> == 0:
            - adjust def:item add_attribute_modifiers:<[item].proc[rpgu_get_default_attributes]>

        - define stone <item[rpgu_upgrade_stone]>
        - adjust def:stone add_attribute_modifiers:<[item].attribute_modifiers>

        - foreach <[default_attr_sum]> key:attr_name as:values1:
            - foreach <[values1]> key:slot as:values2:
                - foreach <[values2]> key:operation as:amount:
                    - define attribute <map[<[attr_name]>=<map[operation=<[operation]>;amount=<[amount].mul[-1]>;slot=<[slot]>]>]>
                    - adjust def:stone add_attribute_modifiers:<[attribute]>

        - define stone <[stone].proc[rpgu_merge_attributes]>
        - define item_extra_data <[stone].attribute_modifiers.proc[rpgu_attributes_to_slot].proc[rpgu_slot_to_data]>
        - define lore <gray><&translate[item.rpgu.upgrade_stone]><&nl><&nl><gray><&translate[item.minecraft.smithing_template.applies_to]><&nl><&translate[item.rpgu.upgrade_stone.space_before_type]><&translate[<[item_extra_data].get[lore]>]>
        - determine <[stone].with[custom_model_data=<[item_extra_data].get[cmd]>;lore=<[lore]>]>

RpgU_generate_upgrade_stone:
    type: procedure
    definitions: item_type|level|level_type|slot
    script:
        - define item <item[rpgu_upgrade_stone]>
        - determine <[item].proc[rpgu_generate_attributes].context[<[item_type]>|<[level]>|<[level_type]>|<[slot]>]>
#-----------------------------

