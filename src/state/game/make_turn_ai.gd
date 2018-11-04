extends 'base.gd'

var Hud
var regions
var source_region
var target_region

func _init():
    name = 'MAKE_TURN_AI'

func on_enter():
    regions = index.scene.Grid.get_regions_by_player_id(index.active_player)

    for n in range(3):
        source_region = regions[randi() % regions.size()]

        commands.add({
            "id": commands.CMD_SELECT_SOURCE_REGION,
            "region": source_region
        })
        yield(source_region, "selection_finish")

        target_region = false

        for lid in source_region.links:
            var region = index.scene.Grid.get_region(lid)
            if region.country_id >= 0 && region.country_id != (index.active_player + 1):
                target_region = region

        if target_region:
            commands.add({
                "id": commands.CMD_SELECT_TARGET_REGION,
                "region": target_region
            })
            yield(index.scene.turn, "turn_resolved")

    commands.add({
        "id": commands.CMD_END_TURN
    })

    pass
