extends Area2D

export (float) var speed = 4.0



func _ready():
	var anim = $sprite_manager/animator
	anim.stop()
	anim.get_animation($sprite_manager.animation).loop = true
	anim.play($sprite_manager.animation, -1, speed)

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	var dir = Vector2(cos(rotation), sin(rotation)) * speed
	for body in bodies:
		body.vel += dir
