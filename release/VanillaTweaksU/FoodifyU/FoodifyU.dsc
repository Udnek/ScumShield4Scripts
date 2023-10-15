FoodifyU_data:
    type: data
    items:

        ## MEET

        cooked_beef:
            effect:
                type: damage_resistance
                duration: 25s
            color: *713f2d
        cooked_mutton:
            effect:
                type: damage_resistance
                duration: 25s
            color: *9d6147
        cooked_rabbit:
            effect:
                type: damage_resistance
                duration: 55s
            color: *d28e62
        cooked_porkchop:
            effect:
                type: damage_resistance
                duration: 25s
            color: *d3c088
        cooked_chicken:
            effect:
                type: damage_resistance
                duration: 25s
            color: *cd7d4a
        foodifyu_cooked_hogmeat:
            effect:
                type: fire_resistance
                duration: 20s
            color: *ea914d
        ## FISH

        tropical_fish:
            effect:
                type: dolphins_grace
                duration: 20s
            color: *f46f20
        cooked_cod:
            effect:
                type: water_breathing
                duration: 10s
            color: *d6c5ad
        cooked_salmon:
            effect:
                type: water_breathing
                duration: 20s
            color: *df7d53
        pufferfish:
            effect:
                type: conduit_power
                duration: 20s
            color: *fba70c

        ## FRUIT AND VEGETABLES

        baked_potato:
            effect:
                type: absorption
                duration: 30s
            color: *d5ac37
        apple:
            effect:
                type: slow_falling
                duration: 30s
            color: *ff1c2b
        beetroot:
            effect:
                type: health_boost
                duration: 20s
                amplifier: 1
            color: *a4272c
        sweet_berries:
            effect:
                type: jump
                duration: 30s
                amplifier: 1
            color: *a50700
        glow_berries:
            effect:
                type: increase_damage
                duration: 30s
            color: *f19645
        carrot:
            effect:
                type: night_vision
                duration: 80s
            color: *ff8e09
        melon_slice:
            effect:
                type: speed
                duration: 30s
            color: *bf3123

        ## MISC

        dried_kelp:
            effect:
                type: regeneration
                duration: 7s
            color: *3c3917
        chorus_fruit:
            effect:
                type: fast_digging
                duration: 25s
            color: *8e678d
        brown_mushroom:
            effect:
                type: regeneration
                duration: 25s
            color: *cc9978
        red_mushroom:
            effect:
                type: regeneration
                duration: 25s
            color: *e21212


        #apple:
        #    effect:
        #        type: speed
        #        duration: 10s
        #    color: *dd1725
#
        #melon_slice:
        #    effect:
        #        type: regeneration
        #        duration: 10s
        #    color: *bf3123
#
        #dried_kelp:
        #    effect:
        #        type: jump
        #        duration: 10s
        #    color: *3c3917
#
        #carrot:
        #    effect:
        #        type: night_vision
        #        duration: 40s
        #    color: *ff8e09
#
        #cooked_salmon:
        #    effect:
        #        type: water_breathing
        #        duration: 10s
        #    color: *df7d53
#
        #chorus_fruit:
        #    effect:
        #        type: fast_digging
        #        duration: 20s
        #    color: *8e678d
#
        #glow_berries:
        #    effect:
        #        type: glowing
        #        duration: 20s
        #    color: *f19645


    effects:
        jump: jump_boost
        fast_digging: haste
        increase_damage: strength
        damage_resistance: resistance

#-----------------------
FoodifyU_soup:
    type: item
    debug: false
    material: potion
    display name: <reset><&translate[item.foodifyu.soup]>
    mechanisms:
        custom_model_data: 100000
        hides: ITEM_DATA
    recipes:
        1:
            type: shapeless
            input: <proc[foodifyu_generate_recipe]>

FoodifyU_hogmeat:
    type: item
    debug: false
    material: porkchop
    display name: <reset><&translate[item.foodifyu.hogmeat]>
    mechanisms:
        custom_model_data: 100000


FoodifyU_cooked_hogmeat:
    type: item
    debug: false
    material: cooked_porkchop
    display name: <reset><&translate[item.foodifyu.cooked_hogmeat]>
    mechanisms:
        custom_model_data: 100000
    recipes:
        1:
           type: furnace
           category: food
           experience: 5
           cook_time: 10s
           input: FoodifyU_hogmeat
        2:
           type: smoker
           category: food
           experience: 5
           cook_time: 5s
           input: FoodifyU_hogmeat
        3:
           type: campfire
           category: food
           cook_time: 30s
           input: FoodifyU_hogmeat

#-----------------------
FoodifyU_item_to_effect:
    type: procedure
    debug: false
    definitions: item
    script:
        - define data <script[foodifyu_data].data_key[items.<[item].proc[utilsu_item_actual_name]>.effect]>
        - determine <[data].with[duration].as[<duration[<[data].get[duration]>]>].with[amplifier].as[<[data].get[amplifier].if_null[0]>]>


FoodifyU_effect_name_to_minecraft_effect:
    type: procedure
    debug: false
    definitions: effect
    script:
        - determine <script[foodifyu_data].data_key[effects.<[effect]>].if_null[<[effect]>]>


FoodifyU_item_to_color:
    type: procedure
    debug: false
    definitions: item
    script:
        - determine <color[<script[foodifyu_data].data_key[items.<[item].proc[utilsu_item_actual_name]>.color].replace_text[*].with[#]>]>


FoodifyU_generate_recipe:
    type: procedure
    debug: false
    script:
        - determine material:bowl|<element[<script[FoodifyU_data].data_key[items].keys.separated_by[/]>].repeat_as_list[3].separated_by[|]>


FoodifyU_get_effects:
    type: procedure
    debug: false
    definitions: item
    script:
        - determine <[item].flag[foodifyu_effects]>


FoodifyU_generate_item:
    type: procedure
    debug: false
    definitions: item|ingredients
    script:

        ##DATA

        - define ingredients <[ingredients].sort_by_value[proc[UtilsU_item_actual_name]]>

        - define effects <map[]>
        - define used_ingredients <list[]>
        - foreach <[ingredients]> as:item:

            - define effect_data <[item].proc[foodifyu_item_to_effect]>
            - define type <[effect_data].get[type]>

            - if <[effects]> contains <[type]>:

                - if <[used_ingredients]> contains <[item].proc[utilsu_item_actual_name]>:
                    - define effects.<[type]>.duration <[effects].deep_get[<[type]>.duration].add[<[effect_data].get[duration].proc[utilsu_mul_duration].context[0.5]>].proc[utilsu_round_up_ticks_duration]>
                    #- define effects.<[type]>.duration <[effects].deep_get[<[type]>.duration].proc[utilsu_mul_duration].context[1.5].proc[utilsu_round_up_ticks_duration]>
                - else:
                    - define effects.<[type]>.duration <[effects].deep_get[<[type]>.duration].add[<[effect_data].get[duration]>]>

            - else:
                - define effects.<[type]> <map[duration=<[effect_data].get[duration]>;amplifier=<[effect_data].get[amplifier]>]>

            - define used_ingredients:->:<[item].proc[utilsu_item_actual_name]>

        - define item <[item].with_flag[foodifyu_effects:<[effects]>]>

        ##COLOR

        - define color <[ingredients].get[1].proc[foodifyu_item_to_color].mix[<[ingredients].get[2].proc[foodifyu_item_to_color]>].mix[<[ingredients].get[3].proc[foodifyu_item_to_color]>]>
        - define item <[item].with[color=<[color]>]>

        ##LORE

        - define lore <gray><&translate[item.foodifyu.soup.ingredients]>

        - foreach <[ingredients]> as:item:
            - define lore <[lore]><&nl><&color[<[item].proc[foodifyu_item_to_color]>]><&translate[item.foodifyu.soup.ingredients.description].with[<[item].proc[utilsu_item_actual_display]>]>

        - define lore <[lore]><&nl><&nl><blue><&translate[item.foodifyu.soup.effects]>

        - foreach <[effects]> key:type as:effect_data:
            - define name <&translate[effect.minecraft.<[type].proc[foodifyu_effect_name_to_minecraft_effect]>]>
            - if <[effect_data].get[amplifier]> == 0:
                - define amplifier <empty>
            - else:
                - define amplifier "<&translate[potion.potency.<[effect_data].get[amplifier]>]> "
            - define duration <[effect_data].get[duration].proc[utilsu_lore_duration]>
            - define line <blue><&translate[item.foodifyu.soup.effects.description].with[<[name]>|<[amplifier]>|<[duration]>]>

            - define lore <[lore]><&nl><[line]>

        - define item <[item].with[lore=<[lore]>]>

        ##FINAL

        - determine <[item]>

#-----------------------

FoodifyU_events:
    type: world
    debug: false
    events:
        after server start:
            - adjust <material[potion]> max_stack_size:16

            - adjust server remove_recipes:<item[mushroom_stew].recipe_ids>
            - adjust server remove_recipes:<item[beetroot_soup].recipe_ids>

        after server resources reloaded:
            - adjust server remove_recipes:<item[mushroom_stew].recipe_ids>
            - adjust server remove_recipes:<item[beetroot_soup].recipe_ids>


        on hoglin dies:
            - define drops <list[]>
            - foreach <context.drops> as:item:
                - choose <[item].proc[utilsu_item_actual_name]>:
                    - case porkchop:
                        - define drops:->:<item[foodifyu_hogmeat].with[quantity=<[item].quantity>]>
                    - case cooked_porkchop:
                        - define drops:->:<item[foodifyu_cooked_hogmeat].with[quantity=<[item].quantity>]>
                    - default:
                        - define drops:->:<[item]>
            - determine <[drops]>



        on player consumes FoodifyU_soup:
            - determine cancelled passively

            - if <player.item_in_hand> == <context.item>:
                - define slot <player.held_item_slot>
            - else:
                - define slot 41

            - take slot:<[slot]>

            - if <context.item.quantity> == 1:
                - inventory set origin:bowl slot:<[slot]>
            - else:
                - give bowl

            - foreach <context.item.proc[foodifyu_get_effects]> key:type as:effect_data:
                - cast <[type]> duration:<[effect_data].get[duration]> amplifier:<[effect_data].get[amplifier]> no_clear

            - feed amount:5 saturation:7


        on FoodifyU_soup recipe formed:
            - define ingredients <list[]>
            - foreach <context.recipe> as:item:
                - if <[item].proc[utilsu_item_actual_name]> !matches bowl|air:
                    - define ingredients:->:<[item]>
            - determine <context.item.proc[foodifyu_generate_item].context[<list_single[<[ingredients]>]>]>