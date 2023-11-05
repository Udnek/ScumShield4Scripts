ScriptFixingU_events:
    type: world
    debug: false
    events:
        on player prepares anvil craft item bukkit_priority:HIGHEST:
            - if <context.item.material.name> == air:
                - stop

            - define result <context.item.proc[autoloreu_generate]>
            - if <context.item.script.exists>:
                - define script_item <item[<context.item.script.name>]>
                - if <[script_item].has_display>:
                    - define result <[result].with[display=<[script_item].display>]>
                    - if <[result].with[quantity=1]> == <[script_item]>:
                        - determine <[script_item].with[quantity=<[result].quantity>]>

            - determine <[result]>

        on player prepares grindstone craft item bukkit_priority:HIGHEST:
            - determine RESULT:<context.result.proc[autoloreu_generate]>