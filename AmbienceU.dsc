AmbienceU_show_fog:
    type: task
    debug: false
    definitions: duration
    script:
        - define time_between_cycles 20
        - define quantity 20

        - define cycles <[duration].in_ticks.div[<[time_between_cycles]>].round_up>

        - repeat <[cycles]> as:cycle:
            #- narrate <[cycle]>
            - foreach <server.online_players> as:__player:
                #- narrate <player.name>
                - if <player.location.world.name> == world:
                    - if ( <player.location.biome.temperature> > 0.15 ) && ( <player.location.biome.temperature> < 0.7 ):
                        - if !<player.has_flag[AmbienceU_has_fog]>:
                            - flag <player> AmbienceU_has_fog expire:2s
                            - bossbar auto AmbienceU_fog players:<server.bossbar_viewers[AmbienceU_fog].if_null[<list>].include[<player>]> options:CREATE_FOG
                            - playeffect effect:cloud at:<player.location> targets:<player> offset:10 visibility:200 quantity:<[quantity]>

                        - foreach next

                - if <player.has_flag[AmbienceU_has_fog]>:
                    - define players <server.bossbar_viewers[AmbienceU_fog].if_null[<list>].exclude[<player>]>
                    - if <[players].size> == 0:
                        - bossbar remove AmbienceU_fog
                    - else:
                        - bossbar auto AmbienceU_fog players:<server.bossbar_viewers[AmbienceU_fog].if_null[<list>].exclude[<player>]>

            - wait <[time_between_cycles]>t

        - if <server.current_bossbars.contains[AmbienceU_fog]>:
            - bossbar remove AmbienceU_fog


AmbienceU_show_wind:
    type: task
    debug: false
    script:
        - define vector <player.location.direction.vector.with_y[0]>
        - define speed 2
        - define quantity 5
        - define x_direction <[vector].x.mul[<[speed]>]>
        - define y_direction <[vector].y.mul[<[speed]>]>
        - define z_direction <[vector].z.mul[<[speed]>]>

        - bossbar auto AmbienceU_wind players:<server.bossbar_viewers[AmbienceU_wind].if_null[<list>].include[<player>]> options:DARKEN_SKY
        - while <player.item_in_hand.material.name> != netherite_sword:
            - playeffect effect:cloud at:<player.location> targets:<player> offset:100 visibility:500 quantity:<[quantity]> velocity:<[x_direction]>,<[y_direction]>,<[z_direction]>
            - playsound ENTITY_HORSE_BREATHE <player.location.sub[<[vector]>]> <player> sound_category:WEATHER volume:0.2
            - wait 2t

        - define players <server.bossbar_viewers[AmbienceU_wind].if_null[<list>].exclude[<player>]>
        - if <[players].size> == 0:
            - bossbar remove AmbienceU_wind
        - else:
            - bossbar update AmbienceU_wind players:<server.bossbar_viewers[AmbienceU_wind].if_null[<list>].exclude[<player>]>
        - narrate stopped

#-----------------------------------------

AmbienceU_actions:
    type: world
    debug: false
    events:
        after weather clears in world:
            #- flag server AmbienceU_fog_after_rain expire:<util.random.int[3].to[10]>s
            #- flag server AmbienceU_fog_after_raiwn expire:<util.random.int[3].to[10]>s
            - run AmbienceU_show_fog def:<duration[<util.random.int[45].to[180]>s]>