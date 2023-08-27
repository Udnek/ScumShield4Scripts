RpgU_generate_lore:
    type: procedure
    debug: false
    definitions: item
    script:
        - define stones <[item].proc[rpgu_stones_applied_amount]>
        - if <[stones]> > 0:
            - define stone <[item].flag[RpgU.upgrade_stones]>
            - define lore <&nl><gray><&translate[item.rpgu.upgrade_stone.lore.amount.<[stones]>]>
            - define item <[item].proc[autoloreu_create_ticket].context[RpgU|<[lore]>]>
        - else:
            - define item <[item].proc[autoloreu_clear_ticket].context[RpgU]>
        - define item <[item].proc[autoloreu_generate]>
        - determine <[item]>
        #- define attrs <[item].attribute_modifiers>
        #- define attrs_sum <map[]>
        #- foreach <[attrs]> key:attr_name as:attr_list:
        #    - foreach <[attr_list]> as:attr:
        #        #- if <[attr_sum].contains[<[attr_name]>]>:
        #        #- if <[attr_sum].get[<[attr_name]>].get[operation]> == <[attr].get[operation]>:
        #        - define attrs_sum.<[attr_name]>.<[attr].get[operation]>:+:<[attr].get[amount]>
        #        #- else:
        #        #    - define attr_sum.<[attr_name]>:<[attr].get[amount]>
#
#
        #- define lore <&translate[item.modifiers.<[attrs].get[].get[slot]>]>
        #- foreach <[attrs_sum].get_subset[<[attrs_sum].keys.sort_by_value[]>]> key:attr_name as:values:
        #    - foreach <[values]> key:operation as:amount:
#
        #        - define attr_name_translated <&translate[attribute.name.generic.<[attr_name].after[GENERIC_].to_lowercase>]>
#
        #        - if <[operation]> == ADD_SCALAR:
        #            - define amount_suffix %
        #            - define amount:*:100
        #        - else if <[attr_name]> == GENERIC_KNOCKBACK_RESISTANCE:
        #            - define amount_suffix %
        #            - define amount:*:100
        #        - else:
        #            - define amount_suffix <empty>
#
        #        - if <[amount]> > 0:
        #            - define color <color[green]>
        #            - define amount +<[amount]>
        #        - else:
        #            - define color <color[red]>
#
        #        - define lore "<[lore]><&nl><&color[<[color]>]><[amount]><[amount_suffix]> <[attr_name_translated]>"
#
        #- determine <[item].with[lore=<[lore]>]>