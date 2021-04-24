extends Area2D

class_name Interactable
func is_type(type): return type == "Interactable"
func    get_type(): return "Interactable"

onready var controller = $"/root/Controller"

var can_interact_holding := true

func interacted_with(item):
	print_debug("%s Interactable: interacted with" % name)
