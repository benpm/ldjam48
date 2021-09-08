extends Node

var plates_A: Array
var plates_B: Array
var gate_A: Node2D
var gate_B: Node2D
var gate_A_openstate := false
var gate_B_openstate := false

func _ready():
	zone_change()

func zone_change():
	var zone = Controller.current_zone
	if not gate_A: gate_A = zone.get_node("gate_A")
	if not gate_B: gate_B = zone.get_node("gate_B")
	if gate_A: gate_A.opened = gate_A_openstate
	if gate_B: gate_B.opened = gate_B_openstate
	for plate in get_tree().get_nodes_in_group("toggle_plate_A"):
		if not (plate in plates_A):
			plate.toggle_state = gate_A_openstate
			plates_A.append(plate)
			plate.connect("trigger_on", self, "_plate_A_trigger")
			plate.connect("trigger_off", self, "_plate_A_untrigger")
	for plate in get_tree().get_nodes_in_group("toggle_plate_B"):
		if not (plate in plates_B):
			plate.toggle_state = gate_B_openstate
			plates_B.append(plate)
			plate.connect("trigger_on", self, "_plate_B_trigger")
			plate.connect("trigger_off", self, "_plate_B_untrigger")

func _plate_A_trigger(_who: Node2D, _data: Dictionary):
	if not gate_A_openstate:
		gate_A_openstate = true
		for plate in plates_A:
			plate.toggle_state = true
	if gate_A: gate_A.opened = gate_A_openstate

func _plate_A_untrigger(_who: Node2D, _data: Dictionary):
	if gate_A_openstate:
		gate_A_openstate = false
		for plate in plates_A:
			plate.toggle_state = false
	if gate_A: gate_A.opened = gate_A_openstate

func _plate_B_trigger(_who: Node2D, _data: Dictionary):
	if not gate_B_openstate:
		gate_B_openstate = true
		for plate in plates_B:
			plate.toggle_state = true
	if gate_B: gate_B.opened = gate_B_openstate

func _plate_B_untrigger(_who: Node2D, _data: Dictionary):
	if gate_B_openstate:
		gate_B_openstate = false
		for plate in plates_B:
			plate.toggle_state = false
	if gate_B: gate_B.opened = gate_B_openstate
			
