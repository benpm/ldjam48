extends Interactable

class_name Item
func is_type(type): return type == "Item" or .is_type(type)
func    get_type(): return "Item"
func   base_type(): return .get_type()

func picked_up():
	print_debug("%s Item: picked up" % name)

func put_down():
	print_debug("%s Item: put down" % name)
