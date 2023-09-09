BoatTrainU_events:
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

            - if <player.item_in_hand.proc[utilsu_item_actual_name]> matches BoatTrainU_boat_bolting|BoatTrainU_boat_cylinder|lead:
                - determine cancelled

            - if <proc[boattrainu_player_has_leashed_boat]>:
                - determine cancelled


        on player enters boat|chest_boat:
            - if <player.item_in_hand.proc[utilsu_item_actual_name]> matches BoatTrainU_boat_bolting|BoatTrainU_boat_cylinder|lead:
                - determine cancelled

            - if <proc[boattrainu_player_has_leashed_boat]>:
                - determine cancelled

        on player quits:
            - if <player.is_inside_vehicle>:
                - if <player.vehicle.proc[boattrainu_has_bolting]>:
                    - mount cancel <player>
                - else if <player.vehicle.proc[boattrainu_has_cylinder]>:
                    - mount cancel <player>
                - else if <player.vehicle.is_inside_vehicle>:
                    - mount cancel <player>


BoatTrainU_items_gui:
    type: inventory
    inventory: hopper
    gui: true
    title: <&color[#B87333]><bold>BoatTrainU
    slots:
        - [BoatTrainU_boat_bolting] [BoatTrainU_boat_cylinder] [BoatTrainU_paddle_wheel] [BoatTrainU_strong_boat] []

BoatTrainU_gui_commands:
    type: command
    debug: false
    name: BoatTrainU
    description: BoatTrainU
    usage: /BoatTrainU
    script:
        - inventory open destination:BoatTrainU_items_gui

BoatTrainU_gui_events:
    type: world
    debug: false
    events:
        after player clicks item in BoatTrainU_items_gui:
            - run EnoughItemsU_open_new_recipe_gui def:<context.item>|true|<context.inventory.script.name>