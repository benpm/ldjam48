extends Node2D

const player_tscn = preload("res://objects/player.tscn")
const main_camera_tscn = preload("res://objects/main_camera.tscn")
const exit_tscn: PackedScene = preload("res://objects/exit.tscn")

var zones: Dictionary
var current_zone: Node2D
var level_dir: String

var player: Node2D
var main_camera: Camera2D

var fade_amnt := 0.0
var goto_timer := 0.0
var goto_speed := 0.25
var goto_campos: Vector2
var goto_zonename: String
var goto_into: bool
var goto_moveto: Node2D

# Called on game start
func _ready() -> void:
	# start_level called by Zone on tree enter
	pass

func start_level():
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

func goto_zone_animate(zone_name: String, into: bool, move_to: Node2D):
	if goto_timer <= 0.0:
		goto_timer = 0.35
		goto_zonename = zone_name
		goto_into = into
		goto_moveto = move_to

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
	main_camera.position = player.position
		
	# Add exit
	if into:
		if not current_zone.has_node("exit"):
			current_zone.add_child(exit_tscn.instance())
		var exit = current_zone.get_node("exit")
		exit.exit_to = last_zone_name
		exit.position = current_zone.get_node("player_spawn").position
		exit.exit_node = move_to
	
	print_debug("now inside ", zone_name)

func goto_level(level_name: String):
	current_zone.get_parent().remove_child(current_zone)
	current_zone = null
	zones.clear()
	var err = get_tree().change_scene("res://levels/%s/start.tscn" % level_name)
	assert(err == OK)

func _process(delta):
	if goto_timer > 0.0:
		goto_timer -= delta
		fade_amnt = lerp(fade_amnt, 1.0, goto_speed)
		main_camera.fade(fade_amnt)
		if goto_timer <= 0.0:
			goto_timer = 0.0
			fade_amnt = 0.0
			goto_zone(goto_zonename, goto_into, goto_moveto)
			main_camera.fade(0.0)
