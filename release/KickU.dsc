KickU_command:
    type: command
    debug: false
    name: kicku
    description: kicku
    usage: /kicku
    permission: kicku.kicker
    script:
        - if <context.args.size> != 1:
            - stop
        - define name <context.args.first>
        - define player <server.match_player[<[name]>]>
        - if <[player].if_null[null]> == null:
            - stop
        - run whitelistu_load_whitelist
        - if !<[player].name.proc[whitelistu_is_in_whitelist]>:
            - kick <[player]>
        - run whitelistu_unload_whitelist