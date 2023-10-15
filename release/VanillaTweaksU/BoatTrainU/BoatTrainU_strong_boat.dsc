BoatTrainU_strong_boat_entity:
    type: entity
    debug: false
    entity_type: sniffer
    mechanisms:
        #invulnerable: true
        #age: baby
        age: adult
        #age_locked: true
        silent: true
        speed: 0
        persistent: true
        force_no_persist: false
        attribute_base_values: <map[GENERIC_KNOCKBACK_RESISTANCE=0.7]>
        max_health: 7
        visible: false
        is_aware: true

        #passengers: BoatTrainU_strong_boat_seat_entity|BoatTrainU_strong_boat_model_entity


BoatTrainU_strong_boat_seat_entity:
    type: entity
    debug: false
    entity_type: mule
    mechanisms:
        custom_name: <&translate[space.-8]><element[<&translate[gui.boattrainu.strong_boat]><&translate[space.-163]><&translate[gui.boattrainu.strong_boat.model]>].font[boattrainu:font]><&translate[space.-62]><&translate[entity.boattrainu.strong_boat]>
        carries_chest: true
        invulnerable: true
        age: adult
        silent: true
        #strength: 5
        has_ai: false
        visible: false
        health: 1
        max_health: 1
    flags:
        BoatTrainU_fuel_used: 0


BoatTrainU_strong_boat_model_entity:
    type: entity
    debug: false
    entity_type: item_display
    mechanisms:
        display: HEAD
        #item: paper
        item: paper[custom_model_data=110002]
        translation: 0,-0.3,0
        #left_rotation: 1,0,0,0
        scale: 3,3,3


BoatTrainU_strong_boat:
    type: item
    debug: false
    material: paper
    display name: <reset><&translate[item.boattrainu.strong_boat]>
    mechanisms:
        custom_model_data: 110002
    recipes:
        1:
            type: shaped
            output_quantity: 1
            input:
            - material:copper_block/waxed_copper_block|material:copper_block/waxed_copper_block|material:copper_block/waxed_copper_block
            - material:blast_furnace|material:piston|material:copper_block/waxed_copper_block
            - BoatTrainU_boat_cylinder|BoatTrainU_boat_cylinder|BoatTrainU_paddle_wheel


BoatTrainU_paddle_wheel:
    type: item
    debug: false
    material: paper
    display name: <reset><&translate[item.boattrainu.paddle_wheel]>
    mechanisms:
        custom_model_data: 110006
    recipes:
        1:
            type: shaped
            output_quantity: 1
            input:
            - air|<proc[BoatTrainU_wooden_slabs]>|air
            - <proc[BoatTrainU_wooden_slabs]>|<proc[BoatTrainU_wooden_fences]>|<proc[BoatTrainU_wooden_slabs]>
            - air|<proc[BoatTrainU_wooden_slabs]>|air


BoatTrainU_wooden_fences:
    type: procedure
    debug: false
    script:
        - determine material:oak_fence/acacia_fence/dark_oak_fence/spruce_fence/birch_fence/jungle_fence/crimson_fence/warped_fence/mangrove_fence/bamboo_fence/cherry_fence
BoatTrainU_wooden_slabs:
    type: procedure
    debug: false
    script:
        - determine material:oak_slab/spruce_slab/birch_slab/jungle_slab/acacia_slab/dark_oak_slab/crimson_slab/warped_slab/mangrove_slab/bamboo_slab/cherry_slab
#-----------------------

BoatTrainU_strong_boat_events:
    type: world
    debug: false
    events:
        after player right clicks block with:BoatTrainU_strong_boat:
            - ratelimit <player> 1t
            - define loc <player.eye_location.ray_trace[return=block;fluids=true;nonsolids=true;range=5;default=air]>
            - if <[loc].material.name> == water:
                - take iteminhand
                - run boattrainu_place_strong_boat def:<[loc].center>

        on BoatTrainU_strong_boat_entity dies:
            - run boattrainu_remove_strong_boat def:<context.entity>
            - determine NO_XP passively
            - determine NO_DROPS


        on player quits:
            - ratelimit <player> 1t
            - if <player.is_inside_vehicle>:
                - if <player.vehicle.proc[utilsu_entity_actual_name]> == BoatTrainU_strong_boat_seat_entity:
                    - mount cancel <player>
        #TODO FIX
        #on player clicks BoatTrainU_strong_boat_invisible_saddle in inventory:
        #    - determine cancelled
        #on player drags saddle in inventory:
        #    - determine cancelled
        # on player clicks saddle in inventory slot:1:
        #     - narrate ok
        #     #- stop if:<context.inventory.id_holder.entity_type.exists.not>
        #     #- if <player.open_inventory.id_holder.entity_type.exists>
        #-------------------

        on player right clicks BoatTrainU_strong_boat_entity bukkit_priority:HIGHEST:
            - ratelimit <player> 1t
            - determine passively cancelled
            - run BoatTrainU_seat_strong_boat def:<context.entity>
        #after player right clicks BoatTrainU_strong_boat_seat_entity with:lead:
        #    - narrate lead
        #    - determine cancelled
        #after player right clicks BoatTrainU_strong_boat_seat_entity with:!lead:
        #    - narrate no_lead
        #    - run BoatTrainU_seat_strong_boat def:<context.entity>

        on player leashes BoatTrainU_strong_boat_seat_entity:
            #- narrate cancel
            #- ratelimit <player> 1t
            - determine cancelled passively
        on player leashes BoatTrainU_strong_boat_entity:
            #- narrate cancel
            - determine cancelled passively

        on BoatTrainU_strong_boat_entity drops item:
            - determine cancelled
        #    #- wait 1s
        #    #- adjust <player> send_update_packets
        #    - define veh <context.entity.vehicle>
        #    - mount cancel <context.entity>
        #    - wait 5t
        #    #- adjust <[veh]> passengers:<[veh].passengers>
        #    - mount <context.entity>|<[veh]>
        #    #- adjust <context.entity> send_update_packets
        #    #- adjust <context.entity> reset_client_location
        #    - narrate reseted

        #after player enters
        on player right clicks BoatTrainU_strong_boat_seat_entity:
            - ratelimit <player> 1t
            - determine cancelled passively
            - run BoatTrainU_seat_strong_boat def:<context.entity>
            #- wait 1s

        #TODO FIX
        after player right clicks BoatTrainU_strong_boat_seat_entity cancelled:true:
            - ratelimit <player> 1t
            - if <player.item_in_hand.material.name> == lead || <player.item_in_hand.material.name> == lead:
                #- wait 1s
                - define veh <context.entity.vehicle>
                #- narrate <context.entity.vehicle>
                - mount cancel <context.entity>
                - wait 1t
                - mount <context.entity>|<[veh]>
                - adjust <[veh]> passengers:<[veh].passengers>
            #- run BoatTrainU_seat_strong_boat def:<context.entity>

        #after player right clicks BoatTrainU_strong_boat_seat_entity cancelled:true:
        #    - if !<proc[boattrainu_player_has_leashed_boat]>:
        #        - wait 1s
        #        - run BoatTrainU_seat_strong_boat def:<context.entity>
            #- run BoatTrainU_seat_strong_boat def:<context.entity>
        #on player enters BoatTrainU_strong_boat_seat_entity:
        #    - if <player.item_in_hand.if_null[<item[air]>].material.name> == lead:
        #        - determine cancelled
        #    - if <player.item_in_offhand.if_null[<item[air]>].material.name> == lead:
        #        - determine cancelled
        after player enters BoatTrainU_strong_boat_seat_entity:
            - adjust <context.vehicle> owner:<player>
            - wait 1t
            - look <player> yaw:<context.vehicle.location.yaw>

        after player exits BoatTrainU_strong_boat_seat_entity:
            - run boattrainu_strong_boat_hud_clear
            - run BoatTrainU_strong_boat_update_display def:<context.vehicle>|false
            - run BoatTrainU_strong_boat_off_cruise_control def:<context.vehicle>


        #after player enters BoatTrainU_strong_boat_seat_entity:
        #    #- determine cancelled passively
        #    #- if <proc[boattrainu_player_has_leashed_boat]>:
        #    #    - determine cancelled
        #    #- wait 1t
        #    - run BoatTrainU_seat_strong_boat def:<context.vehicle>


        #on BoatTrainU_strong_boat_seat_entity exits vehicle:
        #    - determine cancelled passively
        #    - wait 1s
        #    - mount cancel <context.entity>
        #    - wait 1s
        #    - mount <context.entity>|<context.entity.vehicle>

        #-------------------

        after player steers BoatTrainU_strong_boat_seat_entity:
            #- ratelimit <player> 2s

            - if <context.entity.saddle.material.name> != air:
                - give <context.entity.saddle>
                - equip <context.entity> saddle:air


            #- run boattrainu_show_debug def:<context.entity>
            - if !<context.entity.proc[boattrainu_strong_boat_has_fuel]>:
                - run BoatTrainU_strong_boat_update_hud def:false|no
                - run BoatTrainU_strong_boat_update_display def:<context.entity>|false|no
                - stop

            - define seat <context.entity>

            - if <context.jump>:
                - if !<[seat].has_flag[boattrainu_swtich_cooldown]>:
                    #- narrate switched
                    - flag <[seat]> boattrainu_swtich_cooldown expire:10t
                    - run boattrainu_strong_boat_switch_cruise_control def:<[seat]>

            - if <[seat].proc[boattrainu_strong_boat_is_cruise_control]> || <context.forward> > 0:
                - define forward 0.28
                - define direction forward
            - else if <context.sideways> != 0:
                - define forward 0.15
                - define direction forward
            - else:
                - define forward 0

            - run BoatTrainU_strong_boat_update_hud def:true|<[seat].proc[boattrainu_strong_boat_is_cruise_control]>

            - if <[forward]> == 0 && <context.sideways> == 0:
                - run BoatTrainU_strong_boat_update_display def:<[seat]>|false|no
                - stop

            - define base <context.entity.vehicle>

            - if <[base].is_on_ground>:
                - run BoatTrainU_strong_boat_update_display def:<[seat]>|false|no
                - stop

            - if <[forward]> != 0:
                - define velocity <location[0,0,0].with_pose[0,<[seat].location.yaw>].forward[1].mul[<[forward]>].with_y[<[base].velocity.y>]>
                - adjust <[base]> velocity:<[velocity]>

            - if <context.sideways> != 0:
                - if <context.sideways> < 0:
                    - rotate <[seat]> yaw:3 duration:1t
                    - define direction right
                - else:
                    - rotate <[seat]> yaw:-3 duration:1t
                    - define direction left

            - run BoatTrainU_strong_boat_spend_fuel def:<[seat]>

            - run BoatTrainU_strong_boat_update_display def:<[seat]>|true|<[direction]>
            - run BoatTrainU_strong_boat_active_particles def:<[seat]>

            #- run boattrainu_show_debug def:<[seat]>


#------------------------
BoatTrainU_strong_boat_update_hud:
    type: task
    debug: false
    definitions: has_fuel[Bool]|is_cruise_control[Bool]
    script:
        - if <[has_fuel]>:
            - run hudu_clear_ticket def:BoatTrainU_no_fuel
        - else:
            - define fuel <static[<element[<&color[#4e5c24]><&font[boattrainu:font]><&translate[hud.boattrainu.no_fuel]>].proc[hudu_get_ready_message].context[33|-16]>]>
            - run hudu_create_ticket def:BoatTrainU_no_fuel|<[fuel]>
            - run hudu_clear_ticket def:BoatTrainU_cruise
            - stop

        - define cruise_true <static[<element[<&color[0,200,0]><&font[boattrainu:font]><&translate[hud.boattrainu.cruise_control]>].proc[hudu_get_ready_message].context[18|-11]>]>
        - define cruise_false <static[<element[<&color[255,255,255]><&font[boattrainu:font]><&translate[hud.boattrainu.cruise_control]>].proc[hudu_get_ready_message].context[18|-11]>]>
        - if <[is_cruise_control]>:
            - run hudu_create_ticket def:BoatTrainU_cruise|<[cruise_true]>
        - else:
            - run hudu_create_ticket def:BoatTrainU_cruise|<[cruise_false]>


BoatTrainU_strong_boat_hud_clear:
    type: task
    debug: false
    script:
        - run hudu_clear_ticket def:BoatTrainU_no_fuel
        - run hudu_clear_ticket def:BoatTrainU_cruise

#-----------------
BoatTrainU_strong_boat_active_particles:
    type: task
    debug: false
    definitions: seat[EntityTag]
    script:
        - playeffect effect:CAMPFIRE_COSY_SMOKE at:<[seat].location.backward[2.1].right[0.35].above[3]> offset:0.5 quantity:1 visibility:100 velocity:<util.random.decimal[0].to[0.05]>,0.1,<util.random.decimal[0].to[0.08]>
        - playeffect effect:water_drop at:<[seat].location.backward[2.5].below[1]> offset:1.5 quantity:10 visibility:100 velocity:0,0.5,0

BoatTrainU_strong_boat_update_display:
    type: task
    debug: false
    definitions: seat[EntityTag]|active|direction
    script:
        - define display <[seat].vehicle.proc[boattrainu_get_display]>
        - if <[active]>:
            - choose <[direction]>:
                - case forward:
                    - adjust <[display]> item:paper[custom_model_data=110003]
                - case left:
                    - adjust <[display]> item:paper[custom_model_data=110004]
                - default:
                    - adjust <[display]> item:paper[custom_model_data=110005]
        - else:
            - adjust <[display]> item:paper[custom_model_data=110002]
        - wait 1t
        - adjust <[display]> left_rotation:<location[0,-1,0].to_axis_angle_quaternion[<[seat].location.yaw.to_radians>]>
        - adjust <[display]> interpolation_duration:1t
        - adjust <[display]> interpolation_start:0

BoatTrainU_remove_strong_boat:
    type: task
    debug: false
    definitions: base[EntityTag]
    script:
        - drop <[base].proc[boattrainu_get_seat].inventory.list_contents.remove[1|2].if_null[<list[]>]> <[base].location>
        - drop boattrainu_strong_boat <[base].location>
        - remove <[base].proc[boattrainu_get_seat]>
        - remove <[base].proc[boattrainu_get_display]>
        - wait 1t
        - if <[base].is_spawned>:
            - remove <[base]>

BoatTrainU_place_strong_boat:
    type: task
    debug: false
    definitions: location[LocationTag]
    script:
        - spawn boattrainu_strong_boat_entity <[location].with_pitch[0]> save:base
        - adjust <entry[base].spawned_entity> passengers:BoatTrainU_strong_boat_model_entity|BoatTrainU_strong_boat_seat_entity
        - cast regeneration duration:0 <entry[base].spawned_entity> hide_particles

BoatTrainU_seat_strong_boat:
    type: task
    debug: false
    definitions: entity[EntityTag]
    script:
        - if <[entity].script.name> == BoatTrainU_strong_boat_entity:
            - define seat <[entity].proc[boattrainu_get_seat]>
        - else:
            - define seat <[entity]>

        - if !<[seat].has_passenger>:
            - mount <player>|<[seat]>


BoatTrainU_strong_boat_switch_cruise_control:
    type: task
    debug: false
    definitions: seat[EntityTag]
    script:
        - if <[seat].proc[boattrainu_strong_boat_is_cruise_control]>:
            - flag <[seat]> BoatTrainU_cruise_control:!
            - stop
        - flag <[seat]> BoatTrainU_cruise_control

BoatTrainU_strong_boat_off_cruise_control:
    type: task
    debug: false
    definitions: seat[EntityTag]
    script:
        - flag <[seat]> BoatTrainU_cruise_control:!
# #------------FUEL--------------

BoatTrainU_strong_boat_spend_fuel:
    type: task
    debug: false
    definitions: seat[EntityTag]
    script:

        - define fuel_used <[seat].flag[BoatTrainU_fuel_used]>
        # топливо уже используется
        - if <[seat].flag[BoatTrainU_fuel_used]> != 0:
            # топливо уще горит
            - if <[fuel_used]> < <[seat].flag[BoatTrainU_fuel_item].proc[boattrainu_strong_boat_fuel_burn_time]>:
                - flag <[seat]> BoatTrainU_fuel_used:++
                - stop

            # топливо закончилось
            - flag <[seat]> BoatTrainU_fuel_item:!
            #- flag <[seat]> BoatTrainU_fuel_used:0


        # топливо только закончилось в прошлый раз

        - if <[seat].has_flag[BoatTrainU_fuel_item]>:
            # предмета есть
            - flag <[seat]> BoatTrainU_fuel_used:++
            - stop

        - define item <[seat].proc[BoatTrainU_strong_boat_get_next_fuel]>
        - if <[item]> != null:
            - run boattrainu_strong_boat_take_next_fuel def:<[seat]>
            - flag <[seat]> BoatTrainU_fuel_item:<[item]>
        - flag <[seat]> BoatTrainU_fuel_used:0


BoatTrainU_strong_boat_take_next_fuel:
    type: task
    debug: false
    definitions: seat[EntityTag]
    script:
        - define item <[seat].proc[boattrainu_strong_boat_fuel_list].first>
        - take item:<[item].proc[utilsu_item_actual_name]> from:<[seat].inventory>
        - if <[item].material.name> == lava_bucket:
            - give bucket to:<[seat].inventory> allowed_slots:!1|2

#------------------------
BoatTrainU_get_seat:
    type: procedure
    debug: false
    definitions: base[EntityTag]
    script:
        - determine <[base].passengers.get[2]>

BoatTrainU_get_display:
    type: procedure
    debug: false
    definitions: base[EntityTag]
    script:
        - determine <[base].passengers.get[1]>

BoatTrainU_strong_boat_is_cruise_control:
    type: procedure
    debug: false
    definitions: seat[EntityTag]
    script:
        - determine <[seat].has_flag[BoatTrainU_cruise_control]>

# #------------FUEL--------------
BoatTrainU_strong_boat_has_fuel:
    type: procedure
    debug: false
    definitions: seat[EntityTag]
    script:
        - determine <[seat].has_flag[BoatTrainU_fuel_item].or[<[seat].proc[BoatTrainU_strong_boat_fuel_list].size.equals[0].not>]>

BoatTrainU_strong_boat_fuel_list:
    type: procedure
    debug: false
    definitions: seat[EntityTag]
    script:
        - determine <[seat].inventory.list_contents.filter[material.is_fuel]>

BoatTrainU_strong_boat_fuel_burn_time:
    type: procedure
    debug: false
    definitions: item[ItemTag]
    script:
        #- determine <element[3].mul[<[item].quantity>]>
        - determine <[item].material.fuel_burn_time.in_ticks.mul[<[item].quantity>]>

BoatTrainU_strong_boat_fuel_amount:
    type: procedure
    debug: false
    definitions: seat[EntityTag]
    script:
        - define amount 0
        - foreach <[seat].proc[boattrainu_strong_boat_fuel_list]> as:item:
            - define amount:+:<[item].proc[boattrainu_strong_boat_fuel_burn_time]>
        - determine <[amount]>

BoatTrainU_strong_boat_get_next_fuel:
    type: procedure
    debug: false
    definitions: seat[EntityTag]
    script:
        - define items <[seat].proc[boattrainu_strong_boat_fuel_list]>
        - if <[items].size> == 0:
            - determine null
        - determine <[items].first.with[quantity=1]>