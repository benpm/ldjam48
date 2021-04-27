extends Trigger

export(Dictionary) var trigger_args

export(String) var on_animation

onready var off_animation: String = $sprite_manager.animation

var toggle_state := false setget set_toggle_state

func trigger(who: Node2D, data = null):
	$sprite_manager.set_frame(1)

func set_toggle_state(value: bool):
	toggle_state = value
	if toggle_state:
		.trigger(null, trigger_args)
		$sprite_manager.animation = on_animation
		print_debug("%s triggered" % name)
	else:
		.untrigger(null, trigger_args)
		$sprite_manager.animation = off_animation
		print_debug("%s untriggered" % name)

func untrigger(who: Node2D, data = null):
	set_toggle_state(not toggle_state)
	$sprite_manager.set_frame(0)

