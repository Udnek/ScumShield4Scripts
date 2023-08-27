EnchantingTableFixU_enchanting_table:
    type: item
    debug: false
    material: enchanting_table
    allow in material recipes: false
    no_id: true
    recipes:
        1:
            recipe_id: enchantingtablefixu_enchanting_table
            type: shaped
            category: misc
            input:
            - air|EnchantingTableFixU_enchanting_book|air
            - material:diamond|material:obsidian|material:diamond
            - material:obsidian|material:obsidian|material:obsidian

EnchantingTableFixU_enchanting_book:
    type: item
    debug: false
    material: paper
    display name: <reset><&translate[item.enchantingfixu.enchanting_book]>
    # <&font[alt]>
    mechanisms:
        custom_model_data: 10000

EnchantingTableFixU_events:
    type: world
    debug: false
    events:
        after server start:
            - adjust server remove_recipes:minecraft:enchanting_table

        after server resources reloaded:
            - adjust server remove_recipes:minecraft:enchanting_table

        after wandering_trader spawns chance:100:
            - define trades <context.entity.trades>
            - define trades:->:<trade[trade[max_uses=1;inputs=emerald[quantity=<util.random.int[32].to[64]>];result=<item[EnchantingTableFixU_enchanting_book]>]]>
            - adjust <context.entity> trades:<[trades]>