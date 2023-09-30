WhiteListU_events:
    type: world
    debug: false
    events:
        on player prelogin:
            - determine <queue> passively
            - ~run whitelistu_load_whitelist

        on player logs in:
            - define whitelisted <player.name.proc[whitelistu_is_in_whitelist]>
            - run whitelistu_unload_whitelist
            - if !<[whitelisted]>:
                - determine "KICKED:<red>NOT IN WHITELIST"

        after server start:
            - if !<proc[WhiteListU_has_whitelist]>:
                - ~yaml create id:whitelistu
                - run whitelistu_save_whitelist
                - announce "<gray>[WhiteListU] <green>Whitelist created!" to_console
            - else:
                - announce "<gray>[WhiteListU] <green>Whitelist loaded!" to_console
            - ~run whitelistu_load_whitelist
            - announce "<gray>[WhiteListU] Players: <green><proc[whitelistu_names].comma_separated>" to_console
            - run whitelistu_unload_whitelist

WhiteListU_has_whitelist:
    type: procedure
    debug: false
    script:
        - determine <util.has_file[../WhiteListU/whitelist.yml]>

WhiteListU_is_in_whitelist:
    type: procedure
    debug: false
    definitions: name
    script:
        - if <yaml[whitelistu].contains[<[name].to_lowercase>]>:
            - determine true
        - determine false

WhiteListU_names:
    type: procedure
    debug: false
    script:
        - determine <yaml[whitelistu].list_keys[]>

#-------------
WhiteListU_load_whitelist:
    type: task
    debug: false
    script:
        - ~yaml load:../WhiteListU/whitelist.yml id:whitelistu
        - wait 10t

WhiteListU_unload_whitelist:
    type: task
    debug: false
    script:
        - yaml unload id:whitelistu

WhiteListU_save_whitelist:
    type: task
    debug: false
    script:
        - ~yaml savefile:../WhiteListU/whitelist.yml id:whitelistu
        - yaml unload id:whitelistu

WhiteListU_add_to_whitelist:
    type: task
    debug: false
    definitions: name
    script:
        - ~run whitelistu_load_whitelist
        - if <[name].proc[whitelistu_is_in_whitelist]>:
            - announce "<gray>[WhiteListU] <red>ALREADY IN LIST!" to_console
            - stop
        - yaml id:whitelistu set <[name].to_lowercase>
        - announce "<gray>[WhiteListU] Players: <green><proc[whitelistu_names].comma_separated>" to_console
        - run whitelistu_save_whitelist

WhiteListU_remove_from_whitelist:
    type: task
    debug: false
    definitions: name
    script:
        - ~run whitelistu_load_whitelist
        - if !<[name].proc[whitelistu_is_in_whitelist]>:
            - announce "<gray>[WhiteListU] <red>ALREADY NOT IN LIST!" to_console
            - stop
        - yaml id:whitelistu set <[name]>:!
        - announce "<gray>[WhiteListU] Players: <green><proc[whitelistu_names].comma_separated>" to_console
        - run whitelistu_save_whitelist


WhiteListU_command:
    type: command
    debug: false
    name: WhiteListU
    description: WhiteListU
    usage: /WhiteListU
    permission: WhiteListU.admin
    tab completions:
        1: remove|add
        2: <server.online_players.parse[name]>
    script:
        - if <context.args.size> == 2:
            - if <context.args.first> == add:
                - announce "<gray>[WhiteListU] Players: <green>loading..." to_console
                - ~run whitelistu_add_to_whitelist def:<context.args.get[2]>
            - if <context.args.first> == remove:
                - announce "<gray>[WhiteListU] Players: <green>loading..." to_console
                - run whitelistu_remove_from_whitelist def:<context.args.get[2]>
