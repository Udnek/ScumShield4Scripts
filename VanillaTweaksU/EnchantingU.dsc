EnchantingU_actions:
    type: world
    debug: false
    events:
        on player prepares anvil craft item bukkit_priority:HIGHEST:

            - if <context.item.material.name> == air:
                - stop

            - adjust <context.inventory> anvil_max_repair_cost:65536

            - define all_custom_enchantments <list[ToughAsNailsU_nailer]>
            #- define lore <context.item.lore>
            - define enchantment_lore <list[]>
            - foreach <[all_custom_enchantments]> as:enchantment:
                - if <context.item.enchantment_map.contains[<[enchantment]>]>:
                    - define enchantment_lore:->:<enchantment[<[enchantment]>].full_name[<context.item.enchantment_map.get[<[enchantment]>]>]>

            - define result <context.item>
            - if <[enchantment_lore].size> > 0:
                - define result <[result].with[lore=<[enchantment_lore]>]>
            - if <context.item.has_display>:
                - define result <[result].with[display=<context.item.display>]>

            - determine <[result]>

        on player prepares grindstone craft item bukkit_priority:HIGHEST:
            - define all_custom_enchantments <list[ToughAsNailsU_nailer]>
            - repeat <context.inventory.list_contents.size> as:i:
                - foreach <[all_custom_enchantments]> as:enchantment:
                    - if <context.inventory.list_contents.get[<[i]>].enchantment_map.contains[<[enchantment]>]>:
                        - determine RESULT:<context.result.with[lore=<list[]>]>