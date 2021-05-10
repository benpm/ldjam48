extends Camera2D

onready var player = $"../player"

onready var transition_mask: Sprite = $transition_mask

onready var target: Node2D = player


func _process(_delta):
	position = lerp(position, target.position, 0.2)

func scale_mask(v: float):
	transition_mask.scale = Vector2(v, v)