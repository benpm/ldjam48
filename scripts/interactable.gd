extends Area2D

class_name Interactable
func is_type(type): return type == "Interactable"
func    get_type(): return "Interactable"


func interacted_with():
	print_debug("%s Interactable: interacted with" % name)
