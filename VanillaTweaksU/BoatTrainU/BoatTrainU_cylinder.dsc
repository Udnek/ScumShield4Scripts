BoatTrainU_cylinder_entity:
    type: entity
    debug: false
    entity_type: chicken
    mechanisms:
        invulnerable: true
        age: baby
        age_locked: true
        silent: true
        speed: 0
        persistent: true
        force_no_persist: false
        passenger: BoatTrainU_cylinder_model_entity
        visible: false
        #is_aware: false

BoatTrainU_cylinder_model_entity:
    type: entity
    debug: false
    entity_type: item_display
    mechanisms:
        display: HEAD
        item: BoatTrainU_boat_cylinder
        translation: 0,0.15,0


BoatTrainU_boat_cylinder:
    type: item
    debug: false
    material: paper
    display name: <reset><&translate[item.boattrainu.boat_cylinder]>
    mechanisms:
        custom_model_data: 110001
    recipes:
        1:
            type: shaped
            output_quantity: 1
            input:
            - material:copper_ingot|material:copper_block/waxed_copper_block|material:copper_ingot
            - material:copper_block/waxed_copper_block|air|material:copper_block/waxed_copper_block
            - material:copper_ingot|material:copper_block/waxed_copper_block|material:copper_ingot

#BoatTrainU_boat_rope:
#    type: item
#    debug: false
#    material: lead
#    #display name: <reset><&translate[item.boattrainu.boat_rope]>
#    allow in material recipes: true
#    no_id: true

#---------------------
BoatTrainU_cylinder_events:
    type: world
    debug: false
    events:
        after player right clicks BoatTrainU_cylinder_entity:
            - determine cancelled

        after player right clicks boat|chest_boat with:BoatTrainU_boat_cylinder:
            - ratelimit <player> 1t
            #- if !<player.is_sneaking>:
            #    - stop

            - define boat <context.entity>
            - if <[boat].proc[boattrainu_has_cylinder]>:
                - stop
            - if <[boat].proc[boattrainu_boats_under]> > 0:
                - stop

            - take slot:<context.hand.replace_text[main].with[itemin]>
            - run boattrainu_add_cylinder def:<[boat]>

        on BoatTrainU_cylinder_entity dies:
            - determine <list[<item[boattrainu_boat_cylinder]>]>

        on vehicle destroyed:
            - if <context.vehicle.proc[boattrainu_has_cylinder]>:
                - run boattrainu_remove_cylinder def:<context.vehicle.proc[boattrainu_get_cylinder]>

        on BoatTrainU_cylinder_entity enters vehicle:
            - determine cancelled


BoatTrainU_rope_events:
    type: world
    debug: false
    events:
        after player right clicks boat|chest_boat|BoatTrainU_strong_boat_entity with:lead:
            - ratelimit <player> 1t

            - define boat <context.entity>
            - if <proc[boattrainu_player_has_leashed_boat]>:
                - define leashed_boat <proc[boattrainu_player_get_leashed_boat]>
                - if <[leashed_boat]> == <[boat]>:
                    - run boattrainu_unleash_boat_from_player def:<[boat]>
                    - drop lead <[boat].location>
                    - stop

                - else if <[boat].proc[boattrainu_boat_can_be_holder]>:
                    - run boattrainu_leash_boat_to_boat def:<[boat]>|<[leashed_boat]>
                    - stop

                - stop


            - if !<[boat].proc[boattrainu_boat_can_be_leashed]>:
                - stop

            - take iteminhand

            - if <proc[boattrainu_is_inside_boat]>:
                - run boattrainu_leash_boat_to_boat def:<player.vehicle>|<[boat]>
                - stop

            - run BoatTrainU_leash_boat_to_player def:<[boat]>


        after player right clicks boat|chest_boat|BoatTrainU_strong_boat_entity with:!lead:
            - ratelimit <player> 1t

            - if !<proc[boattrainu_player_has_leashed_boat]>:
                - stop

            - define boat <context.entity>
            - define leashed_boat <proc[boattrainu_player_get_leashed_boat]>
            - if <[leashed_boat]> == <[boat]>:
                - run boattrainu_unleash_boat_from_player def:<[boat]>
                - drop lead <[boat].location>
                - stop

            - else if <[boat].proc[boattrainu_boat_can_be_holder]>:
                - run boattrainu_leash_boat_to_boat def:<[boat]>|<[leashed_boat]>
                - stop

        #on BoatTrainU_cylinder_entity unleashed:
        #    - announce <context.reason>
        #    - stop if:<context.entity.leash_holder.is_player.not>
        #    - run boattrainu_remove_leashed_boat player:<context.entity.leash_holder>


        on BoatTrainU_cylinder_entity unleashed because DISTANCE:
            - stop if:<context.entity.leash_holder.is_player>
            - stop if:<context.entity.location.distance[<context.entity.leash_holder.location>].is_more_than[25]>
            - determine cancelled passively
            - stop if:<context.entity.has_flag[BoatTrainU_no_push]>
            - flag <context.entity> BoatTrainU_no_push expire:10t
            - push <context.entity> o:<context.entity> destination:<context.entity.leash_holder.location> speed:0.3 duration:0t

        #after player quits flagged:BoatTrainU_leashed_boat:
        #    - run boattrainu_remove_leashed_boat

#-------------------
BoatTrainU_add_cylinder:
    type: task
    debug: false
    definitions: boat[EntityTag]
    script:
        - mount <[boat]>|BoatTrainU_cylinder_entity


BoatTrainU_remove_cylinder:
    type: task
    debug: false
    definitions: cylinder[EntityTag]
    script:
        - foreach <[cylinder].passengers> as:pass:
            - if <[pass].proc[utilsu_entity_actual_name]> == BoatTrainU_cylinder_model_entity:
                - remove <[pass]>
        - drop boattrainu_boat_cylinder <[cylinder].location>
        - remove <[cylinder]>


BoatTrainU_leash_boat_to_boat:
    type: task
    debug: false
    definitions: holder[EntityTag]|attached[EntityTag]
    script:
        - if <[holder].proc[utilsu_entity_actual_name]> == BoatTrainU_strong_boat_entity:
            - leash <[attached].proc[boattrainu_get_cylinder]> holder:<[holder]>
            - stop
        - leash <[attached].proc[boattrainu_get_cylinder]> holder:<[holder].proc[boattrainu_get_bolting]>

BoatTrainU_leash_boat_to_player:
    type: task
    debug: false
    definitions: boat[EntityTag]
    script:
        - leash <[boat].proc[boattrainu_get_cylinder]> holder:<player>

BoatTrainU_unleash_boat_from_boat:
    type: task
    debug: false
    definitions: holder[EntityTag]|attached[EntityTag]
    script:
        - leash cancel <[attached].proc[boattrainu_get_cylinder]>

BoatTrainU_unleash_boat_from_player:
    type: task
    debug: false
    definitions: boat[EntityTag]
    script:
        - leash cancel <[boat].proc[boattrainu_get_cylinder]>
#-------------------
BoatTrainU_has_cylinder:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - if <[boat].is_inside_vehicle>:
            - if <[boat].vehicle.proc[utilsu_entity_actual_name]> == BoatTrainU_cylinder_entity:
                - determine true
        - determine false

BoatTrainU_get_cylinder:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - determine <[boat].vehicle>

BoatTrainU_get_boat_from_cylinder:
    type: procedure
    debug: false
    definitions: cylinder[EntityTag]
    script:
        - foreach <[cylinder].passengers> as:pass:
            - if <[pass].proc[utilsu_entity_actual_name]> matches boat|chest_boat:
                - determine <[pass]>


BoatTrainU_is_inside_boat:
    type: procedure
    debug: false
    script:
        - if <player.is_inside_vehicle>:
            - if <player.vehicle.proc[utilsu_entity_actual_name]> matches boat|chest_boat:
                - determine true
        - determine false


BoatTrainU_player_get_leashed_boat:
    type: procedure
    debug: false
    script:
        - foreach <player.location.find_entities[BoatTrainU_cylinder_entity].within[30].filter[is_leashed]> as:cylinder:
            - if <[cylinder].leash_holder> == <player>:
                - determine <[cylinder].proc[BoatTrainU_get_boat_from_cylinder]>

BoatTrainU_boats_leashed_to_boat_amount:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - if !<[boat].proc[boattrainu_has_bolting]>:
            - determine 0

        - define amount 0
        - define bolting <[boat].proc[boattrainu_get_bolting]>
        - foreach <[bolting].location.find_entities[BoatTrainU_cylinder_entity].within[30].filter[is_leashed]> as:cylinder:
            - if <[cylinder].leash_holder> == <[bolting]>:
                - define amount:+:1
        - determine <[amount]>


BoatTrainU_boat_leashed_boat:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - define bolting <[boat].proc[boattrainu_get_bolting]>
        - foreach <[bolting].location.find_entities[BoatTrainU_cylinder_entity].within[30].filter[is_leashed]> as:cylinder:
            - if <[cylinder].leash_holder> == <[bolting]>:
                - determine <[cylinder].proc[boattrainu_get_boat_from_cylinder]>


BoatTrainU_player_has_leashed_boat:
    type: procedure
    debug: false
    script:
        - foreach <player.location.find_entities[BoatTrainU_cylinder_entity].within[30].filter[is_leashed]> as:cylinder:
            - if <[cylinder].leash_holder> == <player>:
                - determine true
        - determine false

BoatTrainU_boat_can_be_holder:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - if <[boat].proc[BoatTrainU_train_size]> <= 5:
            - if ( <[boat].proc[boattrainu_has_cylinder]> && <[boat].proc[boattrainu_has_bolting]> && <[boat].proc[boattrainu_boats_leashed_to_boat_amount]> == 0 && <[boat].proc[boattrainu_boats_under]> == 0 ) || ( <[boat].proc[utilsu_entity_actual_name]> == BoatTrainU_strong_boat_entity ):
                - determine true
        - determine false

BoatTrainU_boat_can_be_leashed:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - if <[boat].proc[boattrainu_has_cylinder]> && !<[boat].is_leashed>:
            - determine true
        - determine false

BoatTrainU_train_size:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - define amount 1
        - define this_boat <[boat]>
        - while <[this_boat].proc[boattrainu_has_cylinder]>:
            - define cylinder <[this_boat].proc[boattrainu_get_cylinder]>
            - if !<[cylinder].is_leashed>:
                - while stop
            - define amount:+:1
            - if <[cylinder].leash_holder.proc[utilsu_entity_actual_name]> == BoatTrainU_strong_boat_entity:
                - define amount:+:1
                - while stop
            - else:
                - define this_boat <[cylinder].leash_holder.vehicle>


        - define this_boat <[boat]>
        - while <[this_boat].proc[boattrainu_boats_leashed_to_boat_amount]> != 0:
            - define amount:+:1
            - define this_boat <[this_boat].proc[boattrainu_boat_leashed_boat]>


        - determine <[amount]>

