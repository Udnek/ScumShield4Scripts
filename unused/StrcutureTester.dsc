# TODO DO NOT WORK

StrucureTester_teststr_create:
    type: command
    name: teststr_create
    description: teststr_create
    usage: /teststr_create
    debug: false
    permission: StrucureTester.admin
    script:
        - define name:test_str_world
        - narrate "Started... (<[name]>)" targets:<server.online_players>
        - ~createworld <[name]> worldtype:flat
        - narrate Done! targets:<server.online_players>

WordGenerator_tp_testr:
    type: command
    name: tp_teststr
    description: tp_teststr
    usage: /tp_teststr
    debug: false
    permission: StrucureTester.admin
    script:
        - ~createworld test_str_world worldtype:flat
        - teleport <player> <location[<util.random.decimal[-10000].to[10000]>,10,<util.random.decimal[-10000].to[10000]>,<world[test_str_world]>]>

WordGenerator_tp_spawn:
    type: command
    name: tp_spawn
    description: tp_spawn
    usage: /tp_spawn
    debug: false
    permission: StrucureTester.admin
    script:
        - teleport <player> <location[0,10,0,<world[world]>]>
