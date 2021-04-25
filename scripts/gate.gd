tool

extends StaticBody2D

export var opened := false setget set_opened

func set_opened(value: bool):
	opened = value
	$collider.disabled = opened
	if opened:
		$sprite_manager.set_frame(1)
	else:
		$sprite_manager.set_frame(0)
