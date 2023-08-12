# TODO DO NOT WORK

WordGenerator_new_world_command:
    type: command
    name: new_world
    description: new_world
    usage: /new_world
    debug: false
    permission: WordGenerator.admin
    script:
        - define name:8_RandomWorld_<server.worlds.size>
        - narrate "Started... (<[name]>)" targets:<server.online_players>
        - ~createworld <[name]>
        - narrate Done! targets:<server.online_players>
        - teleport <server.online_players> <world[<[name]>].spawn_location>
        - repeat 30 as:i:
            - modifyblock <world[<[name]>].spawn_location.add[0,<[i]>,0]> red_stained_glass

WordGenerator_world_name_command:
    type: command
    name: world_name
    description: world_name
    usage: /world_name
    debug: false
    permission: WordGenerator.admin
    script:
        - narrate <player.location.world.name>

WordGenerator_tp_world_command:
    type: command
    name: tp_world
    description: tp_world
    usage: /tp_world
    debug: false
    permission: WordGenerator.admin
    tab completions:
        1: <server.worlds.parse[name]>
    script:
        - teleport <player> <world[<context.args.get[1]>].spawn_location>