HudU_events:
    type: world
    debug: false
    events:
        after tick every:10:
            - actionbar <player.proc[HudU_get_hud]> per_player targets:<server.online_players>

HudU_get_hud:
    type: procedure
    debug: false
    script:
        - determine <player.flag[hudu.tickets].values.separated_by[]>

HudU_create_ticket:
    type: task
    debug: false
    definitions: ticket_name|message
    script:
        - flag <player> hudu.tickets.<[ticket_name]>:<[message]>

HudU_clear_ticket:
    type: task
    debug: false
    definitions: ticket_name
    script:
        - flag <player> hudu.tickets.<[ticket_name]>:!

HudU_get_ready_message:
    type: procedure
    debug: false
    definitions: message|size|offset
    script:
        - determine <&translate[space.<[offset]>]><[message]><&translate[space.-<[size]>]><&translate[space.<[offset].mul[-1]>]>