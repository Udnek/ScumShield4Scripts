FoodifyU_gui:
    type: inventory
    debug: false
    inventory: chest
    title: FoodifyU
    gui: true
    procedural items:
        - determine <static[<proc[foodifyu_gui_generate]>]>
    size: 27
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

FoodifyU_gui_generate:
    type: procedure
    debug: false
    script:
        - define result <list[]>
        - define items <script[foodifyu_data].data_key[items]>
        - foreach <[items]> key:item_name as:data:
            - define item <item[<[item_name]>]>
            - define effect_data <[item].proc[foodifyu_item_to_effect]>
            - define name <&translate[effect.minecraft.<[effect_data].get[type].proc[foodifyu_effect_name_to_minecraft_effect]>]>
            - if <[effect_data].get[amplifier]> == 0:
                - define amplifier <empty>
            - else:
                - define amplifier "<&translate[potion.potency.<[effect_data].get[amplifier]>]> "
            - define duration <[effect_data].get[duration].proc[utilsu_lore_duration]>
            - define lore <blue><&translate[item.foodifyu.soup.effects.description].with[<[name]>|<[amplifier]>|<[duration]>]>
            - define result:->:<[item].with[lore=<[lore]>]>
        - determine <[result]>


FoodifyU_gui_command:
    type: command
    debug: false
    name: FoodifyU
    description: FoodifyU
    usage: /FoodifyU
    script:
        - inventory open destination:FoodifyU_gui