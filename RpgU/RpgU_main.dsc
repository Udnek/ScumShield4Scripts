RpgU_can_apply_stone:
    type: procedure
    debug: false
    definitions: item|stone
    script:
        - if <[item].attribute_modifiers.proc[rpgu_attributes_to_slot]> == <[stone].attribute_modifiers.proc[rpgu_attributes_to_slot]>:
            - determine true
        - determine false


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


RpgU_apply_upgrade_stone:
    type: procedure
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

        - determine <[item].proc[rpgu_merge_attributes]>


RpgU_stone_from_item:
    type: procedure
    debug: false
    definitions: item
    script:
        #- define item_attr_sum <[item].proc[rpgu_attributes_sum]>
        #- define attr_slot <[item].attribute_modifiers.proc[rpgu_attributes_to_slot]>
        #- define default_attr_sum <[item].default_attribute_modifiers[<[attr_slot]>].proc[rpgu_attributes_sum]>
        - define default_attr_sum <[item].proc[rpgu_get_default_attributes].proc[rpgu_attributes_sum]>

        - define stone <item[rpgu_upgrade_stone]>
        - adjust def:stone add_attribute_modifiers:<[item].attribute_modifiers>

        - foreach <[default_attr_sum]> key:attr_name as:values1:
            - foreach <[values1]> key:slot as:values2:
                - foreach <[values2]> key:operation as:amount:
                    - define attribute <map[<[attr_name]>=<map[operation=<[operation]>;amount=<[amount].mul[-1]>;slot=<[slot]>]>]>
                    - adjust def:stone add_attribute_modifiers:<[attribute]>

        - determine <[stone].proc[rpgu_merge_attributes]>


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

# TODO DO NOT WORK
RpgU_generate_lore:
    type: procedure
    debug: false
    definitions: item
    script:
        - define attrs <[item].attribute_modifiers>
        - define attrs_sum <map[]>
        - foreach <[attrs]> key:attr_name as:attr_list:
            - foreach <[attr_list]> as:attr:
                #- if <[attr_sum].contains[<[attr_name]>]>:
                #- if <[attr_sum].get[<[attr_name]>].get[operation]> == <[attr].get[operation]>:
                - define attrs_sum.<[attr_name]>.<[attr].get[operation]>:+:<[attr].get[amount]>
                #- else:
                #    - define attr_sum.<[attr_name]>:<[attr].get[amount]>


        - define lore <&translate[item.modifiers.<[attrs].get[].get[slot]>]>
        - foreach <[attrs_sum].get_subset[<[attrs_sum].keys.sort_by_value[]>]> key:attr_name as:values:
            - foreach <[values]> key:operation as:amount:

                - define attr_name_translated <&translate[attribute.name.generic.<[attr_name].after[GENERIC_].to_lowercase>]>

                - if <[operation]> == ADD_SCALAR:
                    - define amount_suffix %
                    - define amount:*:100
                - else if <[attr_name]> == GENERIC_KNOCKBACK_RESISTANCE:
                    - define amount_suffix %
                    - define amount:*:100
                - else:
                    - define amount_suffix <empty>

                - if <[amount]> > 0:
                    - define color <color[green]>
                    - define amount +<[amount]>
                - else:
                    - define color <color[red]>

                - define lore "<[lore]><&nl><&color[<[color]>]><[amount]><[amount_suffix]> <[attr_name_translated]>"

        - determine <[item].with[lore=<[lore]>]>


RpgU_generate_upgrade_stone:
    type: procedure
    definitions: item_type|level|level_type|slot
    script:
        - define item <item[rpgu_upgrade_stone]>
        - determine <[item].proc[rpgu_generate_attributes].context[<[item_type]>|<[level]>|<[level_type]>|<[slot]>]>

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
                            - define amount <util.random.decimal[-0.01].to[0.01].mul[<[level]>].round_to[1]>
                            - define operation ADD_SCALAR

                - case generic_attack_speed:
                    - choose <[item_type]>:
                        - case sword:
                            - define amount <util.random.decimal[-0.05].to[0.06].mul[<[level]>].round_to[1]>
                        - case axe:
                            - define amount <util.random.decimal[-0.03].to[0.04].mul[<[level]>].round_to[1]>
                        - case trident:
                            - define amount <util.random.decimal[-0.06].to[0.07].mul[<[level]>].round_to[1]>
                        # armor and tool
                        - default:
                            - define amount <util.random.decimal[-0.03].to[0.04].mul[<[level]>].round_to[1]>
                        - define operation ADD_SCALAR

                - case generic_movement_speed:
                    - if <[item_type]> == sword:
                        - define amount <util.random.decimal[-0.1].to[0.1].mul[<[level]>].round_to[1]>
                    - else:
                        - define amount <util.random.decimal[-0.02].to[0.02].mul[<[level]>].round_to[1]>
                    - define operation ADD_SCALAR

                - case generic_knockback_resistance:
                    - define amount <util.random.decimal[-0.05].to[0.05].mul[<[level]>].round_to[1]>
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
