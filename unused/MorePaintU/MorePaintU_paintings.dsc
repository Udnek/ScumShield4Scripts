
MorePaintU_painting:
    type: entity
    debug: false
    entity_type: item_display
    mechanisms:
        #translation: 0,-0.375,0.001
        translation: 0,0,-0.001

MorePainU_data:
    type: data

    paintings:
        1x1:
            #item: diamond_sword
            cmd: 10000001
        1x2:
            cmd: 10000001
        2x1:
            cmd: 10000002
        2x2:
            cmd: 10000001
        4x2:
            cmd: 10000002
        4x3:
            cmd: 10000001
        4x4:
            cmd: 10000001

MorePaintU_paintings_events:
    type: world
    debug: false
    events:
        on player places painting:
            - adjust <context.hanging> hide_from_players
            #- wait 1s
            - run morepaintu_show_painting def:<context.hanging>
            - wait 2t
            - adjust <context.hanging> show_to_players

        on hanging breaks:
            - if <context.hanging.proc[morepaintu_has_display_entity]>:
                - remove <context.hanging.proc[morepaintu_get_display_entity]>




MorePaintU_show_painting:
    type: task
    debug: false
    definitions: painting
    script:
        - define x_size <[painting].painting_width>
        - define y_size <[painting].painting_height>

        - define data <script[MorePainU_data].data_key[paintings]>
        - define display_data <[data].get[<[x_size]>x<[y_size]>]>
        - define cmd <[display_data].get[cmd].if_null[]>
        - define item <[display_data].get[item].if_null[flint]>[custom_model_data=<[cmd]>]
        - define display MorePaintU_painting[scale=<[x_size].add[0.0001]>,<[y_size].add[0.0001]>,1;item=<[item]>]
        - spawn <[display]> <[painting].location.rotate_yaw[180]> save:display
        #- adjust <[display]> scale:<[x_size].add[0.0001]>,<[y_size].add[0.0001]>,1
        #- adjust <[display]> item:<[item]>
        - run morepaintu_set_display_entity def:<[painting]>|<entry[display].spawned_entity>
        #- adjust <[painting]> passenger:<[display]>


MorePaintU_set_display_entity:
    type: task
    debug: false
    definitions: painting|display
    script:
        - flag <[painting]> MorePaintU_display:<[display]>

MorePaintU_get_display_entity:
    type: procedure
    debug: false
    definitions: painting
    script:
        - determine <[painting].flag[MorePaintU_display]>

MorePaintU_has_display_entity:
    type: procedure
    debug: false
    definitions: painting
    script:
        - determine <[painting].has_flag[MorePaintU_display]>