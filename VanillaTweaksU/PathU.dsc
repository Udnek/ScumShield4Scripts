PathU_actions:
    type: world
    debug: false
    events:
        after player steps on grass_block chance:1:
            - if !<player.is_sneaking>:
                - if <context.location.above.material.name> != air:
                    - stop
                - ratelimit <player> 15t
                - modifyblock <context.location> dirt

        after player steps on dirt chance:6:
            - if !<player.is_sneaking>:
                - if <context.location.above.material.name> != air:
                    - stop
                - ratelimit <player> 15t
                - modifyblock <context.location> dirt_path