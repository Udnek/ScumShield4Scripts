#------------------------
MorePaintU_frame_hitbox_entity:
    type: entity
    debug: false
    entity_type: falling_block
    mechanisms:
        fallingblock_type: water
        invulnerable: true
        auto_expire: false
        time_lived: 800
        gravity: false

#MorePaintU_frame_hitbox_holder_entity:
#    type: entity
#    debug: false
#    entity_type: item_display
#    mechanisms:
#        passenger: MorePaintU_frame_hitbox_entity
#------------------------
MorePaintU_brush:
    type: item
    material: iron_axe
    display name: Brush

#------------------------
MorePaintU_drawing_events:
    type: world
    debug: false
    events:

        on player right clicks item_frame with:MorePaintU_brush:
            - define frame <context.entity>
            - if <[frame].framed_item.material.name> != filled_map:
                - stop
            - determine cancelled passively
            - ratelimit <player> 1t
            - spawn morepaintu_frame_hitbox_holder_entity <context.entity.location.below[0.5].backward[0.45]> save:hitbox
           # - narrate <entry[hitbox].>

        #on player right clicks item_frame with:MorePaintU_brush:
        #    - determine cancelled passively
        #    - ratelimit <player> 1t
        #    - narrate <util.current_tick>
#
#
        #    - define map_trace <player.trace_framed_map.if_null[null]>
        #    - if <[map_trace]> == null:
        #        - stop
#
        #    - define x <[map_trace].get[x].div[8].round_down.mul[8].add[1]>
        #    - define y <[map_trace].get[y].div[8].round_down.mul[8].add[1]>
        #    - define map <[map_trace].get[map]>
        #    - repeat 4 from:0 as:x_pos:
        #        - repeat 4 from:0 as:y_pos:
        #            - map <[map]> dot:<color[<util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>]> radius:1 x:<[x_pos].mul[2].add[<[x]>]> y:<[y_pos].mul[2].add[<[y]>]>

        after player right clicks block with:MorePaintU_brush:
            - ratelimit <player> 1t
            - narrate <util.current_tick>


            - define map_trace <player.trace_framed_map.if_null[null]>
            - if <[map_trace]> == null:
                - stop

            - define x <[map_trace].get[x].div[8].round_down.mul[8].add[1]>
            - define y <[map_trace].get[y].div[8].round_down.mul[8].add[1]>
            - define map <[map_trace].get[map]>
            - repeat 4 from:0 as:x_pos:
                - repeat 4 from:0 as:y_pos:
                    - map <[map]> dot:<color[<util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>]> radius:1 x:<[x_pos].mul[2].add[<[x]>]> y:<[y_pos].mul[2].add[<[y]>]>

        #after player right clicks MorePaintU_frame_hitbox_entity with:shield:
        #after player raises MorePaintU_brush:
        #    #- narrate <context.entity.location>
#
        #    - define cache_xy _
        #    - while <player.is_hand_raised>:
        #        - narrate <util.current_tick>
#
        #        - define map_trace <player.trace_framed_map.if_null[null]>
        #        - if <[map_trace]> != null:
#
        #            - define x <[map_trace].get[x].div[8].round_down.mul[8].add[1]>
        #            - define y <[map_trace].get[y].div[8].round_down.mul[8].add[1]>
        #            - define map <[map_trace].get[map]>
#
        #            - if <[cache_xy]> != <[x]><[y]>:
#
        #                - repeat 4 from:0 as:x_pos:
        #                    - repeat 4 from:0 as:y_pos:
        #                        - map <[map]> dot:<color[<util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>]> radius:1 x:<[x_pos].mul[2].add[<[x]>]> y:<[y_pos].mul[2].add[<[y]>]>
#
        #                - define cache_xy <[x]><[y]>
#
        #        - wait 1t

#MorePaintU_set_hitbox_holder:
#    type: task
#    definitions: frame[EntityTag]|hitbox_holder[EntityTag]
#    script:
#        - flag <[frame]> MorePaintU_hitbox_holder:<[hitbox_holder]>
#
#MorePaintU_get_hitbox_holder:
#    type: procedure
#    definitions: frame[EntityTag]
#    script:
#        - determine <[frame].flag[MorePaintU_hitbox_holder]>
#
#MorePaintU_has_hitbox_holder:
#    type: procedure
#    definitions: frame[EntityTag]
#    script:
#        - determine <[frame].has_flag[MorePaintU_hitbox_holder]>


#----------------------------
MorePaintU_palette:
    type: item
    material: stick
    display name: Palette

#MorePaintU_palette:
#    type: item
#    material: stick
#    display name: Palette

MorePaintU_palette_mix_space:
    type: item
    material: leather_chestplate
    display name: mix_space


MorePaintU_palette_data:
    type: data

    mix_spaces:
        - 21
        - 23
        - 25

        - 39
        - 41
        - 43

    dyes:
        white_dye: 249,255,254
        gray_dye: 71,79,82
        black_dye: 29,29,33
        blue_dye: 37,43,215
        light_blue_dye: 58,179,218
        green_dye: 94,124,22
        lime_dye: 128,199,31
        yellow_dye: 254,216,61
        orange_dye: 249,128,29
        red_dye: 176,46,38


MorePaintU_palette_gui:
    type: inventory
    debug: false
    inventory: chest
    gui: true
    title: <&translate[space.-8]><white><&translate[gui.morepaintu.palette.texture].font[morepaintu:font]><&translate[space.-170]><&translate[gui.morepaintu.palette]>
    definitions:
        white: white_dye
        gray: gray_dye
        black: black_dye
        blue: blue_dye
        light_blue: light_blue_dye
        green: green_dye
        lime: lime_dye
        yellow: yellow_dye
        orange: orange_dye
        red: red_dye
    slots:
    - [] [blue] [light_blue] [green] [lime] [yellow] [orange] [red] []
    - [black] [] [] [] [] [] [] [] []
    - [gray] [] [] [] [] [] [] [] []
    - [white] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    #- [] [brown_dye] [red_dye] [orange_dye] [yellow_dye] [lime_dye] [green_dye] [cyan_dye] []
    #- [black_dye] [] [] [] [] [] [] [] [light_blue_dye]
    #- [gray_dye] [] [] [] [] [] [] [] [blue_dye]
    #- [light_gray_dye] [] [] [] [] [] [] [] [purple_dye]
    #- [white_dye] [] [] [] [] [] [] [] [magenta_dye]
    #- [] [] [] [] [] [] [] [] [pink_dye]

MorePaintU_palette_events:
    type: world
    debug: false
    events:
        after player right clicks block with:MorePaintU_palette:
            - run morepaintu_palette_open_gui def:<context.item>

        after player clicks in MorePaintU_palette_gui:
            - narrate <context.slot>

        after player clicks *dye in MorePaintU_palette_gui with:air:
            - adjust <player> item_on_cursor:<item[MorePaintU_palette_mix_space].with[color=<context.item.proc[morepaintu_palette_dye_item_to_color]>]>

        after player clicks MorePaintU_palette_mix_space in MorePaintU_palette_gui with:air:
            - adjust <player> item_on_cursor:<context.item>

        on player clicks in MorePaintU_palette_gui with:MorePaintU_palette_mix_space:
            - if <context.item.proc[utilsu_item_actual_name]> != MorePaintU_palette_mix_space:
                - take cursoritem
                - determine cancelled
            - define new_color <context.item.color.mix[<context.cursor_item.color>]>
            - inventory adjust color:<[new_color]> slot:<context.slot> destination:<player.open_inventory>
            - take cursoritem
            - inventory set origin:<player.item_in_hand.proc[morepaintu_palette_with_mix_space].context[<context.slot>|<[new_color]>]> slot:<player.held_item_slot>

        on player closes MorePaintU_palette_gui:
            - if <player.item_on_cursor.proc[utilsu_item_actual_name]> == MorePaintU_palette_mix_space:
                - take cursoritem

MorePaintU_palette_open_gui:
    type: task
    debug: false
    definitions: item[ItemTag]
    script:
        - define gui <inventory[MorePaintU_palette_gui]>

        - define mix_space <item[MorePaintU_palette_mix_space]>
        - define item_mix_spaces <[item].proc[morepaintu_palette_get_mix_spaces]>
        - foreach <proc[morepaintu_palette_all_mix_spaces]> as:slot:
            - if <[item_mix_spaces].contains[<[slot]>]>:
                - inventory set origin:<[mix_space].with[color=<[item_mix_spaces].get[<[slot]>]>]> slot:<[slot]> destination:<[gui]>
            - else:
                - inventory set origin:<[mix_space]> slot:<[slot]> destination:<[gui]>

        - inventory open destination:<[gui]>


MorePaintU_palette_dye_item_to_color:
    type: procedure
    debug: false
    definitions: item[ItemTag]
    script:
        - define data <script[MorePaintU_palette_data].data_key[dyes]>
        - determine <color[<[data].get[<[item].material.name>]>]>


MorePaintU_palette_all_mix_spaces:
    type: procedure
    debug: false
    script:
        - determine <script[MorePaintU_palette_data].data_key[mix_spaces]>


MorePaintU_palette_get_mix_spaces:
    type: procedure
    debug: false
    definitions: item[ItemTag]
    script:
        - if !<[item].has_flag[MorePaintU_palette_mix_spaces]>:
            - determine <map[]>
        - determine <[item].flag[MorePaintU_palette_mix_spaces]>


MorePaintU_palette_with_mix_space:
    type: procedure
    debug: false
    definitions: item[ItemTag]|slot[Int]|color[ColorTag]
    script:
        - determine <[item].with_flag[MorePaintU_palette_mix_spaces.<[slot]>:<[color]>]>
        #- flag <[item]> MorePaintU_palette_mix_spaces.<[slot]>:<[color]>