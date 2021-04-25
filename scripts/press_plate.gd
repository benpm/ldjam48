extends Trigger

export(bool) var toggle = false
export(Dictionary) var trigger_args

onready var start_animation: String = $sprite_manager.animation

func trigger(who: Node2D, data = null):
	if data == null:
		data = Dictionary()
	for k in trigger_args:
		data[k] = trigger_args[k]
	.trigger(who, data)
#	$sprite_manager/animator.play(start_animation, -1, 0.0)
	$sprite_manager/animator.seek(0.15, true)

func untrigger(who: Node2D, data = null):
	.untrigger(who, data)
#	$sprite_manager/animator.play(start_animation, -1, 0.0)
	$sprite_manager/animator.seek(0.05, true)
