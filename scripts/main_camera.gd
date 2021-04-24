extends Camera2D

onready var player = $"../player"
onready var controller = $"/root/Controller"

func _process(delta):
	position = player.position
