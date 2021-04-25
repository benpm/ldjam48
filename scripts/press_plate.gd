extends Trigger

export(bool) var toggle = false
export(Dictionary) var trigger_args

func trigger(who: Node2D, data = null):
	if data == null:
		data = Dictionary()
	for k in trigger_args:
		data[k] = trigger_args[k]
	.trigger(who, data)
	$sprite_manager/animator.play("press_plate_1", -1, 0.0)
	$sprite_manager/animator.seek(0.15, true)

func untrigger(who: Node2D, data = null):
	.untrigger(who, data)
	$sprite_manager/animator.play("press_plate_1", -1, 0.0)
	$sprite_manager/animator.seek(0.05, true)
