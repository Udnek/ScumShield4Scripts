BoatTrainU_bolting_item_data:
    type: data
    items:
        oak_boat: boat[color=oak]
        spruce_boat: boat[color=spruce]
        birch_boat: boat[color=birch]
        jungle_boat: boat[color=jungle]
        acacia_boat: boat[color=acacia]
        dark_oak_boat: boat[color=dark_oak]
        mangrove_boat: boat[color=mangrove]
        cherry_boat: boat[color=cherry]
        bamboo_raft: boat[color=bamboo]

        oak_chest_boat: chest_boat[color=oak]
        spruce_chest_boat: chest_boat[color=spruce]
        birch_chest_boat: chest_boat[color=birch]
        jungle_chest_boat: chest_boat[color=jungle]
        acacia_chest_boat: chest_boat[color=acacia]
        dark_oak_chest_boat: chest_boat[color=ark_oak]
        mangrove_chest_boat: chest_boat[color=mangrove]
        cherry_chest_boat: chest_boat[color=cherry]
        bamboo_chest_raft: chest_boat[color=bamboo]

#---------------------

BoatTrainU_bolting_entity:
    type: entity
    debug: false
    entity_type: armor_stand
    mechanisms:
        disabled_slots: <map[HEAD=ALL;CHEST=ALL;LEGS=ALL;FEET=ALL]>
        equipment: <map[HELMET=BoatTrainU_boat_bolting]>
        base_plate: false

BoatTrainU_boat_bolting:
    type: item
    debug: false
    material: paper
    display name: <reset><&translate[item.boattrainu.boat_bolting]>
    mechanisms:
        custom_model_data: 110000
    recipes:
        1:
            type: shaped
            output_quantity: 1
            input:
            - material:copper_ingot|material:copper_block/waxed_copper_block|material:copper_ingot
            - material:copper_ingot|material:copper_block/waxed_copper_block|material:copper_ingot
            - air|material:copper_block/waxed_copper_block|air

#---------------------
BoatTrainU_bolting_events:
    type: world
    debug: false
    events:
        on player opens chest:
            - stop if:<context.inventory.id_holder.entity_type.exists.not>
            - if <context.inventory.id_holder.entity_type> != CHEST_BOAT:
                - stop
            - if <player.is_inside_vehicle>:
                - if <context.inventory.id_holder> == <player.vehicle>:
                    - stop

            - if <player.item_in_hand.proc[utilsu_item_actual_name]> == BoatTrainU_boat_bolting:
                - determine cancelled

        after player right clicks boat|chest_boat with:BoatTrainU_boat_bolting:
            - ratelimit <player> 1t
            #- if !<player.is_sneaking>:
            #    - stop

            - define boat <context.entity>
            - if <[boat].proc[boattrainu_has_bolting]>:
                - stop
            - if <[boat].proc[BoatTrainU_boats_under]> >= 4:
                - stop

            - take slot:<context.hand.replace_text[main].with[itemin]>
            - run boattrainu_add_bolting def:<[boat]>


        after player right clicks BoatTrainU_bolting_entity with:*_boat|bamboo*_raft:
            - ratelimit <player> 1t
            - if <context.hand> == offhand:
                - stop

            - define bolting <context.entity>

            - if !<[bolting].proc[boattrainu_is_empty_bolting]>:
                - stop

            - take slot:<context.hand.replace_text[main].with[itemin]>
            - run boattrainu_add_boat def:<[bolting]>|<context.item>


        on BoatTrainU_bolting_entity dies:
            - determine <list[<item[BoatTrainU_boat_bolting]>]>

        #on boat destroyed:
        #    - if <context.vehicle.proc[boattrainu_has_bolting]>:
        #        - run boattrainu_remove_bolting def:<context.vehicle.proc[boattrainu_get_bolting]>
        #
        #on chest_boat destroyed:
        #    - if <context.vehicle.proc[boattrainu_has_bolting]>:
        #        - run boattrainu_remove_bolting def:<context.vehicle.proc[boattrainu_get_bolting]>


        after BoatTrainU_bolting_entity exits vehicle:
            - if <context.entity.is_spawned>:
                - run boattrainu_remove_bolting def:<context.entity>

#---------------------
BoatTrainU_remove_bolting:
    type: task
    debug: false
    definitions: bolting[EntityTag]
    script:
        - drop boattrainu_boat_bolting <[bolting].location>
        - remove <[bolting]>

BoatTrainU_add_bolting:
    type: task
    debug: false
    definitions: boat[EntityTag]
    script:
        - mount BoatTrainU_bolting_entity|<[boat]>

BoatTrainU_add_boat:
    type: task
    debug: false
    definitions: bolting[EntityTag]|boat_item[ItemTag]
    script:
        - mount <[boat_item].proc[boattrainu_get_boat_from_item]>|<[bolting]>

#-------------------------
BoatTrainU_boats_under:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - define amount 0
        - define entity <[boat]>
        - while <[entity].is_inside_vehicle> && !<[entity].proc[boattrainu_has_cylinder]>:
            - define amount:+:1
            - define entity <[entity].vehicle.vehicle.if_null[<[entity].vehicle>]>
        - determine <[amount]>


BoatTrainU_has_bolting:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - foreach <[boat].passengers> as:pass:
            - if <[pass].proc[utilsu_entity_actual_name]> == BoatTrainU_bolting_entity:
                - determine true
        - determine false


BoatTrainU_get_bolting:
    type: procedure
    debug: false
    definitions: boat[EntityTag]
    script:
        - foreach <[boat].passengers> as:pass:
            - if <[pass].proc[utilsu_entity_actual_name]> == BoatTrainU_bolting_entity:
                - determine <[pass]>


BoatTrainU_is_empty_bolting:
    type: procedure
    debug: false
    definitions: bolting[EntityTag]
    script:
        - determine <[bolting].passengers.size.equals[0]>


BoatTrainU_get_boat_from_item:
    type: procedure
    debug: false
    definitions: item[ItemTag]
    script:
        - define data <script[BoatTrainU_bolting_item_data].data_key[items]>
        - determine <[data].get[<[item].material.name>]>
