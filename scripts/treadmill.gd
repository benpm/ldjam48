extends Area2D

export (float) var speed = 4.0



func _ready():
	$sprite_manager.anim_speed = speed / 4.0

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	var dir = Vector2(cos(rotation), sin(rotation)) * speed
	for body in bodies:
		body.vel += dir
