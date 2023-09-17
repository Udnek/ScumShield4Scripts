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

                #- define new_trades:->:<[new_trade].with[price_multiplier=0;special_price=0]>
                - define new_trades:->:<[new_trade]>

            - adjust <[villager]> trades:<[new_trades]>

        #after player right clicks villager with:netherite_sword:
        #    - narrate <context.entity.describe>
        #    - adjust <context.entity> has_ai:false
        #    - adjust <context.entity> villager_level:5
        #    - adjust <context.entity> villager_experience:999999
#
        #after villager acquires trade:
        #    - announce OK