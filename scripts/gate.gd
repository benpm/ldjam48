tool

extends StaticBody2D

export var opened := false setget set_opened

func set_opened(value: bool):
	if value != opened:
		opened = value
		$collider.set_deferred("disabled", opened)
		if opened:
			$sprite_manager.set_frame(1)
			print_debug("gate_open")
			Controller.play_sound("gate_open", position)
		else:
			$sprite_manager.set_frame(0)
			print_debug("gate_close")
			Controller.play_sound("gate_close", position)
