#EchoU_axe:
#    debug: false
#    type: item
#    material: fishing_rod
#    display name: <reset><&translate[EchoU.item.woodcutter]>
#    lore:
#        - <empty>
#        - <gray><&translate[item.modifiers.mainhand]>
#        -  <&color[0,168,0]>9 <&translate[attribute.name.generic.attack_damage]>
#        -  <&color[0,168,0]>1 <&translate[attribute.name.generic.attack_speed]>
#
#    mechanisms:
#        custom_model_data: 1000
#        hides: ATTRIBUTES
#        attribute_modifiers:
#            GENERIC_ATTACK_DAMAGE:
#                1:
#                    operation: ADD_NUMBER
#                    amount: 8
#                    slot: HAND
#
#            GENERIC_ATTACK_SPEED:
#                1:
#                    operation: ADD_NUMBER
#                    amount: -3
#                    slot: HAND
#
#    recipes:
#        1:
#            type: shaped
#            output_quantity: 1
#            category: equipment
#            input:
#            - material:echo_shard|material:echo_shard|air
#            - material:echo_shard|material:stick|air
#            - air|material:stick|air
EchoU_axe:
    debug: false
    type: item
    material: wooden_axe
    display name: <reset><&translate[item.echou.axe]>
    mechanisms:
        custom_model_data: 1000
    recipes:
        1:
            type: shaped
            output_quantity: 1
            category: equipment
            input:
            - air|material:echo_shard|air
            - material:echo_shard|material:iron_axe|material:echo_shard
            - air|material:echo_shard|air
            #- material:echo_shard|material:echo_shard|air
            #- material:echo_shard|material:stick|air
            #- air|material:stick|air

EchoU_spyglass:
    debug: false
    type: item
    material: spyglass
    display name: <reset><&translate[item.echou.spyglass]>
    mechanisms:
        custom_model_data: 1000
        hides: ENCHANTS
    recipes:
        1:
            type: shaped
            output_quantity: 1
            category: equipment
            input:
            - air|material:echo_shard|air
            - material:echo_shard|material:spyglass|material:echo_shard
            - air|material:echo_shard|air

    enchantments:
        - binding_curse:1

# TODO DO NOT WORK
EchoU_flint_and_steel:
    debug: false
    type: item
    material: flint_and_steel
    display name: <reset><&translate[item.echou.flint_and_steel]>
    mechanisms:
        custom_model_data: 1000
    #recipes:
    #    1:
    #        type: shaped
    #        output_quantity: 1
    #        category: equipment
    #        input:
    #        - air|material:echo_shard|air
    #        - material:echo_shard|material:flint_and_steel|material:echo_shard
    #        - air|material:echo_shard|air

    enchantments:
        - binding_curse:1

EchoU_shield:
    debug: false
    type: item
    material: shield
    display name: <reset><&translate[item.echou.shield]>
    mechanisms:
        custom_model_data: 1000
    recipes:
        1:
            type: shaped
            output_quantity: 1
            category: equipment
            input:
            - air|material:echo_shard|air
            - material:echo_shard|material:shield|material:echo_shard
            - air|material:echo_shard|air

EchoU_fishing_rod:
    debug: false
    type: item
    material: fishing_rod
    display name: <reset><&translate[item.echou.fishing_rod]>
    mechanisms:
        custom_model_data: 1000
    recipes:
        1:
            type: shaped
            output_quantity: 1
            category: equipment
            input:
            - air|material:echo_shard|air
            - material:echo_shard|material:fishing_rod|material:echo_shard
            - air|material:echo_shard|air

EchoU_elytra:
    debug: false
    type: item
    material: elytra
    display name: <reset><&translate[item.echou.elytra]>
    mechanisms:
        custom_model_data: 1000
    recipes:
        1:
            type: shaped
            output_quantity: 1
            category: equipment
            input:
            - air|material:echo_shard|air
            - material:echo_shard|material:elytra|material:echo_shard
            - air|material:echo_shard|air

EchoU_compass:
    debug: false
    type: item
    material: compass
    display name: <reset><&translate[item.echou.compass]>
    mechanisms:
        custom_model_data: 1000
        lodestone_tracked: false
        lodestone_location: <location[0,-256,0,world]>
    recipes:
        1:
            type: shaped
            output_quantity: 1
            category: equipment
            input:
            - air|material:echo_shard|air
            - material:echo_shard|material:compass|material:echo_shard
            - air|material:echo_shard|air
#----------------------------

EchoU_axe_actions:
    type: world
    debug: false
    events:
        #on player fishes with:EchoU_axe:
        #    - determine cancelled

        #after player right clicks *_log|*_wood with:EchoU_axe:
        #    - if <player.xp.add[<player.xp_level>]> == 0:
        #        - stop
        #
        #    - ratelimit <player> 3t
        #    - flag <player> EchoU.breaking:+:1 expire:10t
        #    - define breaking <player.flag[EchoU.breaking]>
        #
        #    - blockcrack <context.location> progress:<[breaking]> players:<server.online_players>
        #    - playsound <context.location> BLOCK_WOOD_HIT pitch:0.1 sound_category:BLOCKS
        #    - playeffect effect:ITEM_CRACK at:<context.location.center> offset:1 velocity:<context.relative.sub[<context.location>].mul[0.1]> quantity:10 special_data:<context.location.material.name>
        #    - playeffect effect:VIBRATION at:<player.eye_location> special_data:0.5|<player.eye_location>|<context.location> visibility:50
        #
        #
        #    - if <[breaking]> >= 10:
        #        - flag <player> EchoU.breaking:!
        #        - run EchoU_damage_item
        #        - run EchoU_break_next_block def:<context.location>|<context.location.material.name>|1
        #        - blockcrack <context.location> progress:0 players:<server.online_players>
        #        - playsound <context.location> BLOCK_WOOD_BREAK pitch:1 sound_category:BLOCKS

        on player breaks *_log|*_wood with:EchoU_axe:
            - define material <context.location.material.name>
            - wait 1t
            - run EchoU_axe_break_next_block def:<context.location>|<[material]>|1


        on player prepares EchoU_axe enchant:
            - determine cancelled


        on player prepares anvil craft EchoU_axe:
            - define enchantments 0
            - if <context.item.enchantment_map.contains[unbreaking]>:
                - define enchantments:+:1
            - if <context.item.enchantment_map.contains[mending]>:
                - define enchantments:+:1
            - if <context.item.enchantment_map.contains[vanishing_curse]>:
                - define enchantments:+:1
            - if <context.item.enchantment_types.size> > <[enchantments]>:
                - determine <item[air]>


EchoU_spyglass_actions:
    type: world
    debug: false
    events:
        after player raises EchoU_spyglass:
            - while <player.is_hand_raised>:
                - cast night_vision duration:1s <player> hide_particles no_clear
                - define found_target <list[]>
                - repeat 5 as:i:
                    - define target <player.eye_location.ray_trace_target[ignore=<[found_target].include[<player>]>;raysize=1.5;blocks=false]||null>
                    - if <[target]> != null:
                        - define found_target:->:<[target]>
                        - if <[target].is_living>:
                            - cast glowing duration:5s <[target]> no_clear
                    - else:
                        - repeat stop
                - wait 15t


EchoU_flint_and_steel_actions:
    type: world
    debug: false
    events:
        on player right clicks block with:EchoU_flint_and_steel:
            - wait 0t
            #- determine cancelled passively
            ##- modifyblock <context.relative> air no_physics
            #- if <context.relative.if_null[null]> == null:
            #    - stop
            #
            #- if !<context.relative.below.material.is_solid>:
            #    - stop
            #    #- determine cancelled
            #
            ##- wait 1t
            #- modifyblock <context.relative> soul_fire no_physics

            #- if <context.relative.material.name> != fire:
            #    - stop
            #- if <context.relative.material.faces.size> > 0:
            #    - modifyblock <context.relative> air
            #    - stop
            #- modifyblock <context.relative> soul_fire no_physics

        #on player breaks soul_fire:
        #    - determine cancelled passively
        #    - modifyblock <context.location> air no_physics

        #after player right clicks block with:EchoU_flint_and_steel:
        #    - if <context.relative.if_null[null]> == null:
        #        - stop
        #    - if <context.relative.material.name> != fire:
        #        - stop
        #    - if <context.relative.material.faces.size> > 0:
        #        - modifyblock <context.relative> air
        #        - stop
        #    #- define material <context.relative.material.with[material=soul_fire]>
        #    ##- define cuboid <context.relative.add[-1,-1,-1].to_cuboid[<context.relative.add[1,1,1]>]>
        #    #- modifyblock <[cuboid].blocks[air]> fire
        #    - modifyblock <context.relative> soul_fire no_physics

EchoU_shield_actions:
    type: world
    debug: false
    events:
        on entity damages player:
            - define player <context.entity>
            - if <context.final_damage> != 0:
                - stop
            - if !<[player].is_blocking>:
                - stop
            - if <[player].item_in_hand.material.name> == shield:
                - if <[player].item_in_hand.script.name.if_null[null]> != EchoU_shield:
                    - stop

            - else if <[player].item_in_offhand.script.name.if_null[null]> != EchoU_shield:
                - stop

            - if !<util.random_chance[100]>:
                - stop

            - if <context.projectile.if_null[null]> != null:
                - define target <context.projectile>
                - adjust <[target]> critical:true
                - adjust <[target]> shooter:<[player]>
                - shoot <[target]> origin:<[player]> destination:<[player].eye_location.backward[1]> speed:50
                #- push <[target]> origin:<[player].eye_location> destination:<[player].eye_location.forward[3]> speed:20 duration:1t

            - else if <context.damager.if_null[null]> != null:
                - define target <context.damager>
                - push <[target]> origin:<[player].eye_location> destination:<[player].eye_location.forward[3]> speed:1.5 duration:1t no_rotate

            - playsound ENTITY_WARDEN_SONIC_BOOM <[player].location> pitch:1.5
            #- push <[target]> origin:<player.eye_location> destination:<player.eye_location.forward[3]> speed:3 duration:1t no_rotate


            - repeat <[player].location.distance[<[target].location>].round_up> as:i:
                - define particle_location <[player].eye_location.forward[<[i].mul[3]>]>
                - playeffect effect:sonic_boom at:<[particle_location]> offset:0 visibility:200


EchoU_fishing_rod_actions:
    type: world
    debug: false
    events:
        on player fishes with:EchoU_fishing_rod:
            - if <context.state> not matches CAUGHT_ENTITY|IN_GROUND:
                - stop
            - push <player> origin:<player.location> destination:<context.hook.location.above[0.5]> speed:1.5 duration:1t no_rotate no_damage

        on player fishes while FISHING with:EchoU_fishing_rod:
            - repeat 20:
                - if <player.fish_hook.if_null[null]> == null:
                    - stop
                - if <player.fish_hook.velocity.y> == 0:
                    #- narrate <player.fish_hook.location>
                    - playsound BLOCK_SCULK_SENSOR_CLICKING at:<player>
                    - playeffect effect:vibration at:<player.fish_hook.location> quantity:3 offset:0.5 visibility:50 special_data:0.2|<player.fish_hook.location>|<player.eye_location>
                    - stop

                - wait 5t

            - remove <player.fish_hook>

            #- while <player.fish_hook.if_null[null]> <player.fish_hook.velocity.y> != 0:
            #- waituntil rate:10t max:10s <player.fish_hook.velocity.y> == 0
            #- narrate ok
            #- push <player> origin:<player.location> destination:<context.hook.location> speed:1.5 duration:1t no_rotate


EchoU_elytra_actions:
    type: world
    debug: false
    events:
        after player starts gliding:
            - if <player.equipment.get[3].script.name.if_null[null]> != EchoU_elytra:
                - stop

        on player boosts elytra:
            - if <player.equipment.get[3].script.name.if_null[null]> != EchoU_elytra:
                - determine cancelled
            - itemcooldown firework_rocket duration:20s

EchoU_compass_actions:
    type: world
    debug: false
    events:
        after player right clicks entity with:EchoU_compass:
            - ratelimit <player> 1t
            - if !<context.entity.is_living>:
                - stop

            - if <context.hand> == mainhand:
                - define slot hand
            - else:
                - define slot offhand

            - inventory flag slot:<[slot]> find_target:<context.entity>

            - if <context.entity.name> == <context.entity.entity_type>:
                - define lore <gray><&translate[lore.echou.compass.no_name].with[<&translate[entity.minecraft.<context.entity.entity_type.to_lowercase>]>]>
            - else:
                - define lore <gray><&translate[lore.echou.compass.name].with[<&translate[entity.minecraft.<context.entity.entity_type.to_lowercase>]>|<context.entity.name>]>

            - inventory adjust slot:<[slot]> lore:<[lore]>

            - if <context.hand> == mainhand:
                - run EchoU_compass_auto_update def:true
            - else:
                - run EchoU_compass_auto_update def:false

        after player holds item item:EchoU_compass:
            - run EchoU_compass_auto_update def:true

        after player swaps items offhand:EchoU_compass:
            - run EchoU_compass_auto_update def:false

        after player swaps items main:EchoU_compass:
            - run EchoU_compass_auto_update def:true

        #on recovery_compass recipe formed:
        #    - determine cancelled

        after server start:
            - adjust server remove_recipes:<item[recovery_compass].recipe_ids>


EchoU_compass_auto_update:
    type: task
    debug: false
    definitions: is_main
    script:
        #- narrate started
        - if <[is_main]>:
            - define slot <player.held_item_slot>
        - else:
            - define slot 41

        #- inventory adjust slot:<[slot]> lodestone_tracked:false
        - while true:
            - wait 1s
            - narrate <queue>
            - if <[is_main]>:
                - if <[slot]> != <player.held_item_slot>:
                    - narrate stopped_slot
                    - stop

            - define item <player.inventory.slot[<[slot]>]>
            - if <[item].script.name.if_null[null]> != EchoU_compass:
                - narrate stopped_item
                - stop

            - define find_target <[item].flag[find_target].if_null[null]>
            - if <[find_target].entity_type.if_null[null]> == null:
                    - narrate null_type_next
                    - while next

            - else if <[find_target].entity_type> == PLAYER:
                - if !<[find_target].is_online>:
                    - narrate null_type_online
                    - while next
            - else:
                - if !<[find_target].is_spawned>:
                    - narrate null_type_spwned
                    - while next

            - inventory adjust slot:<[slot]> lodestone_location:<[find_target].location>

        #- inventory adjust slot:<[slot]> lodestone_tracked:true
        #- narrate stopped


EchoU_other_actions:
    type: world
    debug: false
    events:
        on player resurrected:
            - if <player.item_cooldown[totem_of_undying].in_ticks> == 0:
                - itemcooldown totem_of_undying d:30s
                - stop
            - determine cancelled
        after player dies:
            - itemcooldown totem_of_undying d:0


#EchoU_damage_item:
#    type: task
#    debug: false
#    script:
#        - if <util.random_chance[<element[100].div[<player.item_in_hand.enchantment_map.get[unbreaking].if_null[0].add[1]>]>]>:
#            - if <player.item_in_hand.durability.add[1]> <= <player.item_in_hand.max_durability>:
#                - inventory adjust durability:<player.item_in_hand.durability.add[1]> slot:<player.held_item_slot>
#            - else:
#                - define item <player.item_in_hand>
#                - inventory set o:air slot:<player.held_item_slot>
#                - playeffect effect:item_crack at:<player.eye_location> offset:0.25 quantity:15 velocity:0,0.05,0 special_data:<[item]>
#                - playsound <player.location> ENTITY_ITEM_BREAK sound_category:PLAYERS

EchoU_axe_break_next_block:
    type: task
    debug: false
    definitions: location|material_name|depth
    script:
        - if <[depth]> > 30:
            - stop
        - if <player.xp.add[<player.xp_level>]> == 0:
            - stop
        - define break_cuboid <[location].add[-1,0,-1].to_cuboid[<[location].add[1,1,1]>]>

        - experience take 3
        - modifyblock <[location]> air naturally

        - playsound <[location]> BLOCK_WOOD_BREAK pitch:1 volume:0.5 sound_category:BLOCKS
        - playeffect effect:VIBRATION at:<player.eye_location> special_data:0.5|<player.eye_location>|<[location]> visibility:50
        - playeffect effect:ITEM_CRACK at:<[location].center> offset:0.4 quantity:10 special_data:<[material_name]>

        - foreach <[break_cuboid].blocks[<[material_name]>]> as:block_loc:
            - wait 5t
            - if <[block_loc].material.name> == <[material_name]>:
                - run EchoU_axe_break_next_block def:<[block_loc]>|<[material_name]>|<[depth].add[1]>

#-------------------------------
EchoU_recipes_gui:
    type: inventory
    inventory: CHEST
    title: <&translate[gui.echou.title]>
    size: 9
    gui: true
    definitions:
        a1: EchoU_axe
        a2: EchoU_spyglass
        a3: EchoU_shield
        a4: EchoU_fishing_rod
        a5: EchoU_elytra
        a6: EchoU_compass
    slots:
    - [a1] [a2] [a3] [a4] [a5] [a6] [] [] []

EchoU_recipes_gui_actions:
    type: world
    debug: false
    events:
        after player right clicks item in BoatTrainU_items_gui:
            - run enoughitemsu_open_new_used_in_gui def:<context.item>|true|<context.inventory.script.name>
        after player left clicks item in BoatTrainU_items_gui:
            - run enoughitemsu_open_new_recipes_gui def:<context.item>|true|<context.inventory.script.name>

EchoU_commands:
    type: command
    debug: false
    name: EchoU
    description: EchoU
    usage: /EchoU
    script:
        - inventory open destination:EchoU_recipes_gui
