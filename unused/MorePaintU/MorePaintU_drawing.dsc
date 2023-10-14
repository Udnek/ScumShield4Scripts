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

#------------------------
MorePaintU_brush:
    type: item
    material: firework_star
    display name: Brush

MorePaintU_sketch:
    type: item
    debug: false
    material: painting
    display name: sketch
    allow in material recipes: true
    mechanisms:
        raw_nbt: <map[EntityTag=<map[variant=string:minecraft:kebab]>]>
        hides: ALL
    flags:
        morepaintu_canvas_data: <proc[morepaintu_canvas_data_generate].context[32|32]>
    lore:
        - <proc[morepaintu_canvas_data_generate].context[32|32].proc[MorePaintU_painting_generate_lore]>

MorePaintU_merged_sketch:
    type: item
    debug: false
    material: paper
    display name: merged_sletch
    recipes:
       1:
            type: shaped
            recipe_id: morepaintu_merged_sketch_1x2
            input:
            - material:painting
            - material:painting
       2:
            type: shaped
            recipe_id: morepaintu_merged_sketch_2x1
            input:
            - material:painting|material:painting
       3:
            type: shaped
            recipe_id: morepaintu_merged_sketch_2x2
            input:
            - material:painting|material:painting
            - material:painting|material:painting
       4:
            type: shaped
            recipe_id: morepaintu_merged_sketch_3x1
            input:
            - material:painting|material:painting|material:painting
       5:
            type: shaped
            recipe_id: morepaintu_merged_sketch_1x3
            input:
            - material:painting
            - material:painting
            - material:painting

MorePaintU_finished_painting:
    type: item
    material: painting
    display name: painting
    mechanisms:
        raw_nbt: <map[EntityTag=<map[variant=string:minecraft:kebab]>]>

#------------------------
MorePaintU_crafting_events:
    type: world
    debug: false
    events:
        on MorePaintU_merged_sketch recipe formed:
            - narrate ok
            - if <context.recipe> contains painting:
                - determine cancelled

            - define canvases <map[]>
            - define sketches <context.recipe.exclude[<item[air]>]>
            - foreach <[sketches]> as:sketch:
                - define canvases.<[loop_index]> <[sketch].flag[morepaintu_canvas_data]>
            - choose <context.recipe_id>:
                - case denizen:morepaintu_merged_sketch_1x2:
                    - define mode 1x2
                - case denizen:morepaintu_merged_sketch_1x3:
                    - define mode 1x3
                - case denizen:morepaintu_merged_sketch_2x1:
                    - define mode 2x1
                - case denizen:morepaintu_merged_sketch_3x1:
                    - define mode 3x1
                - case denizen:morepaintu_merged_sketch_2x2:
                    - define mode 2x2

            - define canvas <[mode].proc[MorePaintU_canvas_datas_merge].context[<[canvases]>]>
            - determine <context.item.with[lore=<[canvas].proc[morepaintu_painting_generate_lore]>].with_flag[morepaintu_canvas_data:<[canvas]>]>


MorePaintU_canvas_datas_merge:
    type: procedure
    debug: false
    definitions: mode|canvases
    script:
        - choose <[mode]>:
            - case 1x2:
                - determine <[canvases].get[1].include[<[canvases].get[2]>]>
            - case 1x3:
                - determine <[canvases].get[1].include[<[canvases].get[2]>].include[<[canvases].get[3]>]>
            - case 2x1:
                - define origin <[canvases].get[1]>
                - define adding <[canvases].get[2]>
                - foreach <[origin]> as:origin_row:
                    - define origin[<[loop_index]>]:<[origin_row].include[<[adding].get[<[loop_index]>]>]>
                - determine <[origin]>
            - case 3x1:
                - define origin <[canvases].get[1]>
                - define adding <[canvases].get[2]>
                - define adding2 <[canvases].get[3]>
                - foreach <[origin]> as:origin_row:
                    - define origin[<[loop_index]>]:<[origin_row].include[<[adding].get[<[loop_index]>]>].include[<[adding2].get[<[loop_index]>]>]>
                - determine <[origin]>
            - case 2x2:
                - definemap up_canvases:
                    1: <[canvases].get[1]>
                    2: <[canvases].get[2]>
                - definemap down_canvases:
                    1: <[canvases].get[3]>
                    2: <[canvases].get[4]>
                - define up <element[2x1].proc[MorePaintU_canvas_datas_merge].context[<[up_canvases]>]>
                - define down <element[2x1].proc[MorePaintU_canvas_datas_merge].context[<[down_canvases]>]>
                - definemap canvases:
                    1: <[up]>
                    2: <[down]>
                - define final <element[1x2].proc[MorePaintU_canvas_datas_merge].context[<[canvases]>]>
                - determine <[final]>

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
            - if <[canvas_x].add[1]> <= 32:
                - define canvas_data <[canvas_data].proc[morepaintu_canvas_data_set_pixel].context[<[canvas_x].add[1]>|<[canvas_y]>|255,0,12]>

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
            - define lore <[canvas_data].proc[MorePaintU_painting_generate_lore]>
            - drop <item[morepaintu_sketch].with[lore=<[lore]>].with_flag[morepaintu_canvas_data:<[canvas_data]>]> <context.entity.flag[morepaintu_frame].location.forward[0.1]>

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
    debug: false
    definitions: frame|item
    script:

        - adjust <[frame]> framed:filled_map[custom_model_data=1000]

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
    debug: false
    definitions: hitbox
    script:
        - remove <[hitbox].flag[morepaintu_canvas]>
        - remove <[hitbox].flag[morepaintu_frame]>
        - remove <[hitbox]>

#-------------------
MorePaintU_canvas_data_to_display_text:
    type: procedure
    debug: false
    definitions: canvas_data
    script:
        - define text <empty>
        - foreach <[canvas_data]> as:row:
            - define text <[text]><[row].parse_tag[<&color[#<[parse_value]>]>x].separated_by[y]>
        - determine <[text].font[morepaintu:font]>


MorePaintU_painting_generate_lore:
    type: procedure
    debug: false
    definitions: canvas_data
    script:
        - determine KEK<&nl><[canvas_data].proc[MorePaintU_canvas_data_to_lore_text]><&nl>


MorePaintU_canvas_data_to_lore_text:
    type: procedure
    debug: false
    definitions: canvas_data
    data:
        48: i
        32: j
        24: n
        16: k
        8: l
        4: m
        2: n
        1: o
    script:
        - define scaling 4
        - define text <empty>
        - define end <script.data_key[data.<[canvas_data].get[1].size.div[<[scaling]>]>]>

        - define row_number 0
        - define current_end <script.data_key[data.<[canvas_data].get[1].size.div[<[scaling]>]>]>

        - foreach <[canvas_data].proc[morepaintu_get_every_n_from_list].context[<[scaling]>]> as:row:
            - define text <[text]><element[<[row].proc[morepaintu_get_every_n_from_list].context[<[scaling]>].parse_tag[<&color[#<[parse_value]>]><[row_number]>].separated_by[y].font[morepaintu:font]><[current_end]>].font[morepaintu:font]>
            - define row_number:+:1

            - if <[row_number]> == 4:
                - define current_end <&nl>
            - else if <[row_number]> == 5:
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

#-----------------------------------
MorePaintU_canvas_data_set_pixel:
    type: procedure
    debug: false
    definitions: canvas_data|x|y|color
    script:
        - define canvas_data[<[y]>]:<[canvas_data].get[<[y]>].set_single[<color[<[color]>].hex.substring[2]>].at[<[x]>]>
        - determine <[canvas_data]>


MorePaintU_canvas_data_generate:
    type: procedure
    debug: false
    definitions: x|y
    script:
        #- define color 235,235,200
        - define color <util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>
        #- define color 0,0,0
        #- define color 255,255,255
        #- determine <element[<[color]>].repeat_as_list[<[x]>].repeat_as_list[<[y]>]>
        - define color <color[<[color]>].hex.substring[2]>
        - determine <element[<[color]>].repeat_as_list[<[x]>].repeat_as_list[<[y]>]>
        #- determine <element[<element[<[color]>].repeat[<[x]>]>].repeat[<[y]>]>


#TODO UNUSED
MorePaintU_canvas_data_decode:
    type: procedure
    debug: false
    definitions: canvas_data|x|y
    script:
        - define result <list[]>
        - repeat <[y]> from:0 as:i:
            - define row <[canvas_data].substring[<[i].mul[<[x]>].add[1]>,<[i].mul[<[x]>].add[<[x].mul[6]>]>]>
            - define elements <list[]>
            - repeat <[x]> from:0 as:j:
                - define element <[row].substring[<[j].mul[6].add[1]>,<[j].mul[6].add[6]>]>
                - define elements:->:<[element]>
            - define result:->:<[elements]>
        - determine <[result]>

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