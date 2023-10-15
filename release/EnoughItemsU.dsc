EnoughItemsU_recipe_replace_data:
    type: data

    denizen:toughasnailsu_flask_colored_1:
        bundle: ToughAsNailsU_flask
    denizen:toughasnailsu_green_sweet_berry_tea_bottle_1:
        firework_star: ToughAsNailsU_oak_leaf
    denizen:toughasnailsu_green_glow_berry_tea_bottle_1:
        firework_star: ToughAsNailsU_oak_leaf
    denizen:toughasnailsu_green_sugar_tea_bottle_1:
        firework_star: ToughAsNailsU_oak_leaf
    denizen:toughasnailsu_wheat_wort_bottle_1:
        firework_star: ToughAsNailsU_oak_leaf
    denizen:toughasnailsu_special_bone_meal_1:
        firework_star: ToughAsNailsU_oak_leaf

#EnoughItemsU_recipe_add_data:
#    type: data
#
#    enchanting_table:
#        - denizen:enchantingtablefixu_enchanting_table

#-----------------------------------
EnoughItemsU_get_all_items:
    type: procedure
    debug: false
    script:
        - define vanilla <server.material_types.filter[is_item].exclude[<material[air]>].parse[name]>
        - define custom <util.scripts.filter[container_type.equals[ITEM]].parse[name]>
        - determine <[vanilla].include[<[custom]>]>
        #- define result <list[]>
#
        #- foreach <[vanilla]> as:item_name:
        #    - if <item[<[item_name]>].proc[enoughitemsu_all_recipe_ids].size> != 0:
        #        - define result:->:<[item_name]>
        #- foreach <[custom]> as:item_name:
        #    - if <item[<[item_name]>].proc[enoughitemsu_all_recipe_ids].size> != 0:
        #        - if <item[<[item_name]>].script.exists>:
        #            - define result:->:<[item_name]>
        #- determine <[result]>


## PROC USES CONTEXT BECAUSE IT STATIC AND CACHES BEFORE RECIPES GENERATED
# TODO BETTER FIX?

EnoughItemsU_generate_added_crafts_to_vanilla_items:
    type: task
    debug: false
    script:
        - define recipe_ids <map[]>
        - foreach <server.recipe_ids.filter[starts_with[denizen:]]> as:recipe_id:
            - define item <server.recipe_result[<[recipe_id]>]>
            - if !<[item].script.exists>:
                - define recipe_ids.<[item].material.name>:->:<[recipe_id]>
        - flag server EnoughItemsU_added_crafts_to_vanilla_items:<[recipe_ids]>
        #- determine <[recipe_ids]>

EnoughItemsU_get_added_crafts_to_vanilla_items:
    type: procedure
    debug: false
    definitions: item
    script:
        - define recipe_ids_added <server.flag[EnoughItemsU_added_crafts_to_vanilla_items]>
        - define item_name <[item].proc[utilsu_item_actual_name]>
        - if <[recipe_ids_added]> contains <[item_name]>:
            - determine <[recipe_ids_added].get[<[item_name]>]>
        - determine <list[]>

EnoughItemsU_all_recipe_ids:
    type: procedure
    debug: false
    definitions: item
    script:
        - define recipe_ids <[item].recipe_ids>
        - determine <[recipe_ids].include[<[item].proc[EnoughItemsU_get_added_crafts_to_vanilla_items]>]>


EnoughItemsU_used_in_recipe_ids:
    type: procedure
    debug: false
    definitions: item
    script:
        - define recipe_ids <list[]>
        - define item_name <[item].proc[utilsu_item_actual_name]>
        - foreach <server.recipe_ids> as:recipe_id:
            - if <server.recipe_items[<[recipe_id]>].parse_tag[<[parse_value].contains[material:].if_true[<[parse_value].replace_text[material:].with[]>].if_false[<[parse_value].proc[utilsu_item_actual_name]>]>]> contains <[item_name]>:
                - define recipe_ids:->:<[recipe_id]>
        - determine <[recipe_ids]>

#-----------------------------------
EnoughItemsU_empty_item:
    type: item
    debug: false
    material: gunpowder
    display name: " "

EnoughItemsU_fire_icon:
    type: item
    debug: false
    material: gunpowder
    mechanisms:
        custom_model_data: 1100
    display name: " "

EnoughItemsU_recipe_arrow_left:
    type: item
    debug: false
    material: gunpowder
    mechanisms:
        custom_model_data: 1102
    display name: <reset><&translate[gui.enoughitemsu.arrow_left_active]>

EnoughItemsU_recipe_arrow_right:
    type: item
    debug: false
    material: gunpowder
    mechanisms:
        custom_model_data: 1101
    display name: <reset><&translate[gui.enoughitemsu.arrow_right_active]>

EnoughItemsU_recipe_back:
    type: item
    debug: false
    material: gunpowder
    mechanisms:
        custom_model_data: 1103
    display name: <reset><&translate[gui.enoughitemsu.back]>

EnoughItemsU_recipe_gui:
    type: inventory
    inventory: CHEST
    #title: 1
    title: <&translate[space.-8]><white><&font[enoughitemsu:font]><&translate[gui.enoughitemsu.backround]><&translate[space.-171]><black><&translate[gui.enoughitemsu.title]>
    size: 54
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

#-------------------------------
EnoughItemsU_open_new_recipes_gui:
    type: task
    debug: false
    definitions: item|has_inv|inv
    script:
        - if <[item].material.name> == air:
            - stop
        - define recipes <[item].proc[enoughitemsu_all_recipe_ids]>
        - if <[recipes].is_empty>:
            - stop
        - if <[has_inv]>:
            - run EnoughItemsU_open_recipes_gui def.recipes:<[recipes]> def.recipe_number:1 def.back_recipes:false def.back_inventory:<[inv]>
        - else:
            - run EnoughItemsU_open_recipes_gui def.recipes:<[recipes]> def.recipe_number:1 def.back_recipes:false def.back_inventory:false

EnoughItemsU_open_new_used_in_gui:
    type: task
    debug: false
    definitions: item|has_inv|inv
    script:
        - if <[item].material.name> == air:
            - stop
        - define recipes <[item].proc[enoughitemsu_used_in_recipe_ids]>
        - if <[recipes].is_empty>:
            - stop
        - if <[has_inv]>:
            - run EnoughItemsU_open_recipes_gui def.recipes:<[recipes]> def.recipe_number:1 def.back_recipes:false def.back_inventory:<[inv]>
        - else:
            - run EnoughItemsU_open_recipes_gui def.recipes:<[recipes]> def.recipe_number:1 def.back_recipes:false def.back_inventory:false

EnoughItemsU_open_recipes_gui:
    type: task
    debug: false
    definitions: recipes|recipe_number|back_recipes|back_inventory
    script:
        - define genertor_result <proc[EnoughItemsU_recipe_generator].context[<[recipes].get[<[recipe_number]>]>]>
        - define recipe_gui <[genertor_result].get[gui]>
        - define gui <inventory[EnoughItemsU_recipe_gui]>
        - define offset_x 2
        - define offset_y 2


        - repeat 3 from:0 as:y:
            - repeat 3 from:1 as:x:
                - inventory set o:<[recipe_gui].get[<[y].mul[3].add[<[x]>]>]> slot:<[y].add[<[offset_y]>].mul[9].add[<[x]>].add[<[offset_x]>]> destination:<[gui]>

        - inventory set o:<[genertor_result].get[result]> slot:34 destination:<[gui]>
        - inventory set o:<[genertor_result].get[block_icon].with_flag[recipes:<[recipes]>]> slot:5 destination:<[gui]>
        - inventory set o:<[genertor_result].get[gui_icon]> slot:13 destination:<[gui]>

        - if <[back_recipes]> != false:
            - define back <item[enoughitemsu_recipe_back]>
            - flag <[back]> recipes:<[back_recipes]>
            - inventory set o:<[back]> slot:1 destination:<[gui]>

        - else if <[back_inventory]> != false:
            - define back <item[enoughitemsu_recipe_back]>
            - flag <[back]> inventory:<[back_inventory]>
            - inventory set o:<[back]> slot:1 destination:<[gui]>

        - if <[recipe_number]> < <[recipes].size>:
            - define arrow_right <item[EnoughItemsU_recipe_arrow_right]>
            - flag <[arrow_right]> recipe_number:<[recipe_number].add[1]>
            - inventory set o:<[arrow_right]> slot:36 destination:<[gui]>

        - if <[recipe_number]> > 1:
            - define arrow_left <item[EnoughItemsU_recipe_arrow_left]>
            - flag <[arrow_left]> recipe_number:<[recipe_number].add[-1]>
            - inventory set o:<[arrow_left]> slot:28 destination:<[gui]>

        - inventory open destination:<[gui]>


EnoughItemsU_recipe_generator:
    type: procedure
    debug: false
    definitions: recipe_id
    script:
        - define gui <item[air].repeat_as_list[9]>

        - define recipe_type <server.recipe_type[<[recipe_id]>]>
        - define gui_icon <item[EnoughItemsU_empty_item]>
        - choose <[recipe_type]>:
            - case SHAPED:
                - define recipe <server.recipe_items[<[recipe_id]>]>
                - define shape <server.recipe_shape[<[recipe_id]>].replace_text[x].with[].to_list>
                - define offset_y 0
                - define offset_x 0
                - if <[shape].get[2]> == 1:
                    - define offset_y 1
                - else if <[shape].get[1]> == 1:
                    - define offset_x 1
                - define n 1
                - repeat <[shape].get[2]> from:0 as:y:
                    - repeat <[shape].get[1]> from:1 as:x:
                        - define item:<[recipe].get[<[n]>]>
                        - if <[item].contains[material:]>:
                            - define item <item[<[item].replace_text[material:].with[]>]>
                        - define gui[<[y].add[<[offset_y]>].mul[3].add[<[x]>].add[<[offset_x]>]>]:<[item]>
                        - define n:+:1
                - define block_icon <item[crafting_table]>
                - adjust def:gui_icon custom_model_data:1000

            - case SHAPELESS:
                - define recipe <server.recipe_items[<[recipe_id]>]>
                - define size <[recipe].size>
                - define y 0
                - define x 1
                - repeat <[size]> as:n:
                    - define item <[recipe].get[<[n]>]>
                    - if <[item].contains[material:]>:
                        - define item <item[<[item].replace_text[material:].with[]>]>
                    - define gui[<[y].mul[3].add[<[x]>]>]:<[item]>
                    - define x:+:1
                    - if <[x]> == 4:
                        - define y:+:1
                        - define x 1
                - define block_icon <item[crafting_table]>
                - adjust def:gui_icon custom_model_data:1000

            - case FURNACE SMOKING BLASTING CAMPFIRE:
                - define recipe <server.recipe_items[<[recipe_id]>]>
                - define item <[recipe].get[1].if_null[<item[air]>]>
                - if <[item].contains[material:]>:
                    - define item <item[<[item].replace_text[material:].with[]>]>
                - define gui[2]:<[item]>

                - define gui[5]:<item[EnoughItemsU_fire_icon]>

                - adjust def:gui_icon custom_model_data:1001
                - choose <[recipe_type]>:
                    - case FURNACE:
                        - define block_icon <item[furnace]>
                    - case SMOKING:
                        - define block_icon <item[smoker]>
                    - case BLASTING:
                        - define block_icon <item[blast_furnace]>
                    - case CAMPFIRE:
                        - define block_icon <item[campfire]>

            - case SMITHING:
                - define recipe <server.recipe_items[<[recipe_id]>]>

                - define item_1 <[recipe].get[1].if_null[<item[air]>]>
                - define item_2 <[recipe].get[2].if_null[<item[air]>]>
                - if <[item_1].contains[material:]>:
                    - define item_1 <item[<[item_1].replace_text[material:].with[]>]>
                - if <[item_2].contains[material:]>:
                    - define item_2 <item[<[item_2].replace_text[material:].with[]>]>
                - define gui[4]:<[item_1]>
                - define gui[6]:<[item_2]>
                - adjust def:gui_icon custom_model_data:1002
                - define block_icon <item[smithing_table]>

            - case STONECUTTING:
                - define recipe <server.recipe_items[<[recipe_id]>]>
                - define item <[recipe].get[1].if_null[<item[air]>]>
                - if <[item].contains[material:]>:
                    - define item <item[<[item].replace_text[material:].with[]>]>
                - define gui[5]:<[item]>

                - define block_icon <item[stonecutter]>

                - adjust def:gui_icon custom_model_data:1003

            - default:
                - define block_icon <item[air]>

        - define replace_recipe_data <script[enoughitemsu_recipe_replace_data]>
        - define replace_recipe_items <[replace_recipe_data].data_key[<[recipe_id]>].if_null[null]>
        - if <[replace_recipe_items]> != null:
            - foreach <[replace_recipe_items].keys> as:i:
                - define gui <[gui].replace[<item[<[i]>]>].with[<item[<[replace_recipe_items].get[<[i]>]>]>]>

        - determine <map[gui=<[gui]>;result=<server.recipe_result[<[recipe_id]>]>;block_icon=<[block_icon]>;gui_icon=<[gui_icon]>]>

#-------------------------------
EnoughItemsU_gui_events:
    type: world
    debug: false
    events:
        on player clicks item in EnoughItemsU_recipe_gui:
            - determine cancelled

        after player left clicks item in EnoughItemsU_recipe_gui cancelled:true:
            - define recipes <context.item.proc[enoughitemsu_all_recipe_ids]>
            - if ( <context.item.material.name> != air ) && ( !<[recipes].is_empty> ):
                - run EnoughItemsU_open_recipes_gui def.recipes:<[recipes]> def.recipe_number:1 def.back_recipes:<player.open_inventory.slot[5].flag[recipes]> def.back_inventory:false

        after player right clicks item in EnoughItemsU_recipe_gui cancelled:true:
            - define recipes <context.item.proc[enoughitemsu_used_in_recipe_ids]>
            - if ( <context.item.material.name> != air ) && ( !<[recipes].is_empty> ):
                - run EnoughItemsU_open_recipes_gui def.recipes:<[recipes]> def.recipe_number:1 def.back_recipes:<player.open_inventory.slot[5].flag[recipes]> def.back_inventory:false
                #- run EnoughItemsU_open_new_recipes_gui def:<context.item>|false|false
                #- run EnoughItemsU_open_recipes_gui def.recipes:<context.item.proc[enoughitemsu_all_recipe_ids]> def.recipe_number:1 def.back_recipes:false def.back_inventory:false
                #- run enoughitemsu_open_new__gui def:<context.item>|1|<context.inventory.list_contents.get[34]>|false

        after player clicks EnoughItemsU_recipe_arrow_* in EnoughItemsU_recipe_gui cancelled:true:
            - define list_contents <context.inventory.list_contents>
            - if <context.inventory.slot[1].has_flag[recipes]>:
                - define back_recipes <context.inventory.slot[1].flag[recipes]>
            - else:
                - define back_recipes false

            - if <context.inventory.slot[1].has_flag[inventory]>:
                - define back_inventory <context.inventory.slot[1].flag[inventory]>
            - else:
                - define back_inventory false

            - run EnoughItemsU_open_recipes_gui def.recipes:<player.open_inventory.slot[5].flag[recipes]> def.recipe_number:<context.item.flag[recipe_number].if_null[1]> def.back_recipes:<[back_recipes]> def.back_inventory:<[back_inventory]>
            #- run EnoughItemsU_open_recipe_gui def:<[list_contents].get[34]>|<context.item.flag[recipe_number].if_null[1]>|<[back_item]>|<[back_inventory]>

        after player clicks EnoughItemsU_recipe_back in EnoughItemsU_recipe_gui cancelled:true:
            - if <context.item.has_flag[recipes]>:
                - run EnoughItemsU_open_recipes_gui def.recipes:<context.item.flag[recipes]> def.recipe_number:1 def.back_recipes:false def.back_inventory:false
                #- run EnoughItemsU_open_recipe_gui def:<item[<context.item.flag[item]>]>|1|<context.inventory.list_contents.get[34]>|false
            - else:
                - inventory open destination:<context.item.flag[inventory]>

EnoughItemsU_reload_events:
    type: world
    debug: false
    events:
        after server resources reloaded:
            - run enoughitemsu_generate_added_crafts_to_vanilla_items
        after reload scripts:
            - run enoughitemsu_generate_added_crafts_to_vanilla_items
        after server start:
            - run enoughitemsu_generate_added_crafts_to_vanilla_items

#-------------------------------
EnoughItemsU_recipe_command:
    type: command
    debug: false
    name: recipe
    description: recipe
    usage: /recipe
    tab completions:
        1: <static[<proc[enoughitemsu_get_all_items]>]>
    script:
        - if <context.args.first.if_null[null]> != null:
            - if <item[<context.args.first>].if_null[null]> != null:
                - run EnoughItemsU_open_new_recipes_gui def:<item[<context.args.first>]>|false|false
                - stop
        - run EnoughItemsU_open_new_recipes_gui def:<player.item_in_hand>|false|false

EnoughItemsU_recipe_usages_command:
    type: command
    debug: false
    name: recipe_usages
    description: recipe_usages
    usage: /recipe_usages
    tab completions:
        1: <static[<proc[enoughitemsu_get_all_items]>]>
    script:
        - if <context.args.first.if_null[null]> != null:
            - if <item[<context.args.first>].if_null[null]> != null:
                - run enoughitemsu_open_new_used_in_gui def:<item[<context.args.first>]>|false|false
                - stop
        - run enoughitemsu_open_new_used_in_gui def:<player.item_in_hand>|false|false
