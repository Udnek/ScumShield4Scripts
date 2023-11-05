CraftTweaksU_chainmail_helmet:
    type: item
    material: chainmail_helmet
    no_id: true
    recipes:
        1:
            type: shaped
            category: equipment
            input:
            - material:chain|material:chain|material:chain
            - material:chain|air|material:chain

CraftTweaksU_chainmail_chestplate:
    type: item
    material: chainmail_chestplate
    no_id: true
    recipes:
        1:
            type: shaped
            category: equipment
            input:
            - material:chain|air|material:chain
            - material:chain|material:chain|material:chain
            - material:chain|material:chain|material:chain

CraftTweaksU_chainmail_leggings:
    type: item
    material: chainmail_leggings
    no_id: true
    recipes:
        1:
            type: shaped
            category: equipment
            input:
            - material:chain|material:chain|material:chain
            - material:chain|air|material:chain
            - material:chain|air|material:chain

CraftTweaksU_chainmail_boots:
    type: item
    material: chainmail_boots
    no_id: true
    recipes:
        1:
            type: shaped
            category: equipment
            input:
            - material:chain|air|material:chain
            - material:chain|air|material:chain



#-----------------------------------
CraftTweaksU_oak_trapdoor:
    type: item
    material: oak_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:oak_planks|material:oak_planks|material:oak_planks
            - material:oak_planks|material:oak_planks|material:oak_planks

CraftTweaksU_spruce_trapdoor:
    type: item
    material: spruce_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:spruce_planks|material:spruce_planks|material:spruce_planks
            - material:spruce_planks|material:spruce_planks|material:spruce_planks

CraftTweaksU_birch_trapdoor:
    type: item
    material: birch_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:birch_planks|material:birch_planks|material:birch_planks
            - material:birch_planks|material:birch_planks|material:birch_planks

CraftTweaksU_jungle_trapdoor:
    type: item
    material: jungle_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:jungle_planks|material:jungle_planks|material:jungle_planks
            - material:jungle_planks|material:jungle_planks|material:jungle_planks

CraftTweaksU_acacia_trapdoor:
    type: item
    material: acacia_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:acacia_planks|material:acacia_planks|material:acacia_planks
            - material:acacia_planks|material:acacia_planks|material:acacia_planks

CraftTweaksU_dark_oak_trapdoor:
    type: item
    material: dark_oak_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:dark_oak_planks|material:dark_oak_planks|material:dark_oak_planks
            - material:dark_oak_planks|material:dark_oak_planks|material:dark_oak_planks

CraftTweaksU_mangrove_trapdoor:
    type: item
    material: mangrove_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:mangrove_planks|material:mangrove_planks|material:mangrove_planks
            - material:mangrove_planks|material:mangrove_planks|material:mangrove_planks

CraftTweaksU_cherry_trapdoor:
    type: item
    material: cherry_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:cherry_planks|material:cherry_planks|material:cherry_planks
            - material:cherry_planks|material:cherry_planks|material:cherry_planks

CraftTweaksU_bamboo_trapdoor:
    type: item
    material: bamboo_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:bamboo_planks|material:bamboo_planks|material:bamboo_planks
            - material:bamboo_planks|material:bamboo_planks|material:bamboo_planks

CraftTweaksU_crimson_trapdoor:
    type: item
    material: crimson_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:crimson_planks|material:crimson_planks|material:crimson_planks
            - material:crimson_planks|material:crimson_planks|material:crimson_planks

CraftTweaksU_warped_trapdoor:
    type: item
    material: warped_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: building
            output_quantity: 6
            input:
            - material:warped_planks|material:warped_planks|material:warped_planks
            - material:warped_planks|material:warped_planks|material:warped_planks

CraftTweaksU_iron_trapdoor:
    type: item
    material: iron_trapdoor
    no_id: true
    recipes:
        1:
            type: shaped
            category: redstone
            output_quantity: 2
            input:
            - material:iron_ingot|material:iron_ingot
            - material:iron_ingot|material:iron_ingot

#------------------------------
CraftTweaksU_remove_recipes_data:
    type: data
    ids:
        - minecraft:oak_trapdoor
        - minecraft:spruce_trapdoor
        - minecraft:birch_trapdoor
        - minecraft:jungle_trapdoor
        - minecraft:acacia_trapdoor
        - minecraft:dark_oak_trapdoor
        - minecraft:mangrove_trapdoor
        - minecraft:cherry_trapdoor
        - minecraft:bamboo_trapdoor
        - minecraft:crimson_trapdoor
        - minecraft:warped_trapdoor
        - minecraft:iron_trapdoor

CraftTweaksU_events:
    type: world
    debug: false
    events:
        after server resources reloaded:
            - adjust server remove_recipes:<script[CraftTweaksU_remove_recipes_data].data_key[ids]>
        after server start:
            - adjust server remove_recipes:<script[CraftTweaksU_remove_recipes_data].data_key[ids]>