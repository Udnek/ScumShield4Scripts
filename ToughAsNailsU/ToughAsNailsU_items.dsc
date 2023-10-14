ToughAsNailsU_flask_data:
    type: data

    flask_color_codes:
        white_dye: 901
        orange_dye: 902
        magenta_dye: 903
        light_blue_dye: 904
        yellow_dye: 905
        lime_dye: 906
        pink_dye: 907
        gray_dye: 908
        light_gray_dye: 909
        cyan_dye: 910
        purple_dye: 911
        blue_dye: 912
        brown_dye: 913
        green_dye: 914
        red_dye: 915
        black_dye: 916

    flask_color_names:
        white_dye: item.toughasnailsu.flask.white
        orange_dye: item.toughasnailsu.flask.orange
        magenta_dye: item.toughasnailsu.flask.magenta
        light_blue_dye: item.toughasnailsu.flask.light_blue
        yellow_dye: item.toughasnailsu.flask.yellow
        lime_dye: item.toughasnailsu.flask.lime
        pink_dye: item.toughasnailsu.flask.pink
        gray_dye: item.toughasnailsu.flask.gray
        light_gray_dye: item.toughasnailsu.flask.light_gray
        cyan_dye: item.toughasnailsu.flask.cyan
        purple_dye: item.toughasnailsu.flask.purple
        blue_dye: item.toughasnailsu.flask.blue
        brown_dye: item.toughasnailsu.flask.brown
        green_dye: item.toughasnailsu.flask.green
        red_dye: item.toughasnailsu.flask.red
        black_dye: item.toughasnailsu.flask.black


ToughAsNailsU_items_data:
    type: data

    stats:
        ToughAsNailsU_dirty_water_bottle: 3|-10|15s
        ToughAsNailsU_sea_water_bottle: 3|-10|25s
        ToughAsNailsU_pure_water_bottle: 6|-15|20s
        ToughAsNailsU_boiling_water_bottle: 6|+15|20s

        ToughAsNailsU_green_sweet_berry_tea_bottle: 10|+30|100s
        ToughAsNailsU_green_glow_berry_tea_bottle: 10|+30|100s
        ToughAsNailsU_green_sugar_tea_bottle: 10|+30|100s

        ToughAsNailsU_melon_juice_bottle: 10|-20|40s
        ToughAsNailsU_carrot_juice_bottle: 10|-20|40s
        ToughAsNailsU_sweet_berries_juice_bottle: 10|-20|40s
        ToughAsNailsU_amethyst_water_bottle: 10|-35|100s

        ToughAsNailsU_wheat_wort_bottle: 6|+10|20s
        ToughAsNailsU_wheat_beer_bottle: 10|-25|120s

        ToughAsNailsU_raw_milk_cacao_bottle: 8|-15|50s
        ToughAsNailsU_milk_cacao_bottle: 10|+30|100s

    fixed_bottle:
        - ToughAsNailsU_green_sweet_berry_tea_bottle
        - ToughAsNailsU_green_glow_berry_tea_bottle
        - ToughAsNailsU_green_sugar_tea_bottle

        - ToughAsNailsU_amethyst_water_bottle

        - ToughAsNailsU_wheat_wort_bottle

    fixed_leaf:
        - ToughAsNailsU_green_sweet_berry_tea_bottle
        - ToughAsNailsU_green_glow_berry_tea_bottle
        - ToughAsNailsU_green_sugar_tea_bottle

        - ToughAsNailsU_wheat_wort_bottle

    flaskable:
        - ToughAsNailsU_dirty_water_bottle
        - ToughAsNailsU_sea_water_bottle
        - ToughAsNailsU_pure_water_bottle
        - ToughAsNailsU_boiling_water_bottle
        - ToughAsNailsU_green_sweet_berry_tea_bottle
        - ToughAsNailsU_green_glow_berry_tea_bottle
        - ToughAsNailsU_green_sugar_tea_bottle
        - ToughAsNailsU_melon_juice_bottle
        - ToughAsNailsU_carrot_juice_bottle
        - ToughAsNailsU_sweet_berries_juice_bottle
        - ToughAsNailsU_amethyst_water_bottle
        - ToughAsNailsU_wheat_wort_bottle
        - ToughAsNailsU_wheat_beer_bottle

#--------------------------------
ToughAsNailsU_nailer_enchantment:
    debug: false
    type: enchantment
    id: ToughAsNailsU_nailer
    slots:
    - feet
    - legs
    - chest
    - head
    rarity: common
    category: ARMOR
    full_name: <&translate[enchantment.toughasnailsu.nailer]> <&translate[enchantment.level.<context.level>]>
    min_level: 1
    max_level: 4
    min_cost: <context.level.mul[1]>
    max_cost: <context.level.mul[1]>
    treasure_only: true
    is_curse: false
    is_tradable: false
    is_discoverable: false
    can_enchant: <context.item.advanced_matches[*_helmet|*_chestplate|*_leggings|*_boots]>

#---------------------------
ToughAsNailsU_special_bone_meal:
    debug: false
    type: item
    material: bone_meal
    display name: <reset><&translate[item.toughasnailsu.special_bone_meal]>
    mechanisms:
        custom_model_data: 900
    recipes:
        1:
            type: shapeless
            recipe_id: toughasnailsu_special_bone_meal_1
            output_quantity: 3
            category: misc
            input: material:bone_meal|material:bone_meal|material:bone_meal|material:firework_star
#---------------------------
ToughAsNailsU_flask:
    debug: false
    type: item
    material: bundle
    display name: <reset><&translate[item.toughasnailsu.flask]>
    mechanisms:
        custom_model_data: 900
    recipes:
        1:
            type: shaped
            output_quantity: 1
            category: equipment
            input:
            - air|material:leather|material:string
            - material:leather|material:bucket|material:leather
            - air|material:leather|air

    allow in material recipes: true

ToughAsNailsU_flask_colored:
    debug: false
    type: item
    material: bundle
    display name: <reset><&translate[item.toughasnailsu.flask.white]>
    mechanisms:
        custom_model_data: 901
    recipes:
        1:
            type: shapeless
            recipe_id: toughasnailsu_flask_colored_1
            output_quantity: 1
            category: equipment
            input: material:*_dye|material:bundle
#---------------------------
ToughAsNailsU_acacia_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.acacia_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1000
        firework:
            color: <&color[#71A92A]>

ToughAsNailsU_azalea_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.azalea_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1001
        firework:
            color: <&color[#ffffff]>

ToughAsNailsU_birch_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.birch_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1002
        firework:
            color: <&color[#ffffff]>

ToughAsNailsU_cherry_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.cherry_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1003
        firework:
            color: <&color[#ffffff]>

ToughAsNailsU_dark_oak_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.dark_oak_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1004
        firework:
            color: <&color[#71A92A]>

ToughAsNailsU_jungle_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.jungle_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1008
        firework:
            color: <&color[#71A92A]>

ToughAsNailsU_mangrove_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.mangrove_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1005
        firework:
            color: <&color[#71A92A]>

ToughAsNailsU_oak_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.oak_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1006
        firework:
            color: <&color[#71A92A]>

ToughAsNailsU_spruce_leaf:
    debug: false
    type: item
    allow in material recipes: true
    material: firework_star
    display name: <reset><&translate[item.toughasnailsu.spruce_leaf]>
    mechanisms:
        hides: all
        custom_model_data: 1007
        firework:
            color: <&color[#ffffff]>
#-----------------------
ToughAsNailsU_drinking_glass_bottle:
    debug: false
    type: item
    material: feather
    display name: <reset><&translate[item.toughasnailsu.drinking_glass_bottle]>
    recipes:
        1:
            type: shaped
            output_quantity: 4
            input:
            - material:glass|air|material:glass
            - material:glass|air|material:glass
            - air|material:glass|air
    mechanisms:
        custom_model_data: 900

ToughAsNailsU_dirty_water_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1000
    display name: <reset><&translate[item.toughasnailsu.dirty_water_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_dirty_water_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.3]>
    flags:
        ToughAsNailsU_flaskable: true
        ToughAsNailsU_dirty: true

ToughAsNailsU_sea_water_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1003
    display name: <reset><&translate[item.toughasnailsu.sea_water_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_sea_water_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.3]>
    flags:
        ToughAsNailsU_dirty: true

ToughAsNailsU_pure_water_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1001
    recipes:
        1:
            type: smoker
            cook_time: 5s
            category: food
            experience: 0.35
            input: ToughAsNailsU_dirty_water_bottle
        2:
            type: smoker
            cook_time: 5s
            category: food
            experience: 0.35
            input: ToughAsNailsU_sea_water_bottle

    display name: <reset><&translate[item.toughasnailsu.pure_water_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_pure_water_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.6]>

ToughAsNailsU_boiling_water_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1002
    recipes:
        1:
            type: smoker
            output_quantity: 1
            cook_time: 5s
            category: food
            experience: 0.35
            input: ToughAsNailsU_pure_water_bottle

    display name: <reset><&translate[item.toughasnailsu.boiling_water_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_boiling_water_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.6]>

ToughAsNailsU_green_sweet_berry_tea_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1100
    recipes:
        1:
            type: shapeless
            recipe_id: toughasnailsu_green_sweet_berry_tea_bottle_1
            output_quantity: 1
            input: material:firework_star|material:firework_star|material:sweet_berries|ToughAsNailsU_boiling_water_bottle
    display name: <reset><&translate[item.toughasnailsu.green_sweet_berry_tea_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_green_sweet_berry_tea_bottle]>
        #- <&translate[item.toughasnailsu_lore].with[+25<&translate[toughasnailsu.temperature.lore.heat]>|00:40]>
        #- <&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.10].strip_color>
        #- <script[ToughAsNailsU_items_data].data_key[items.ToughAsNailsU_green_sweet_berry_tea_bottle]>
        #- <&translate[toughasnailsu.thirst.lore.level.10].font[toughasnailsu]>

ToughAsNailsU_green_glow_berry_tea_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1101
    recipes:
        1:
            type: shapeless
            recipe_id: toughasnailsu_green_glow_berry_tea_bottle_1
            output_quantity: 1
            input: material:firework_star|material:firework_star|material:glow_berries|ToughAsNailsU_boiling_water_bottle
    display name: <reset><&translate[item.toughasnailsu.green_glow_berry_tea_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_green_glow_berry_tea_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.10]>

ToughAsNailsU_green_sugar_tea_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1102
    recipes:
        1:
            type: shapeless
            recipe_id: toughasnailsu_green_sugar_tea_bottle_1
            output_quantity: 1
            input: material:firework_star|material:firework_star|material:sugar|ToughAsNailsU_boiling_water_bottle
    display name: <reset><&translate[item.toughasnailsu.green_sugar_tea_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_green_sugar_tea_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.10]>

ToughAsNailsU_melon_juice_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1200
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: material:melon_slice|material:melon_slice|ToughAsNailsU_drinking_glass_bottle
    display name: <reset><&translate[item.toughasnailsu.melon_juice_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_melon_juice_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.10]>

ToughAsNailsU_carrot_juice_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1201
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: material:carrot|material:carrot|ToughAsNailsU_drinking_glass_bottle
    display name: <reset><&translate[item.toughasnailsu.carrot_juice_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_carrot_juice_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.10]>

ToughAsNailsU_sweet_berries_juice_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1202
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: material:sweet_berries|material:sweet_berries|ToughAsNailsU_drinking_glass_bottle
    display name: <reset><&translate[item.toughasnailsu.sweet_berries_juice_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_sweet_berries_juice_bottle]>
        #- <reset><&translate[item.toughasnailsu_lore.freeze].with[<&color[#55FFFF]>-25|<&color[#55FFFF]>00:40]>

ToughAsNailsU_amethyst_water_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1203
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: material:amethyst_shard|material:amethyst_shard|ToughAsNailsU_pure_water_bottle
    display name: <reset><&translate[item.toughasnailsu.amethyst_water_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_amethyst_water_bottle]>
        #- <reset><&font[toughasnailsu]><&translate[toughasnailsu.thirst.lore.level.10]>

ToughAsNailsU_wheat_wort_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1300
    recipes:
        1:
            type: shapeless
            recipe_id: toughasnailsu_wheat_wort_bottle_1
            output_quantity: 1
            input: material:wheat|material:wheat|material:wheat|material:firework_star|ToughAsNailsU_boiling_water_bottle
    display name: <reset><&translate[item.toughasnailsu.wheat_wort_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_wheat_wort_bottle]>
    flags:
        ToughAsNailsU_to_beer: ToughAsNailsU_wheat_beer_bottle

ToughAsNailsU_wheat_beer_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1400
    display name: <reset><&translate[item.toughasnailsu.wheat_beer_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_wheat_beer_bottle]>
    flags:
        ToughAsNailsU_beer: true

ToughAsNailsU_raw_milk_cacao_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1500
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: material:milk_bucket|material:cocoa_beans|material:cocoa_beans|material:sugar|ToughAsNailsU_drinking_glass_bottle
    display name: <reset><&translate[item.toughasnailsu.raw_milk_cacao_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_raw_milk_cacao_bottle]>

ToughAsNailsU_milk_cacao_bottle:
    debug: false
    type: item
    material: honey_bottle
    mechanisms:
        custom_model_data: 1600
    recipes:
        1:
            type: smoker
            cook_time: 5s
            category: food
            experience: 0.35
            input: ToughAsNailsU_raw_milk_cacao_bottle
    display name: <reset><&translate[item.toughasnailsu.milk_cacao_bottle]>
    lore:
        - <proc[ToughAsNailsU_food_lore].context[ToughAsNailsU_milk_cacao_bottle]>
#---------------------------
ToughAsNailsU_nailer_enchanted_book:
    debug: false
    type: item
    material: enchanted_book
    recipes:
        1:
            type: shaped
            output_quantity: 1
            category: equipment
            input:
            - air|material:netherite_scrap|air
            - material:fire_charge|material:book|material:snowball
            - air|material:amethyst_shard|air
    lore:
        - <enchantment[ToughAsNailsU_nailer].full_name[1]>
    enchantments:
        - ToughAsNailsU_nailer:1