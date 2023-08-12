TabU_update:
    type: task
    debug: false
    definitions: __player
    script:
        - define "header:<&nl><bold>Scam<gold><bold>Shield<&nl><white><&m>               "
        - define "footer:<gold><&m>               <&nl><white>Ping: <player.ping><&nl><&nl><white>TPS:<server.recent_tps.get[3].round> MSPT:<paper.tick_times.first.in_milliseconds.round_to[3]><&nl><&nl><gray><util.ram_usage.div[1024].div[1024].round> / <static[<util.ram_max.div[1024].div[1024]>]> MiB"
        - adjust <player> tab_list_info:<[header]>|<[footer]>

TabU_actions:
    type: world
    debug: false
    events:
        after delta time secondly:
            - foreach <server.online_players> as:p:
                - run tabu_update def:<[p]>


        #after server start:
        #    - run TabU_auto_update

        on player joins:
            - if <player.name> == herobrine:
                - adjust <player> hide_from_players
                - determine NONE

        on player quits:
            - if <player.name> == herobrine:
                - determine NONE

        after player quits:
            - adjust <player> show_to_players

        #after player changes world from world to world:
        #    #- choose <context.destination_world.name>:
        #    #    - case world_nether:
        #    #        - define nick:<red><player.display_name>
        #    #    - case world_the_end:
        #    #        - define nick:<&color[#ff00ff]><player.display_name>
        #    #    - default:
        #    #        - define nick:<&color[#00ff00]><player.display_name>
##
        #    #- define uuid:<player.uuid>
        #    #- foreach <server.online_players> as:__player:
        #    #    - tablist update uuid:<[uuid]> display:<[nick]>
#
        #    - choose <context.destination_world.name>:
        #        - case world_nether:
        #            - define nick:<red><player.display_name>
        #        - case world_the_end:
        #            - define nick:<&color[#ff00ff]><player.display_name>
        #        - default:
        #            - define nick:<&color[#00ff00]><player.display_name>
#
        #    - adjust <player> display_name:<[nick]>
        #    #- adjust <player> name:<player.display_name>


        #after player joins:
        #    - if <player.name> == herobrine:
                #- adjust <player> hide_from_players
                #- tablist remove uuid:<player.uuid> player:<server.online_players>

        #on player receives tablist update:
        #    - determine NAME:<player[<context.uuid>].display_name>
        #    #- narrate "<context.name>, <player.name>"
        #    #- if <context.name> == herobrine:
        #    #    - if <player.name> != herobrine:
        #    #        - determine LISTED:false
        #    #        #- tablist remove uuid:<context.uuid>
        #    #- if <context.>
        #    #- determine DISPLAY:<red><context.name>
        #    - choose <player[<context.uuid>].location.world.name>:
        #        - case world_nether:
        #            - determine DISPLAY:<red><player.display_name>
        #        - case world_the_end:
        #            - determine DISPLAY:<&color[#ff00ff]><player.display_name>
        #        - default:
        #            - determine DISPLAY:<&color[#00ff00]><player.display_name>
