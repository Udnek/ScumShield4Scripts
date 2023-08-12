RpgU_other_events:
    type: world
    debug: false
    events:
        on item recipe formed:
            - if <context.recipe_id> == minecraft:repair_item:
                - determine cancelled

        after player joins:
            - adjust <player> attribute_base_values:<map[generic_max_health=10]>