OptiU_actions:
    type: world
    debug: false
    events:
        after delta time secondly every:30:
            - define mspt <paper.tick_times.first.in_milliseconds>
            - define optimization <server.flag[OptiU.optimization].if_null[standart]>
            #- flag server OptiU.standart_settings.view_distance

            - if <[mspt]> >= 20 && <server.flag[OptiU.previos_mspt]> >= 20:
                - if <[optimization]> == standart:
                    - run optiu_strong_optimization
                    - stop

            - else if <[optimization]> == strong:
                - run optiu_standart_optimization

            - flag server OptiU.previos_mspt:<[mspt]>

        after server start:
            - flag server OptiU.standart_settings.view_distance:<server.view_distance>

            - run optiu_standart_optimization

        after script reload:
            - flag server OptiU.previos_mspt:0

OptiU_standart_optimization:
    type: task
    debug: false
    script:
        - flag server OptiU.optimization:standart
        - announce <red>standart_optimization

        - adjust <world[world]> view_distance:<server.flag[OptiU.standart_settings.view_distance].if_null[5]>

OptiU_strong_optimization:
    type: task
    debug: false
    script:
        - flag server OptiU.optimization:strong
        - announce <red>strong_optimization

        - adjust <world[world]> view_distance:5