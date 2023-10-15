EndPortalU_data:
    type: data

    loot_table_id:

        minecraft:chests/igloo_chest:
            item: EndPortalU_ice_eye

        minecraft:chests/bastion_bridge:
            chance: 0.3
            item: EndPortalU_nether_eye
        minecraft:chests/bastion_hoglin_stable:
            chance: 0.3
            item: EndPortalU_nether_eye
        minecraft:chests/bastion_other:
            chance: 0.3
            item: EndPortalU_nether_eye
        minecraft:chests/bastion_treasure:
            chance: 0.6
            item: EndPortalU_nether_eye

        #EndPortalU_water_eye

        minecraft:chests/simple_dungeon:
            chance: 0.4
            item: EndPortalU_old_eye

        #minecraft:chests/desert_pyramid:
        #    chance: 0.4
        #    item: EndPortalU_desert_eye
        minecraft:archaeology/desert_pyramid:
            chance: 0.5
            item: EndPortalU_desert_eye
            replace:
                - gunpowder
                - tnt
                - emerald
        minecraft:archaeology/desert_well:
            chance: 0.5
            item: EndPortalU_desert_eye
            replace:
                - brick
                - emerald
                - stick


        minecraft:chests/woodland_mansion:
            chance: 0.4
            max: 2
            item: EndPortalU_illusion_eye

        minecraft:chests/ancient_city:
            chance: 0.1
            item: EndPortalU_ancient_eye
        minecraft:chests/ancient_city_ice_box:
            chance: 1
            item: EndPortalU_ancient_eye


    portal_requirements:
        - EndPortalU_ice_eye
        - EndPortalU_nether_eye
        - EndPortalU_water_eye
        - EndPortalU_old_eye
        - EndPortalU_desert_eye
        - EndPortalU_illusion_eye
        - EndPortalU_ancient_eye

#----------------------
EndPortalU_display_eye_entity:
    type: entity
    debug: false
    entity_type: item_display
    mechanisms:
        pivot: center
        item: ender_eye
        scale: 0,0,0

EndPortalU_display_chest_entity:
    type: entity
    debug: false
    entity_type: block_display
    mechanisms:
        material: barrel[direction=UP]
        scale: 0,0,0
#----------------------
EndPortalU_ice_eye:
    type: item
    debug: false
    material: ender_eye
    display name: <yellow><&translate[item.endportalu.ice_eye]>
    mechanisms:
        custom_model_data: 11000

EndPortalU_nether_eye:
    type: item
    debug: false
    material: ender_eye
    display name: <yellow><&translate[item.endportalu.nether_eye]>
    mechanisms:
        custom_model_data: 11001

EndPortalU_water_eye:
    type: item
    debug: false
    material: ender_eye
    display name: <yellow><&translate[item.endportalu.water_eye]>
    mechanisms:
        custom_model_data: 11002

EndPortalU_old_eye:
    type: item
    debug: false
    material: ender_eye
    display name: <yellow><&font[uniform]><&translate[item.endportalu.old_eye]>
    mechanisms:
        custom_model_data: 11003

EndPortalU_desert_eye:
    type: item
    debug: false
    material: ender_eye
    display name: <yellow><&translate[item.endportalu.desert_eye]>
    mechanisms:
        custom_model_data: 11004

EndPortalU_illusion_eye:
    type: item
    debug: false
    material: ender_eye
    display name: <yellow><&translate[item.endportalu.illusion_eye]>
    mechanisms:
        custom_model_data: 11005

EndPortalU_ancient_eye:
    type: item
    debug: false
    material: ender_eye
    display name: <yellow><&translate[item.endportalu.ancient_eye]>
    mechanisms:
        custom_model_data: 11006
#----------------------
EndPortalU_direction_to_yaw:
    type: procedure
    debug: false
    definitions: direction
    script:
        - choose <[direction]>:
            - case SOUTH:
                - determine 0
            - case WEST:
                - determine 90
            - case NORTH:
                - determine 180
            - default:
                - determine -90

EndPortalU_get_frame_pos:
    type: procedure
    debug: false
    definitions: location
    script:
        - if <[location].left.material.name> == end_portal_frame:
            - if <[location].right.material.name> == end_portal_frame:
                - determine center
            - determine right
        - determine left

EndPortalU_get_missing_eyes:
    type: procedure
    debug: false
    definitions: location
    script:
        - define all_eyes <static[<script[endportalu_data].data_key[portal_requirements]>]>
        - if !<[location].has_inventory>:
            - determine <[all_eyes]>
        - define result <list[]>
        - define contents <[location].inventory>
        - foreach <[all_eyes]> as:item_name:
            - if !<[contents].contains[<[item_name]>]>:
                - define result:->:<[item_name]>
        - determine <[result]>

#----------------------
EndPortalU_loot_spawn_events:
    type: world
    debug: false
    events:
        on loot generates:
            #- announce <context.loot_table_id>
            - define data <script[EndPortalU_data].data_key[loot_table_id]>

            - if !<[data].contains[<context.loot_table_id>]>:
                - stop

            - define item_data <[data].get[<context.loot_table_id>]>
            - if <util.random_chance[<[item_data].get[chance].if_null[1].mul[100]>]>:
                - define quantity <util.random.int[<[item_data].get[min].if_null[1]>].to[<[item_data].get[max].if_null[1]>]>
                - determine LOOT:<context.items.include[<item[<[item_data].get[item]>].with[quantity=<[quantity]>]>]>

        on player right clicks suspicious_* with:brush using:either_hand:
            - if !<context.location.has_loot_table>:
                - stop
            - if <script[EndPortalU_data].data_key[loot_table_id]> !contains <context.location.loot_table_id>:
                - stop
                    #- flag <context.location> EndPortalU_loot_table_id:<context.location.loot_table_id> expire:1t

            - define item_data <script[EndPortalU_data].data_key[loot_table_id].get[<context.location.loot_table_id>]>
            - if !<util.random_chance[<[item_data].get[chance].if_null[1].mul[100]>]>:
                - stop

            - wait 6t

            - if <context.location.has_loot_table>:
                - stop
            - if <[item_data].get[replace].if_null[<list[]>].parse[as[item]]> !contains <context.location.buried_item>:
                - stop
            - adjust <context.location> buried_item:<item[<[item_data].get[item]>]>

EndPortalU_loot_drop_events:
    type: world
    debug: false
    events:
        on elder_guardian dies:
            - if <util.random_chance[70]>:
                - determine <context.drops.include[<item[EndPortalU_water_eye]>]>


EndPortalU_portal_events:
    type: world
    debug: false
    events:
        on player right clicks end_portal_frame using:either_hand:
            - if <context.location.material.switched>:
                - stop
            - if <context.item.material.name> != ender_eye:
                - stop
            - if <context.item> matches <static[<script[EndPortalU_data].data_key[portal_requirements]>]>:
                - determine cancelled


            - define direction <context.location.material.direction>
            - define loc <context.location.with_yaw[<[direction].proc[endportalu_direction_to_yaw]>]>
            - define frame_type <[loc].proc[EndPortalU_get_frame_pos]>
            - define chest_loc <[loc].forward[2].above[1]>
            - if <[frame_type]> == left:
                - define chest_loc <[chest_loc].right>
            - else if <[frame_type]> == right:
                - define chest_loc <[chest_loc].left>

            - define missing_eyes <[chest_loc].proc[endportalu_get_missing_eyes]>
            - if <[missing_eyes].size> == 0:
                - stop

            - determine cancelled passively

            #- playeffect effect:DRAGON_BREATH at:<[loc].center.above[0.3]> quantity:10 offset:0.5,0,0.5 velocity:0,0.01,0
            - playeffect effect:ENDER_SIGNAL at:<[loc].center.above[0.65]>

            #- define start_loc <[chest_loc].center.above[0.9]>
            #- define dest_Loc <[loc].center.above[0.3]>
            ##- define velocity <[start_loc].face[<[dest_Loc]>].direction.vector.mul[-0.1]>
            #- playeffect effect:DRAGON_BREATH at:<[start_loc].points_between[<[dest_Loc]>].distance[0.2]> quantity:2 offset:0.05

            - if <[missing_eyes].size> == 1:
                - define eye_locs <list[<[chest_loc].center.above>]>
            - else:
                - define eye_locs <[chest_loc].center.above[1.5].points_around_y[radius=0.7;points=<[missing_eyes].size>]>
            - define modify_entities <list[]>


            #- define start_loc <[loc].forward[3].center.above[0.3]>
            - foreach <[eye_locs]> as:new_eye_loc:
                - fakespawn EndPortalU_display_eye_entity[item=<item[<[missing_eyes].get[<[loop_index]>]>]>] <[new_eye_loc]> players:<server.online_players> save:eye d:5s
                - define eye_entities:->:<entry[eye].faked_entity>
                #- playeffect effect:DRAGON_BREATH at:<[start_loc].points_between[<[new_eye_loc]>].distance[0.3]> quantity:1 offset:0

            - define all_entities <[eye_entities]>

            - if !<[chest_loc].has_inventory>:
                - fakespawn EndPortalU_display_chest_entity <[chest_loc]> players:<server.online_players> save:chest d:5s
                - define all_entities:->:<entry[chest].faked_entity>



            - wait 2t
            - adjust <[all_entities]> scale:1,1,1
            - adjust <[eye_entities]> scale:0.5,0.5,0.5
            - adjust <[all_entities]> interpolation_duration:5t
            - adjust <[all_entities]> interpolation_start:0

            - wait <duration[5s].sub[7t]>

            - adjust <[all_entities]> scale:0,0,0
            - adjust <[all_entities]> interpolation_duration:5t
            - adjust <[all_entities]> interpolation_start:0
