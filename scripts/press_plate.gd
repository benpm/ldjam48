extends Trigger

export(Dictionary) var trigger_args

onready var start_animation: String = $sprite_manager.animation

var toggle_state := false

func trigger(who: Node2D, data = null):
	if data == null:
		data = Dictionary()
	for k in trigger_args:
		data[k] = trigger_args[k]
	.trigger(who, data)
	$sprite_manager.set_frame(1)

func untrigger(who: Node2D, data = null):
	.untrigger(who, data)
	$sprite_manager.set_frame(0)
