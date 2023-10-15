RpgU_hud_events:
    type: world
    debug: false
    events:
        after delta time secondly every:1:
            - foreach <server.online_players> as:__player:
                - run rpgu_update_hud

        after player equips armor:
            - run rpgu_update_hud

        after player swaps items:
            - wait 1t
            - run rpgu_update_hud


RpgU_update_hud:
    type: task
    debug: false
    script:
        - define armor <&color[#4e5c24]><&font[rpgu:armor]><&translate[rpgu.armor.level.<player.armor_bonus.round>]><&translate[space.-82]>
        - define armor_toughness <&font[rpgu:armor_toughness]><&translate[rpgu.armor_toughness.level.<player.attribute_value[generic_armor_toughness].round>]>
        - define message <[armor]><[armor_toughness]>
        - define message <[message].proc[hudu_get_ready_message].context[82|-91]>

        - run hudu_create_ticket def:RpgU|<[message]>