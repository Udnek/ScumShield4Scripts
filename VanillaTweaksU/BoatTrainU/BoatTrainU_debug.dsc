BoatTrainU_show_debug:
    type: task
    debug: false
    definitions: seat[EntityTag]
    script:
        - define fuel_item <[seat].flag[BoatTrainU_fuel_item].material.name.if_null[no]>
        - define fuel_used <[seat].flag[BoatTrainU_fuel_used]>
        - define fuel_max_uses <[seat].flag[BoatTrainU_fuel_item].proc[boattrainu_strong_boat_fuel_burn_time].if_null[no]>
        - define fuel_list <[seat].proc[BoatTrainU_strong_boat_fuel_list].get[1].to[3].parse_tag[<[parse_value].proc[utilsu_item_actual_name]>[<[parse_value].quantity>]].formatted.if_null[no]>
        - sidebar title:BoatTrainU "values:fuel_item: <[fuel_item]>|fuel_used: <[fuel_used]>|fuel_max_uses: <[fuel_max_uses]>|fuel_list: <[fuel_list]>"