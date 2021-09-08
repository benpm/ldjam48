extends Interactable

class_name ZoneTeleport
func is_type(type): return type == "ZoneTeleport" or .is_type(type)
func    get_type(): return "ZoneTeleport"
func   base_type(): return .get_type()

export(String) var to_zone

func _enter_tree():
	self.does_something = true
