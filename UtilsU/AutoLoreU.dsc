AutoLoreU_generate:
    type: procedure
    debug: false
    definitions: item
    script:
        - define item <[item].with[lore=]>
        - if <[item].script.exists>:
            - define lore <item[<[item].script.name>].lore.if_null[]>
        - else:
            - define lore <empty>

        - foreach <[item].enchantment_map> key:name as:level:
            - if !<enchantment[<[name]>].key.contains[minecraft:]>:
                - define lore <[lore]><enchantment[<[name]>].full_name[<[level]>]><&nl>

        - if <[item].has_flag[AutoLoreU_tickets]>:
            - define lore <[lore]>
            - foreach <[item].flag[AutoLoreU_tickets]> as:value:
                - define lore <[lore]><[value]><&nl>

        - if <[lore].length> == 0:
            - determine <[item]>
        - determine <[item].with[lore=<[lore].substring[1,<[lore].length.sub[1]>]>]>


AutoLoreU_create_ticket:
    type: procedure
    debug: false
    definitions: item|ticket_name|value
    script:
        - determine <[item].with_flag[AutoLoreU_tickets.<[ticket_name]>:<[value]>]>


AutoLoreU_clear_ticket:
    type: procedure
    debug: false
    definitions: item|ticket_name
    script:
        - determine <[item].with_flag[AutoLoreU_tickets.<[ticket_name]>:!]>