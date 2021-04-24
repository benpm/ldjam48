extends Camera2D

onready var player = $"../player"
onready var controller = $"/root/Controller"

onready var overlay: ColorRect = $overlay

func _process(delta):
	position = lerp(position, player.position, 0.2)

func fade(amount: float):
	overlay.color.a = amount
	zoom = lerp(Vector2(1.0, 1.0), Vector2(0.35, 0.35), amount)
