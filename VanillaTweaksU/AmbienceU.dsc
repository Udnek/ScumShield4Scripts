AmbienceU_show_fog:
    type: task
    debug: false
    definitions: duration
    script:
        - define time_between_cycles <duration[2s]>
        - define quantity 20

        - define cycles <[duration].in_ticks.div[<[time_between_cycles].in_ticks>].round_up>

        - repeat <[cycles]> as:cycle:

            - foreach <server.online_players> as:__player:

                - define can_have_fog <player.location.world.environment.equals[NORMAL].and[<player.location.downfall_type.equals[RAIN]>]>
                - define have_fog <player.bossbar_ids.contains[AmbienceU_fog]>

                #- announce "can_have_fog:<[can_have_fog]> have_fog:<[have_fog]>"

                - if <[have_fog]> && <[can_have_fog]>:
                    - playeffect effect:cloud at:<player.location> targets:<player> offset:10 visibility:200 quantity:<[quantity]>
                    - foreach next

                - else if <[can_have_fog]> && !<[have_fog]>:
                    - bossbar auto AmbienceU_fog players:<server.bossbar_viewers[AmbienceU_fog].if_null[<list[]>].include[<player>]> options:CREATE_FOG

                - else if !<[can_have_fog]> && <[have_fog]>:
                    - define viewers <server.bossbar_viewers[AmbienceU_fog].if_null[<list[]>].exclude[<player>]>
                    - if <[viewers].size> == 0:
                        - bossbar remove AmbienceU_fog
                    - else:
                        - bossbar auto AmbienceU_fog players:<[viewers]> options:CREATE_FOG

            - wait <[time_between_cycles]>

        - if <server.current_bossbars.contains[AmbienceU_fog]>:
            - bossbar remove AmbienceU_fog

# TODO DO NOT WORK
AmbienceU_show_wind:
    type: task
    debug: false
    script:
        - define vector <player.location.direction.vector.with_y[0]>
        - define speed 2
        - define quantity 10
        - define x_direction <[vector].x.mul[<[speed]>]>
        - define y_direction <[vector].y.mul[<[speed]>]>
        - define z_direction <[vector].z.mul[<[speed]>]>

        - bossbar auto AmbienceU_wind players:<server.bossbar_viewers[AmbienceU_wind].if_null[<list>].include[<player>]> options:DARKEN_SKY
        - while <player.item_in_hand.material.name> != netherite_sword:
            - playeffect effect:cloud at:<player.location> targets:<player> offset:150 visibility:500 quantity:<[quantity]> velocity:<[x_direction]>,<[y_direction]>,<[z_direction]>
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
            - run AmbienceU_show_fog def:<duration[<util.random.int[280].to[380]>s]>