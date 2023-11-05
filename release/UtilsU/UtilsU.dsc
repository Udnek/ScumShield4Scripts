UtilsU_lore_duration:
    type: procedure
    debug: false
    definitions: duration
    script:
        - define minutes <[duration].in_minutes.round_down>
        - define seconds <[duration].in_seconds.sub[<[minutes].mul[60]>]>
        - if <[minutes].length> == 1:
            - define minutes 0<[minutes]>
        - if <[seconds].length> == 1:
            - define seconds 0<[seconds]>
        - determine <[minutes]>:<[seconds]>

UtilsU_item_actual_name:
    type: procedure
    debug: false
    definitions: item
    script:
        - determine <[item].script.name.if_null[<[item].material.name>]>

UtilsU_item_actual_display:
    type: procedure
    debug: false
    definitions: item
    script:
        - if <[item].script.exists>:
            - determine <item[<[item].script.name>].display>
        - determine <[item].material.translated_name>

UtilsU_mul_duration:
    type: procedure
    debug: false
    definitions: duration|n
    script:
        - determine <duration[<[duration].in_ticks.mul[<[n]>]>t]>

UtilsU_round_up_ticks_duration:
    type: procedure
    debug: false
    definitions: duration
    script:
        - determine <duration[<[duration].in_seconds.round_up>]>

UtilsU_initial_item:
    type: procedure
    debug: false
    definitions: item
    script:
        - determine <item[<[item].script.name>].with[quantity=<[item].quantity>]>

UtilsU_entity_actual_name:
    type: procedure
    debug: false
    definitions: entity
    script:
        - determine <[entity].script.name> if:<[entity].script.exists>
        - determine <[entity].entity_type>

UtilsU_all_items_in_inventory:
    type: procedure
    debug: false
    definitions: inventory|item[ItemTag or Name]
    script:
        - define slots <[inventory].find_all_items[<[item]>]>
        - determine <list[]> if:<[slots].equals[0]>
        - determine <[inventory].slot[<[slots]>]>