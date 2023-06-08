DamageIndicatorU_indicator_entity:
    debug: false
    type: entity
    entity_type: text_display
    mechanisms:
        text: Damage
        pivot: center
        text_shadowed: false
        #default_background: true
        #display_entity_data: <map[text=Damage;text_is_shadowed=true;text_is_default_background=false;billboard=center]>

DamageIndicatorU_actions:
    type: world
    debug: false
    events:
        on entity damaged by entity:
            - define text_entity:<entity[DamageIndicatorU_indicator_entity]>
            - define damage:<context.final_damage.round_to[2]>

            - if <[damage]> > 15:
                - define text:<red>
            - else if <[damage]> > 10:
                - define text:<yellow>
            - else if <[damage]> > 5:
                - define text:<green>
            - else:
                - define text:<gray>

            - if <context.was_critical>:
                - define text:<[text]><bold>

            - define text:<[text]><[damage]>

            - adjust def:text_entity text:<[text]>
            - fakespawn <[text_entity]> <context.entity.eye_location.above[0.4]> players:<server.online_players> d:1
            #- spawn <[text_entity]> <context.entity.eye_location.above[0.4]> save:text_spawned
            #- push armor_stand origin:<context.entity.location.above[1]> destination:<context.entity.location.above[2].with_yaw[<util.random.decimal[0].to[360]>].forward[3]> speed:0.4 save:text_spawned
            #- define text_spawned:<entry[text_spawned].spawned_entity>
            #- wait 1.5s
            #- remove <[text_spawned]>

        #on entity damages entity:
        #    - narrate <context.cause> targets:<server.online_players>