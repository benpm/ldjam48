extends Node

var pressed: Array
var combo_correct: bool = false

const display_tilemap_coords := [Vector2(13, 10), Vector2(15, 10), Vector2(17, 10)]
const display_tileset_coords := [Vector2(8, 0), Vector2(9, 0), Vector2(10, 0), Vector2(11, 0)]

onready var door = $door

func _ready():
	remove_child(door)
	zone_change()

func zone_change():
	var zone = $"/root/scene"
	var press_plate: Trigger = zone.get_node("press_plate")
	press_plate.connect("trigger_on", self, "press_number")
	update_display_tiles()

func update_display_tiles():
	var tilemap: TileMap = $"/root/scene".get_node("TileMap")
	for i in range(3):
		var value := 0
		if i < pressed.size():
			value = pressed[i]
		tilemap.set_cell(
			display_tilemap_coords[i].x,
			display_tilemap_coords[i].y, 0, false, false, false,
			display_tileset_coords[value])

func press_number(who: Node2D, data: Dictionary):
	if combo_correct:
		return
	pressed.append(data["number"])
	update_display_tiles()
	print_debug("level controller pressed: ", pressed)
	if pressed.size() == 3:
		if pressed[0] == 1 and pressed[1] == 2 and pressed[2] == 3:
			$"/root/scene".add_child(door)
			door.show()
			combo_correct = true
		else:
			pressed.clear()
