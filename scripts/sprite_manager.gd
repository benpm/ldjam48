tool

extends Node2D

export (String) var animation = "ex" setget set_animation
export (float) var anim_speed = 0.0 setget set_anim_speed

var outline: Color = Color.transparent setget set_outline

func _ready():
	$animator.play(animation, -1, anim_speed)
	$animator.advance(0.0)
	$shadow.scale = Vector2(0.5, 0.5) * ($sprite.region_rect.size.x / $shadow.get_rect().size.y)

func set_animation(v: String):
	if $animator:
		if v in $animator.get_animation_list():
			if v != animation:
				$animator.play(v, -1, anim_speed)
			animation = v
		else:
			push_warning("'%s' not valid animation name" % v)

func set_anim_speed(v: float):
	$animator.playback_speed = v
	anim_speed = v

func set_frame(frame: int):
	$animator.play(animation, -1, anim_speed)
	$animator.seek(frame * 0.100, true)

func set_outline(color: Color):
	outline = color
	if not $sprite.material:
		$sprite.material = load("res://outline.tres").duplicate()
	$sprite.material.set_shader_param("outline_color", outline)
