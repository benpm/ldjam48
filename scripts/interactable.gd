extends Area2D

class_name Interactable
func is_type(type): return type == "Interactable"
func    get_type(): return "Interactable"

var can_interact_holding := true
var does_something := false

func interacted_with(item):
	print_debug("%s Interactable: interacted with" % name)

func can_interact(item) -> bool:
	return true