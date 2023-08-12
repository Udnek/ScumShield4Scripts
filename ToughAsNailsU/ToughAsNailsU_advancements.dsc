ToughAsNailsU_advancement_overheat:
    type: task
    debug: false
    script:
        - adjust <player> award_advancement:toughasnailsu:toughasnailsu/overheat

ToughAsNailsU_advancement_overfreeze:
    type: task
    debug: false
    script:
        - adjust <player> award_advancement:toughasnailsu:toughasnailsu/overfreeze

ToughAsNailsU_advancement_anabiosis:
    type: task
    debug: false
    script:
        - adjust <player> award_advancement:toughasnailsu:toughasnailsu/anabiosis

ToughAsNailsU_advancement_custom_tree:
    type: task
    debug: false
    script:
        - adjust <player> award_advancement:toughasnailsu:toughasnailsu/custom_tree

ToughAsNailsU_advancement_flask_full:
    type: task
    debug: false
    definitions: flask
    script:
        - adjust <player> award_advancement:toughasnailsu:toughasnailsu/flask_full
        - foreach <[flask].inventory_contents> as:item:
            - if !<item[<[item].flag[item]>].has_flag[ToughAsNailsU_beer]>:
                - stop
        - adjust <player> award_advancement:toughasnailsu:toughasnailsu/flask_full_beer