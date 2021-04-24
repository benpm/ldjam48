extends Node2D

const player_tscn = preload("res://objects/player.tscn")
const main_camera_tscn = preload("res://objects/main_camera.tscn")

var scenes: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add player
	var player = player_tscn.instance()
	add_child(player)
	player.position = $player_spawn.position
	# Add main camera
	add_child(main_camera_tscn.instance())


func goto_scene(name: String):
	if not scenes.has(name):
		scenes[name] = load("res:")
