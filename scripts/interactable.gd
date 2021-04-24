extends Area2D

class_name Interactable
func is_type(type): return type == "Interactable"
func    get_type(): return "Interactable"

onready var container_level: Level = find_parent("scene")
onready var controller = $"/root/Controller"

func interacted_with():
	print_debug("%s Interactable: interacted with" % name)
