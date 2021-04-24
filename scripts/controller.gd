extends Node2D

const player_tscn = preload("res://objects/player.tscn")
const main_camera_tscn = preload("res://objects/main_camera.tscn")
const exit_tscn: PackedScene = preload("res://objects/exit.tscn")

var zones: Dictionary
var current_zone: Node2D
var level_dir: String

var player: Node2D
var main_camera: Camera2D

# Called on game start
func _ready() -> void:
	# Starting zone
	current_zone = $"/root/scene"
	print_debug(current_zone.zone_name)
	zones[current_zone.zone_name] = current_zone
	
	# Level directory
	level_dir = get_tree().current_scene.filename.get_base_dir()
	print_debug("level dir = ", level_dir)
	
	# Add player
	player = player_tscn.instance()
	current_zone.add_child(player)
	player.position = current_zone.get_node("player_spawn").position
	
	# Add main camera
	main_camera = main_camera_tscn.instance()
	current_zone.add_child(main_camera)

func goto_zone(zone_name: String, into: bool, move_to: Node2D):
	var last_zone_name = current_zone.zone_name
	
	# Add new zone to dictionary
	if not zones.has(zone_name):
		print_debug("loading new zone: ", level_dir + "/%s.tscn" % zone_name)
		var new_zone = load(level_dir + "/%s.tscn" % zone_name).instance()
		new_zone.depth = current_zone.depth + 1
		new_zone.zone_name = zone_name
		zones[zone_name] = new_zone
	
	# Make goto zone the current one
	current_zone.remove_child(player)
	current_zone.remove_child(main_camera)
	get_tree().get_root().remove_child(current_zone)
	current_zone = zones[zone_name]
	get_tree().get_root().add_child(current_zone)
	current_zone.add_child(player)
	current_zone.add_child(main_camera)
	
	if into:
		player.position = current_zone.get_node("player_spawn").position
	else:
		player.position = move_to.position
		
	# Add exit
	if into and not current_zone.has_node("exit"):
		var exit = exit_tscn.instance()
		exit.exit_to = last_zone_name
		exit.position = current_zone.get_node("player_spawn").position
		exit.exit_node = move_to
		current_zone.add_child(exit)
	
	print_debug("now inside ", zone_name)

func goto_level(level_num: int):
	pass

func _process(delta):
	pass
