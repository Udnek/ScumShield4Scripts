EnchantingU_events:
    type: world
    debug: false
    events:
        on player prepares anvil craft item:
            - if <context.item.material.name> == air:
                - stop
            - adjust <context.inventory> anvil_max_repair_cost:65536