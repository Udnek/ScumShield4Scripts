MeteoritesU_meteorite_model:
    type: item
    material: paper
    mechanisms:
        custom_model_data: 1

MeteoritesU_meteorite_entity:
    type: entity
    entity_type: armor_stand
    mechanisms:
        invulnerable: true
        marker: true
        equipment: <map[helmet=MeteoritesU_meteorite_model]>


MeteoritesU_spawn_meteorite:
    type: task
    definitions: location|power|size|type
    debug: false
    script:
        - define x_speed:0
        - define y_speed:1
        - define z_speed:0
        - define height:100

        - define landing_predicting_loc:<[location].highest.center>

        - define x_y_diff:<[x_speed].div[<[y_speed]>]>
        - define z_y_diff:<[z_speed].div[<[y_speed]>]>
        - define spawn_loc:<[landing_predicting_loc].add[-<[x_y_diff].mul[<[height]>]>,<[height]>,-<[z_y_diff].mul[<[height]>]>]>

        - debugblock <[landing_predicting_loc]> d:10s
        - spawn MeteoritesU_meteorite_entity <[spawn_loc].center> save:meteorite
        - define meteorite:<entry[meteorite].spawned_entity>

        - while !<[meteorite].location.below.block.material.is_solid>:
            - teleport <[meteorite]> <[meteorite].location.add[<[x_speed]>,-<[y_speed]>,<[z_speed]>]>
            - define destroy_area:<[meteorite].location.above[<[power]>]>
            - explode power:<[power]> <[destroy_area]> breakblocks
            - playeffect effect:EXPLODE <[meteorite].location> visibility:100 quantity:2 data:0 offset:1.0 velocity:0,1,0
            - playeffect effect:campfire_cosy_smoke <[meteorite].location> visibility:100 quantity:2 data:0 offset:1.0,2,1.0 velocity:0,0.1,0
            - playeffect effect:lava <[meteorite].location> visibility:100 quantity:2 data:0 offset:<[power].mul[2]> velocity:0,1,0
            - wait 1t

        - define landing_loc:<[meteorite].location.below.center>
        - remove <[meteorite]>

        #- debugblock <[landing_loc]> d:5s
        #- explode power:<[power]> <[landing_loc]> breakblocks fire
        #- explode power:<[power].mul[2.5]> <[landing_loc].above[<[power].mul[1.5]>]> fire
        #- debugblock <[landing_loc].above[<[power].mul[2]>]> d:5s
        - define block_list:<list[cobbled_deepslate|smooth_basalt|cobbled_deepslate|smooth_basalt|cobbled_deepslate|smooth_basalt|magma_block|lava|air|air|air]>
        #- define block_list:<list[sculk|sculk|sculk|sculk_vein|sculk_sensor|sculk_shrieker|air]>
        #- define block_list:<list[amethyst_block|amethyst_block|budding_amethyst|calcite|calcite|smooth_basalt|smooth_basalt|lava|air]>
        #- define block_list:<list[sculk|sculk|sculk|sculk_vein|sculk_sensor|sculk_shrieker|air]>
        - define surface_loc:<[landing_loc].to_ellipsoid[<[size]>,<[size]>,<[size]>]>
        - foreach <[surface_loc].blocks> as:block_loc:
            - if <util.random_chance[50]>:
                - if ( <[block_loc].material.block_resistance> < 1200 ) && ( <[block_loc].material.name> != air ):
                    #- spawn falling_block[fallingblock_type=<[block_loc].material>] <[landing_loc].above> save:falling_block
                    #- push <entry[falling_block].spawned_entity> origin:<[landing_loc]> destination:<[block_loc].above[4]>
                    - push falling_block[fallingblock_type=<[block_loc].material>] origin:<[landing_loc].above[2]> destination:<[block_loc].above[4]> speed:0.7
                    - modifyblock <[block_loc]> air naturally

        - explode power:<[power]> <[landing_loc]> breakblocks fire
        - explode power:<[power].mul[2.5]> <[landing_loc].above[<[power].mul[1.5]>]> fire

        - foreach <[surface_loc].blocks> as:block_loc:
            - define block_material:<[block_list].random>
            - if <[block_material]> != air:
                - spawn falling_block[fallingblock_type=<[block_material]>] <[block_loc].above>

        #- spawn warden <[landing_loc].above>
        - playeffect effect:EXPLODE <[landing_loc]> visibility:100 quantity:400 data:0 offset:<[power].mul[3]> velocity:0,0.3,0
        - playeffect effect:lava <[landing_loc]> visibility:100 quantity:500 data:0 offset:<[power].mul[3]> velocity:0,1,0



MeteoritesU_spawn_meteorite_command:
    type: command
    name: meterite_spawn
    description: meterite_spawn
    usage: /meterite_spawn
    permission: MeteoritesU.admin
    script:
        - run meteoritesu_spawn_meteorite def:<player.cursor_on.if_null[<player.location>]>|4|3|normal