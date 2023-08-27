RpgU_item_data:
    type: data
    slots:
        HEAD:
            cmd: 100000
            lore: item.rpgu.upgrade_stone.lore.helmet
        CHEST:
            cmd: 100001
            lore: item.rpgu.upgrade_stone.lore.chestplate
        LEGS:
            cmd: 100002
            lore: item.rpgu.upgrade_stone.lore.leggings
        FEET:
            cmd: 100003
            lore: item.rpgu.upgrade_stone.lore.boots
        HAND:
            cmd: 100004
            lore: item.rpgu.upgrade_stone.lore.weapon


RpgU_slot_to_data:
    type: procedure
    debug: false
    definitions: slot
    script:
        - determine <script[rpgu_item_data].data_key[slots.<[slot]>]>


RpgU_upgrade_stone:
    type: item
    debug: false
    material: paper #netherite_upgrade_smithing_template
                #paper
    display name: <reset><&translate[item.minecraft.smithing_template]>
    mechanisms:
        hides: ITEM_DATA
        custom_model_data: 100004


RpgU_upgrade_stone_technical_craft:
    type: item
    debug: false
    material: nether_brick
    recipes:
       1:
           type: smithing
           template: material:<item[RpgU_upgrade_stone].material.name>
           base: material:<server.material_types.filter[is_item].parse[name.as[item]].filter[proc[RpgU_can_have_upgrades]].parse[material.name].separated_by[/]>
           upgrade: material:copper_ingot


RpgU_smithing_events:
    type: world
    debug: false
    events:
        #on player prepares smithing item:
        #    - define template <context.inventory.list_contents.get[1].if_null[<item[air]>]>
        #    - define main_item <context.inventory.list_contents.get[2].if_null[<item[air]>]>
        #    - define material <context.inventory.list_contents.get[3].if_null[<item[air]>]>
#
        #    - if <[template]>|<[main_item]>|<[material]> contains <item[air]>:
        #        - determine <item[air]>
#
        #    #- narrate "<&color[<util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>]><[template]> <[main_item]> <[material]>"
#
        #    - if <[template].proc[utilsu_item_actual_name]> != RpgU_upgrade_stone:
        #        - if ( <[main_item].proc[rpgu_item_type]> == armor ) or ( <[main_item].material.name.advanced_matches[diamond_*]> and <[template].proc[utilsu_item_actual_name]> == netherite_upgrade_smithing_template ):
        #            - stop
        #        - else:
        #            - determine <item[air]>
#
        #    - if <[material].proc[utilsu_item_actual_name]> != copper_ingot:
        #        - determine <item[air]>
#
        #    - if !<[main_item].proc[rpgu_can_apply_stone].context[<[template]>]>:
        #        - determine <item[air]>
#
        #    - determine <[main_item].proc[rpgu_apply_upgrade_stone].context[<[template]>]>


        on player prepares smithing RpgU_upgrade_stone_technical_craft:
            - define template <context.inventory.list_contents.get[1].if_null[<item[air]>]>
            - define main_item <context.inventory.list_contents.get[2].if_null[<item[air]>]>
            - define material <context.inventory.list_contents.get[3].if_null[<item[air]>]>

            - if <[template]>|<[main_item]>|<[material]> contains <item[air]>:
                - determine <item[air]>

            - if <[material].proc[utilsu_item_actual_name]> != copper_ingot:
                - determine <item[air]>

            - if !<[main_item].proc[rpgu_can_apply_stone].context[<[template]>]>:
                - determine <item[air]>

            - determine <[main_item].proc[rpgu_apply_upgrade_stone].context[<[template]>]>


#TODO REMOVE
RpgU_fix_upgrade_stone:
    type: command
    name: fix_upgrade_stone
    description: fix_upgrade_stone
    usage: /fix_upgrade_stone
    script:
        - define item <player.item_in_hand>
        - if <[item].proc[utilsu_item_actual_name]> != RpgU_upgrade_stone:
            - narrate "<red>Это не камень улучшения!"
            - stop
        - if <[item].material.name> == <item[RpgU_upgrade_stone].material.name>:
            - narrate "<red>Камень уже пофикшен!"
            - stop
        - inventory adjust slot:<player.held_item_slot> material:<item[RpgU_upgrade_stone].material.name>
        - narrate "<green>Камень пофикшен!"