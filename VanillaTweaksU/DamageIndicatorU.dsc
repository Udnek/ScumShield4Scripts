DamageIndicatorU_indicator_entity:
    debug: false
    type: entity
    entity_type: text_display
    mechanisms:
        text: Damage
        pivot: center
        text_shadowed: false
        background_color: 0,0,0,0
        interpolation_duration: 10t
        translation: 0,0.4,0

DamageIndicatorU_actions:
    type: world
    debug: false
    events:
        on entity damaged by entity:
            - define text_entity <entity[DamageIndicatorU_indicator_entity]>
            - define damage <context.final_damage.round_to[2]>

            - if <[damage]> > 15:
                - define text <red>
            - else if <[damage]> > 10:
                - define text <yellow>
            - else if <[damage]> > 5:
                - define text <green>
            - else:
                - define text <gray>

            - if <context.was_critical>:
                - define text <[text]><bold>

            - define text <[text]><[damage]>

            - adjust def:text_entity text:<[text]>
            - fakespawn <[text_entity]> <context.entity.eye_location> players:<server.online_players> d:1 save:display
            - wait 2t
            - adjust <entry[display].faked_entity> translation:0,2,0
            - adjust <entry[display].faked_entity> interpolation_start:0t