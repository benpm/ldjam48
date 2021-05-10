extends Area2D

class_name Trigger
func is_type(type): return type == "Trigger"
func    get_type(): return "Trigger"

signal trigger_on(who, data)
signal trigger_off(who, data)

var can_interact_holding := true

func trigger(who: Node2D, data = null):
	print_debug("%s Trigger: trigger" % name)
	emit_signal("trigger_on", who, data)

func untrigger(who: Node2D, data = null):
	print_debug("%s Trigger: untrigger" % name)
	emit_signal("trigger_off", who, data)
