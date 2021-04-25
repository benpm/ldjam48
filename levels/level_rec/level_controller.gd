extends Node

var pressed: Array
var combo_correct: bool = false

func _ready():
	zone_change()

func zone_change():
	var zone = $"/root/scene"
	var press_plate: Trigger = zone.get_node("press_plate")
	press_plate.connect("trigger_on", self, "press_number")
	print_debug("connnectoi4otgnaeorgnenrgo")

func press_number(who: Node2D, data: Dictionary):
	if combo_correct:
		return
	pressed.append(data["number"])
	print_debug("level controller pressed: ", pressed)
	if pressed.size() == 3:
		if pressed[0] == 1 and pressed[1] == 2 and pressed[2] == 3:
			print_debug("WEINER")
			combo_correct = true
		else:
			pressed.clear()
	var tilemap: TileMap = $"/root/scene".get_node("TileMap")
