PathU_actions:
    type: world
    debug: false
    events:
        after player steps on grass_block chance:5:
            - if !<player.is_sneaking>:
                - ratelimit <player> 15t
                - modifyblock <context.location> dirt

        after player steps on dirt chance:20:
            - if !<player.is_sneaking>:
                - ratelimit <player> 10t
                - modifyblock <context.location> dirt_path