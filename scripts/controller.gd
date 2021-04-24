extends Node2D

const player_tscn = preload("res://objects/player.tscn")
const main_camera_tscn = preload("res://objects/main_camera.tscn")

var scenes: Dictionary
var scaling_to: Vector2
var scaling_time: float
onready var root_level: Node2D = $"/root/scene"
var current_level: Node2D

const scaling_duration := 1.5
const scaling_speed := 0.075

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = root_level
	# Add player
	if $"/root/scene/player" == null:
		var player = player_tscn.instance()
		$"/root/scene".add_child(player)
		player.position = $"/root/scene/player_spawn".position
	# Add main camera
	if $"/root/scene/main_camera" == null:
		$"/root/scene".add_child(main_camera_tscn.instance())

func goto_level(target: Level):
	scaling_to = Vector2(pow(16.0, target.depth), pow(16.0, target.depth))
	current_level = target
	scaling_time = scaling_duration

func _process(delta):
	if scaling_time > 0:
		scaling_time -= delta
		root_level.scale = lerp(root_level.scale, scaling_to, scaling_speed)
		if scaling_time <= 0:
			scaling_time = 0
			root_level.scale = scaling_to
