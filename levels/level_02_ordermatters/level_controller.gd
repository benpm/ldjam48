extends Node

var plates: Array
onready var gate: Node2D = $"../gate"

func _ready():
	zone_change()

func zone_change():
	var toggle_plates: Array = get_tree().get_nodes_in_group("toggle_plate")
	for plate in toggle_plates:
		if not (plate in plates):
			plate.toggle_state = gate.opened
			plates.append(plate)
			plate.connect("trigger_on", self, "_plate_trigger")
			plate.connect("trigger_off", self, "_plate_untrigger")

func _plate_trigger(who: Node2D, data: Dictionary):
	if not gate.opened:
		gate.opened = true
		for plate in plates:
			plate.toggle_state = true

func _plate_untrigger(who: Node2D, data: Dictionary):
	if gate.opened:
		gate.opened = false
		for plate in plates:
			plate.toggle_state = false
