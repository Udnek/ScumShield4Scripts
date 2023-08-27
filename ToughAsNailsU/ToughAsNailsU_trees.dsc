ToughAsNailsU_trees_actions:
    type: world
    debug: false
    events:
        on player right clicks *_sapling with:ToughAsNailsU_special_bone_meal:
            - flag <context.location> ToughAsNailsU_sapling:<context.location.material.name> expire:1t

        on structure grows from bonemeal:

            - define bone_meal <player.item_in_hand>
            - if <[bone_meal].material.name> != bone_meal:
                - define bone_meal <player.item_in_offhand>

            - if <[bone_meal].proc[utilsu_item_actual_name]> == ToughAsNailsU_special_bone_meal:
                - determine cancelled passively

                - define sapling_from_leaf <proc[ToughAsNailsU_from_leaf_to_sapling].context[<[bone_meal].flag[toughasnailsu_leaf]>]>
                - define biome <player.item_in_hand.flag[toughasnailsu_biome]>
                - define origin_sapling <context.location.material.name>
                - if <[origin_sapling]> == air:
                    - define origin_sapling <context.location.flag[ToughAsNailsU_sapling].if_null[air]>

                #- narrate <[origin_sapling]>
                #- narrate <[sapling_from_leaf]>

                - if <[origin_sapling]> not matches <[sapling_from_leaf]>:
                    - define leaves <proc[ToughAsNailsU_from_sapling_to_leaves].context[<[sapling_from_leaf].first>]>
                    - define materials <list[]>

                    #- narrate "sfl: <[sapling_from_leaf].first>"
                    #- narrate "leaves: <[leaves]>"

                    - foreach <context.new_materials> as:mat:
                        - if <[mat].name.advanced_matches[*leaves]>:
                            - define materials:->:<material[<[leaves].random>]>
                            - foreach next
                        - define materials:->:<[mat]>

                    - modifyblock <context.blocks> <[materials]>

                    - run toughasnailsu_advancement_custom_tree
                    - stop

                #- narrate biome_tree

                - define data <script[toughasnailsu_trees_data].data_key[biomes]>
                - if !<[data].contains[<[biome]>]>:
                    - stop

                - define name <[data].get[<[biome]>].random>
                #- define sapling <context.location.material>
                #- narrate <[name]>

                - modifyblock <context.location> air

                - define command "place feature <[name]> <context.location.x> <context.location.y> <context.location.z>"
                - execute as_op player:<context.location.world.players.get[1]> <[command]> silent
                - if <context.location.material.name> == air:
                    - modifyblock <[origin_sapling]> <context.location>

                - run toughasnailsu_advancement_custom_tree


ToughAsNailsU_from_leaf_to_sapling:
    type: procedure
    debug: false
    definitions: leaf_script_name
    script:
        - determine <list[<script[ToughAsNailsU_leaf_to_sapling_data].data_key[leaf.<[leaf_script_name]>]>]>

ToughAsNailsU_from_sapling_to_leaves:
    type: procedure
    debug: false
    definitions: sapling_name
    script:
        - determine <list[<script[ToughAsNailsU_sapling_to_leaves_data].data_key[sapling.<[sapling_name]>]>]>


ToughAsNailsU_bone_meal_command:
    type: command
    debug: false
    name: tbm
    description: tbm
    usage: /tbm
    tab completions:
        1: <player.world.biomes.parse_tag[<[parse_value].name>]>
    script:
        - define item <item[toughasnailsu_special_bone_meal]>
        - give <[item].with[flag=toughasnailsu_biome:<context.args.first>]>


ToughAsNailsU_leaf_to_sapling_data:
    type: data
    leaf:
        ToughAsNailsU_acacia_leaf: acacia_sapling
        ToughAsNailsU_azalea_leaf:
            - azalea
            - flowering_azalea
        ToughAsNailsU_birch_leaf: birch_sapling
        ToughAsNailsU_cherry_leaf: cherry_sapling
        ToughAsNailsU_dark_oak_leaf: dark_oak_sapling
        ToughAsNailsU_jungle_leaf: jungle_sapling
        ToughAsNailsU_mangrove_leaf: mangrove_propagule
        ToughAsNailsU_oak_leaf: oak_sapling
        ToughAsNailsU_spruce_leaf: spruce_sapling

ToughAsNailsU_sapling_to_leaves_data:
    type: data
    sapling:
        acacia_sapling: acacia_leaves
        azalea:
            - azalea_leaves
            - flowering_azalea_leaves
        flowering_azalea:
            - azalea_leaves
            - flowering_azalea_leaves
        birch_sapling: birch_leaves
        cherry_sapling: cherry_leaves
        dark_oak_sapling: dark_oak_leaves
        jungle_sapling: jungle_leaves
        mangrove_propagule: mangrove_leaves
        oak_sapling: oak_leaves
        spruce_sapling: spruce_leaves

#----------------------
ToughAsNailsU_trees_data:
    type: data

    biomes:

        terralith:alpha_islands:
            - terralith:alpha/trees

        terralith:alpha_islands_winter:
            - terralith:alpha/trees

        terralith:alpine_grove:
            - terralith:grove/alpine/trees_tiny

        terralith:amethyst_canyon:
            - terralith:jungle/violet/trees

        terralith:amethyst_rainforest:
            - terralith:jungle/violet/trees

        terralith:ashen_savanna:
            - terralith:shrubland/hot/small_trees
            - terralith:shrubland/hot/tiny_trees
            - terralith:shrubland/hot/cone_trees
            - terralith:savanna/baobabs

        terralith:birch_taiga:
            - terralith:taiga/birch/pond
            - terralith:taiga/birch/boulders
            - terralith:taiga/birch/trees_small

        terralith:blooming_plateau:
            - minecraft:trees_meadow

        terralith:blooming_valley:
            - terralith:forest/flower/cloud_trees
            - terralith:forest/flower/tiny/trees_tiny
            - terralith:forest/flower/small/trees_small
            - terralith:forest/flower/mid/trees_mid
            - terralith:forest/flower/tall/trees_tall

        terralith:bryce_canyon:
            - minecraft:trees_giant_spruce

        terralith:cloud_forest:
            - terralith:flower/white/trees

        terralith:cold_shrubland:
            - terralith:shrubland/cold/small_trees
            - terralith:shrubland/cold/tiny_trees
            - terralith:shrubland/cold/cone_trees

        terralith:desert_oasis:
            - terralith:canyon/sandstone/scattered_palms
            - terralith:canyon/sandstone/lake_palms

        terralith:desert_spires:
            - terralith:canyon/sandstone/scattered_palms
            - terralith:canyon/sandstone/lake_palms

        terralith:forested_highlands:
            - terralith:highlands/forest/trees_maple
            - terralith:highlands/forest/tall/trees_tall
            - terralith:highlands/forest/mid/trees_mid
            - terralith:highlands/forest/small/trees_small
            - terralith:highlands/forest/tiny/trees_tiny
            - terralith:highlands/trees

        terralith:fractured_savanna:
            - terralith:savanna/shattered/trees_tall
            - terralith:savanna/shattered/med/trees_med
            - terralith:savanna/shattered/small/trees_small
            - terralith:savanna/shattered/tiny/trees_tiny
            - minecraft:trees_savanna

        terralith:frozen_cliffs:
            - minecraft:trees_snowy

        terralith:granite_cliffs:
            - terralith:cliffs/white/trees_small

        terralith:haze_mountain:
            - terralith:mountains/misty/trees_mid
            - terralith:mountains/misty/trees_base
            - terralith:mountains/misty/trees_top
            - terralith:mountains/misty/trees_birch
            - terralith:shrubland/small_trees
            - terralith:shrubland/tiny_trees
            - terralith:shrubland/cone_trees
            - minecraft:trees_mountain

        terralith:highlands:
            - terralith:highlands/trees

        terralith:hot_shrubland:
            - terralith:shrubland/hot/small_trees
            - terralith:shrubland/hot/tiny_trees
            - terralith:shrubland/hot/cone_trees

        terralith:ice_marsh:
            - terralith:swamp/ice/small/trees_small
            - terralith:swamp/ice/tiny/trees_tiny

        terralith:jungle_mountains:
            - minecraft:trees_jungle

        terralith:lavender_forest:
            - terralith:flower/lavender/trees

        terralith:lavender_valley:
            - terralith:flower/lavender/trees

        terralith:lush_valley:
            - terralith:shield/trees
            - terralith:shield/trees_birch
            - terralith:shield/trees_lark

        terralith:mirage_isles:
            - terralith:enchanted/trees

        terralith:moonlight_grove:
            - terralith:flower/blue/trees

        terralith:moonlight_valley:
            - terralith:flower/blue/trees

        terralith:orchid_swamp:
            - terralith:swamp/orchid/small/trees_small

        terralith:red_oasis:
            - terralith:canyon/red_sandstone/scattered_palms
            - terralith:canyon/red_sandstone/lake_palms

        terralith:rocky_jungle:
            - minecraft:trees_jungle

        terralith:rocky_shrubland:
            - terralith:shrubland/cold/small_trees
            - terralith:shrubland/cold/tiny_trees
            - terralith:shrubland/cold/cone_trees

        terralith:sakura_grove:
            - terralith:sakura/birch
            - terralith:sakura/birch_sparse
            - terralith:sakura/cherry_trees
            - terralith:sakura/cherry_trees_light

        terralith:sakura_valley:
            - terralith:sakura/birch
            - terralith:sakura/birch_sparse
            - terralith:sakura/cherry_trees
            - terralith:sakura/cherry_trees_light

        terralith:sandstone_valley:
            - terralith:canyon/sandstone/scattered_palms
            - terralith:canyon/sandstone/lake_palms

        terralith:savanna_badlands:
            - minecraft:trees_savanna

        terralith:savanna_slopes:
            - terralith:savanna/baobabs
            - minecraft:trees_savanna

        terralith:shield:
            - terralith:shield/trees
            - terralith:shield/trees_birch
            - terralith:shield/trees_lark

        terralith:shrubland:
            - terralith:shrubland/small_trees
            - terralith:shrubland/tiny_trees
            - terralith:shrubland/cone_trees

        terralith:siberian_grove:
            - terralith:taiga/siberian/trees_new
            - terralith:taiga/siberian/trees_new_orange

        terralith:siberian_taiga:
            - terralith:taiga/siberian/trees_new
            - terralith:taiga/siberian/trees_new_orange

        terralith:skylands:
            - terralith:skylands/trees

        terralith:skylands_autumn:
            - terralith:skylands/trees

        terralith:skylands_spring:
            - terralith:sakura/birch_sparse
            - terralith:skylands/spring/trees

        terralith:skylands_summer:
            - terralith:skylands/summer/trees

        terralith:skylands_winter:
            - terralith:skylands/winter/trees

        terralith:snowy_cherry_grove:
            - minecraft:trees_cherry

        terralith:snowy_maple_forest:
            - terralith:highlands/forest/trees_maple_cold
            - terralith:highlands/forest/tall/trees_tall
            - terralith:highlands/forest/mid/trees_mid
            - terralith:highlands/forest/small/trees_small
            - terralith:highlands/forest/tiny/trees_tiny
            - terralith:highlands/trees

        terralith:snowy_shield:
            - terralith:shield/trees
            - terralith:shield/trees_birch
            - terralith:shield/trees_lark

        terralith:temperate_highlands:
            - terralith:highlands/temperate/trees_orange
            - terralith:highlands/temperate/dark_oak
            - terralith:highlands/temperate/cloud_trees
            - terralith:highlands/temperate/trees_neg
            - terralith:highlands/temperate/trees_pos
            - terralith:highlands/temperate/pile_oak
            - terralith:highlands/temperate/pile_birch

        terralith:tropical_jungle:
            - terralith:coastal/trees_hawaii

        terralith:warm_river:
            - minecraft:trees_water

        terralith:white_cliffs:
            - terralith:cliffs/white/trees_small

        terralith:windswept_spires:
            - minecraft:trees_mountain

        terralith:wintry_forest:
            - terralith:snowy/trees_center
            - terralith:snowy/trees_giant
            - terralith:snowy/trees_edge
            - terralith:snowy/trees_outer

        terralith:wintry_lowlands:
            - terralith:snowy/trees_center
            - terralith:snowy/trees_giant
            - terralith:snowy/trees_edge
            - terralith:snowy/trees_outer

        terralith:yellowstone:
            - terralith:yellowstone/spruce_trees_big
            - terralith:yellowstone/spruce_trees_big_alt
            - terralith:yellowstone/birch_trees
            - terralith:yellowstone/birch_trees_alt

        terralith:yosemite_lowlands:
            - terralith:yosemite/oaks
