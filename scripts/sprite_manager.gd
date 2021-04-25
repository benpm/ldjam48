tool

extends Node2D

export (String) var animation = "ex" setget set_animation

func _ready():
	$animator.play(animation, -1, 0.0)

func set_animation(v: String):
	if $animator:
		if v in $animator.get_animation_list():
			if v != animation:
				$animator.play(v, -1, 0.0)
			animation = v
		else:
			push_warning("'%s' not valid animation name" % v)

func set_frame(frame: int):
	$animator.play(animation, -1, $animator.playback_speed)
	$animator.seek(frame * 0.100, true)
