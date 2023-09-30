#------------------------
#MorePaintU_frame_hitbox_entity:
#    type: entity
#    debug: false
#    entity_type: falling_block
#    mechanisms:
#        fallingblock_type: water
#        invulnerable: true
#        auto_expire: false
#        time_lived: 800
#        gravity: false

#MorePaintU_frame_hitbox_holder_entity:
#    type: entity
#    debug: false
#    entity_type: item_display
#    mechanisms:
#        passenger: MorePaintU_frame_hitbox_entity

MorePaintU_frame_hitbox_entity:
    type: entity
    debug: false
    entity_type: interaction
    mechanisms:
        width: 0.999
        height: 0.999
        is_aware: true

MorePaintU_canvas_entity:
    type: entity
    debug: false
    entity_type: text_display
    mechanisms:
        text: <proc[morepaintu_canvas_data_generate].context[32|32].proc[morepaintu_canvas_data_to_display_text]>
        line_width: <element[32].proc[MorePaintU_canvas_display_line_width]>
        scale: 0.126,0.126,0.126
        translation: -0.005,-0.49,0.04
        background_color: 0,0,0,0
    #flags:
    #    morepaintu_canvas_data: <proc[morepaintu_canvas_data_generate].context[32|32]>

#------------------------
MorePaintU_brush:
    type: item
    material: firework_star
    display name: Brush

MorePaintU_sketch:
    type: item
    material: painting
    display name: sketch
    lore:
        - <proc[morepaintu_canvas_data_generate].context[32|32].proc[MorePaintU_canvas_data_to_lore_text]>
    mechanisms:
        raw_nbt: <map[EntityTag=<map[variant=string:minecraft:kebab]>]>
        hides: ALL
    flags:
        morepaintu_canvas_data: <proc[morepaintu_canvas_data_generate].context[32|32]>

MorePaintU_finished_painting:
    type: item
    material: painting
    display name: painting
    mechanisms:
        raw_nbt: <map[EntityTag=<map[variant=string:minecraft:kebab]>]>

#------------------------
MorePaintU_drawing_events:
    type: world
    debug: false
    events:

        #on player right clicks item_frame with:MorePaintU_brush:
        #    - define frame <context.entity>
        #    - if <[frame].framed_item.material.name> != filled_map:
        #        - stop
        #    - determine cancelled passively
        #    - ratelimit <player> 1t
#
        #    - spawn morepaintu_frame_hitbox_entity <context.entity.location.below[0.5].backward[0.45]> save:hitbox
        #    - spawn morepaintu_canvas_entity <context.entity.location> save:canvas
#
        #    - define hitbox <entry[hitbox].spawned_entity>
        #    - define canvas <entry[canvas].spawned_entity>
#
        #    - flag <[frame]> canvas:<[canvas]>
        #    - flag <[hitbox]> canvas:<[canvas]>
        #    - flag <[hitbox]> frame:<[frame]>

        #after player right clicks block with:MorePaintU_brush:
        after player right clicks MorePaintU_frame_hitbox_entity with:MorePaintU_brush:
            - ratelimit <player> 1t

            - define map_trace <player.trace_framed_map.if_null[null]>
            - if <[map_trace]> == null:
                - stop

            - define canvas <[map_trace].get[entity].flag[morepaintu_canvas]>

            #- narrate <[map_trace].get[x]>_<[map_trace].get[y]>
            #- define x <[map_trace].get[x].div[4].round_down.mul[4].add[1]>
            #- define y <[map_trace].get[y].div[4].round_down.mul[4].add[1]>
            #- define map <[map_trace].get[map]>
            #- repeat 2 from:0 as:x_pos:
            #    - repeat 2 from:0 as:y_pos:
            #        - map <[map]> dot:<color[<util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>]> radius:1 x:<[x_pos].mul[2].add[<[x]>]> y:<[y_pos].mul[2].add[<[y]>]>

            #TODO FIX
            #- if <[map_trace].get[x]> == 128 || <[map_trace].get[y]> == 128:
            #    - narrate "<red>X or Y is 128!"
            #    - stop

            - define canvas_data <[canvas].flag[morepaintu_canvas_data]>

            - define canvas_x <[map_trace].get[x].mul[0.9921875].div[4].round_down.add[1]>
            - define canvas_y <[map_trace].get[y].mul[0.9921875].div[4].round_down.add[1]>

            - narrate <[canvas_x]>_<[canvas_y]>

            - define canvas_data <[canvas_data].proc[morepaintu_canvas_data_set_pixel].context[<[canvas_x]>|<[canvas_y]>|255,0,12]>

            - adjust <[canvas]> text:<[canvas_data].proc[morepaintu_canvas_data_to_display_text]>
            - flag <[canvas]> morepaintu_canvas_data:<[canvas_data]>


#---------------------
MorePaintU_drawing_managment_events:
    type: world
    debug: false
    events:
        after player damages MorePaintU_frame_hitbox_entity:
            - ratelimit <player> 1t

            - define canvas_data <context.entity.flag[morepaintu_canvas].flag[morepaintu_canvas_data]>
            - define lore <[canvas_data].proc[MorePaintU_canvas_data_to_lore_text]>
            - drop <item[morepaintu_sketch].with[lore=<[lore]><&nl>].with_flag[morepaintu_canvas_data:<[canvas_data]>]> <context.entity.flag[morepaintu_frame].location.forward[0.1]>

            - run morepaintu_canvas_remove def:<context.entity>


        on player places painting item:MorePaintU_sketch:
            - spawn item_frame <context.hanging.location> save:frame
            - define frame <entry[frame].spawned_entity>
            - run morepaintu_canvas_spawm def:<[frame]>|<context.item>
        after player places painting item:MorePaintU_sketch:
            - remove <context.hanging>



#-------------------
MorePaintU_canvas_spawm:
    type: task
    definitions: frame|item
    debug: false
    script:

        - adjust <[frame]> framed:filled_map

        - spawn morepaintu_frame_hitbox_entity <[frame].location.below[0.5].backward[0.45]> save:hitbox
        - spawn morepaintu_canvas_entity <[frame].location> save:canvas

        - define hitbox <entry[hitbox].spawned_entity>
        - define canvas <entry[canvas].spawned_entity>

        - flag <[canvas]> morepaintu_canvas_data:<[item].flag[morepaintu_canvas_data]>
        - adjust <[canvas]> text:<[item].flag[morepaintu_canvas_data].proc[morepaintu_canvas_data_to_display_text]>

        - flag <[frame]> morepaintu_canvas:<[canvas]>
        - flag <[hitbox]> morepaintu_canvas:<[canvas]>
        - flag <[hitbox]> morepaintu_frame:<[frame]>


MorePaintU_canvas_remove:
    type: task
    definitions: hitbox
    debug: false
    script:
        - remove <[hitbox].flag[morepaintu_canvas]>
        - remove <[hitbox].flag[morepaintu_frame]>
        - remove <[hitbox]>

#-------------------
MorePaintU_canvas_data_to_display_text:
    type: procedure
    definitions: canvas_data
    debug: false
    script:
        - define text <empty>
        - foreach <[canvas_data]> as:row:
            - define text <[text]><[row].separated_by[y]>
        - determine <[text].font[morepaintu:font]>


MorePaintU_canvas_data_to_lore_text:
    type: procedure
    debug: false
    definitions: canvas_data
    data:
        32: k
        16: l
        8: m
    script:
        - define scaling 2
        - define text <white><empty>
        - define end <script.data_key[data.<[canvas_data].size.div[<[scaling]>]>]>

        - define row_number 0
        - define current_end <script.data_key[data.<[canvas_data].size.div[<[scaling]>]>]>

        - foreach <[canvas_data].proc[morepaintu_get_every_n_from_list].context[<[scaling]>]> as:row:
            - define text <[text]><element[<[row].proc[morepaintu_get_every_n_from_list].context[<[scaling]>].separated_by[y].replace_text[x].with[<[row_number]>].font[morepaintu:font]><[current_end]>].font[morepaintu:font]>

            - define row_number:+:1

            - if <[row_number]> == 9:
                - define current_end <&nl>
            - else if <[row_number]> == 10:
                - define row_number 0
                - define current_end <[end]>
            - else:
                - define current_end <[end]>

        - determine <[text]>


MorePaintU_get_every_n_from_list:
    type: procedure
    debug: false
    definitions: list|n
    script:
        - define result <list[]>
        - repeat <[list].size.div[<[n]>].round> from:0 as:i:
            - define result:->:<[list].get[<[i].mul[<[n]>].add[1]>]>
        - determine <[result]>


MorePaintU_canvas_data_set_pixel:
    type: procedure
    debug: false
    definitions: canvas_data|x|y|color
    script:
        - define canvas_data[<[y]>]:<[canvas_data].get[<[y]>].set_single[<&color[<[color]>]>x<white>].at[<[x]>]>
        - determine <[canvas_data]>


MorePaintU_canvas_data_generate:
    type: procedure
    debug: false
    definitions: x|y
    script:
        - determine <element[x].repeat_as_list[<[x]>].repeat_as_list[<[y]>]>


MorePaintU_canvas_display_line_width:
    type: procedure
    debug: false
    definitions: x
    script:
        - determine <[x].mul[10].add[1]>

#-------------------

            #- narrate <[canvas_data]>

            #- define text <[canvas].text>
            #- define canvas_x <[map_trace].get[x].div[16].round_down.add[1]>
            #- define canvas_y <[map_trace].get[y].div[16].round_down.add[1]>
            ##- narrate <[canvas_y]>_<[canvas_x]>
#
            #- define strpos <[canvas_y].sub[1].mul[15].add[<[canvas_x].sub[1].mul[2].add[1]>]>
            #- narrate <[strpos]>
            #- define before <[text].substring[0,<[strpos].sub[1]>]><element[N].color[red]>
            #- define after <[text].substring[<[strpos].add[1]>]>

            #- narrate <[before]>
            #- narrate <[after]>
            #- adjust <[canvas]> text:<[before]><[after]>
            #- narrate <[canvas].text.char_at[200]>







            #- define x <[map_trace].get[x].div[8].round_down.mul[8].add[1]>
            #- define y <[map_trace].get[y].div[8].round_down.mul[8].add[1]>
            #- repeat 4 from:0 as:x_pos:
            #    - repeat 4 from:0 as:y_pos:
                    #- map <[map]> dot:<color[<util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>]> radius:1 x:<[x_pos].mul[2].add[<[x]>]> y:<[y_pos].mul[2].add[<[y]>]>

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