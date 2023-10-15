RpgU_totem_of_saving:
    type: item
    debug: false
    material: paper
    display name: <reset><&translate[item.rpgu.totem_of_saving]>
    mechanisms:
        custom_model_data: 100100
    recipes:
        1:
            type: shaped
            input:
            - air|material:copper_ingot|air
            - material:copper_ingot|material:carved_pumpkin|material:copper_ingot
            - air|material:lapis_lazuli|air

RpgU_totem_of_saving_entity:
    type: entity
    debug: false
    entity_type: armor_stand
    mechanisms:
        is_small: true
        disabled_slots: <map[HEAD=ALL;CHEST=ALL;LEGS=ALL;FEET=ALL]>
        equipment: <map[HELMET=paper[custom_model_data=100101]]>
        base_plate: false

RpgU_totem_of_saving_gui:
    type: inventory
    inventory: chest
    title: <&translate[container.rpgu.totem_of_saving]>
    size: 54


RpgU_totem_of_saving_events:
    type: world
    debug: false
    events:
        on player dies:
            - if !<player.inventory.contains_item[RpgU_totem_of_saving]>:
                - stop
            - define drops <inventory[generic[contents=<context.drops>;size=54]]>
            - take item:RpgU_totem_of_saving from:<[drops]>
            - run RpgU_totem_of_saving_spawn_grave def.location:<player.location> def.items:<list_single[<[drops].list_contents.exclude[<item[air]>]>]> def.owner:<player>
            - determine NO_DROPS passively

        after player right clicks RpgU_totem_of_saving_entity:
            - ratelimit <player> 1t
            - ~run rpgu_totem_of_saving_open_gui def:<context.entity>
            - run rpgu_totem_of_saving_remove_grave def:<context.entity>

        after player closes RpgU_totem_of_saving_gui:
            - give <context.inventory.list_contents.exclude[<item[air]>]>

        on RpgU_totem_of_saving_entity dies:
            - determine <context.entity.flag[GraveU_contents]>

RpgU_totem_of_saving_spawn_grave:
    type: task
    debug: false
    definitions: location|items|owner
    script:
        - spawn rpgu_totem_of_saving_entity save:grave
        - flag <entry[grave].spawned_entity> GraveU_contents:<[items].get[1]>
        - flag <entry[grave].spawned_entity> GraveU_owner:<[owner]>
        - cast invisibility <entry[grave].spawned_entity>


RpgU_totem_of_saving_remove_grave:
    type: task
    debug: false
    definitions: grave
    script:
        - playeffect effect:soul_fire_flame at:<[grave].location> offset:1 velocity:0,0.3,0 quantity:20
        - remove <[grave]>


RpgU_totem_of_saving_open_gui:
    type: task
    debug: false
    definitions: grave
    script:
        - define inventory <inventory[RpgU_totem_of_saving_gui]>
        - give <[grave].flag[GraveU_contents]> to:<[inventory]>
        - inventory open d:<[inventory]>
