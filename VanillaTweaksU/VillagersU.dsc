VillagersU_events:
    type: world
    debug: false
    events:
        on player opens merchant bukkit_priority:LOWEST:
            - define villager <context.inventory.id_holder>
            - if <[villager].entity_type.if_null[null]> != VILLAGER:
                - stop
            - define new_trades <list[]>
            - foreach <[villager].trades> as:trade:
                - if <[trade].inputs.get[1].material.name> == emerald:
                    - define inputs <[trade].inputs>
                    - define inputs[1]:<[inputs].get[1].with[material=emerald_block]>
                    - define new_trade <[trade].with[inputs=<[inputs]>]>
                - else:
                    - define new_trade <[trade]>

                - define new_trades:->:<[new_trade].with[price_multiplier=0;special_price=0]>

            - adjust <[villager]> trades:<[new_trades]>