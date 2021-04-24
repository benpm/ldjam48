extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_collide: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_sack_body_entered(body):
	player_collide = true

func _on_sack_body_exited(body):
	pass # Replace with function body.
