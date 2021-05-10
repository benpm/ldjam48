# The game controller singleton

extends Node2D

# Packed objects
const _player: PackedScene = preload("res://objects/player.tscn")
const _main_camera: PackedScene = preload("res://objects/main_camera.tscn")
const _exit: PackedScene = preload("res://objects/exit.tscn")

var zones: Dictionary		# Mapping from local zone names to zone scene nodes
var current_zone: Node2D	# Currently entered zone, this should be active scene node
var level_dir: String		# Resource path to the directory which is the current level
var level_controller: Node	# The level controller node, if there is one
var level_name: String		# The of the current level, also the name of the current level directory

var player: Node2D			# The player node
var main_camera: Camera2D	# The main camera node

# Types of transitions
enum Trans {
	into_container, outof_container, into_hole
}

var goto_duration := 0.75
var goto_campos: Vector2
var goto_zonename: String
var goto_target: Node2D
var goto_trans: int

var sack_count := 0			# Global sack count for the purpose of auto coloring

onready var tween := Tween.new()
onready var goto_timer := Timer.new()
onready var audio := AudioStreamPlayer.new()
onready var walkaudio := AudioStreamPlayer.new()
onready var music := AudioStreamPlayer.new()

var sounds: Dictionary

# Called on game start
func _ready() -> void:
	tween.repeat = false
	goto_timer.one_shot = true
	audio.autoplay = false
	audio.volume_db = -12.0
	# Load all the audio
	var audioDir = Directory.new()
	audioDir.open("res://audio/")
	audioDir.list_dir_begin(true, true)
	var fname = audioDir.get_next()
	while fname:
		if fname.get_extension() == "ogg":
			print_debug(fname)
			sounds[fname.get_basename()] = load("res://audio/" + fname)
			sounds[fname.get_basename()].loop = false
		fname = audioDir.get_next()
	
	add_child(tween)
	add_child(goto_timer)
	add_child(audio)
	add_child(walkaudio)
	walkaudio.autoplay = false
	walkaudio.stream = sounds["walk"]
	walkaudio.stream.loop = true

	walkaudio.play()
	
	music.stream = load("res://audio/music.mp3")
	music.stream.loop = true
	music.play()
	music.volume_db = - 7.0
	add_child(music)

	# start_level called by Zone on tree enter
	goto_timer.connect("timeout", self, "_goto_zone_sig")

func play_sound(name: String):
	audio.stop()
	audio.stream = sounds[name]
	audio.play()

func _goto_zone_sig():
	goto_zone(goto_zonename, goto_target, goto_trans)

func start_level():
	if current_zone != null:
		return
	
	# Starting zone
	current_zone = $"/root/scene"
	print_debug(current_zone.zone_name)
	zones[current_zone.zone_name] = current_zone
	
	# Level directory
	level_dir = get_tree().current_scene.filename.get_base_dir()
	level_name = level_dir.get_file()
	print_debug("level dir = %s, level name = %s" % [level_dir, level_name])
	
	# Add player
	player = _player.instance()
	current_zone.add_child(player)
	player.position = current_zone.get_node("player_spawn").position
	
	# Add main camera
	main_camera = _main_camera.instance()
	current_zone.add_child(main_camera)

func ready_level():
	assert(current_zone != null, "start from the start scene!")
	
	# Level controller
	if current_zone.has_node("level_controller"):
		level_controller = current_zone.get_node("level_controller")
		level_controller.get_parent().remove_child(level_controller)
		self.add_child(level_controller)
		print_debug("ready level")

func goto_zone_animate(zone_name: String, target: Node2D, trans: int):
	if not player.frozen:
		goto_zonename = zone_name
		goto_target = target
		goto_trans = trans
		player.frozen = true
		player.get_node("wall_mask").enabled = false
		main_camera.transition_mask.show()
		main_camera.transition_mask.scale = Vector2(5.0, 5.0)
		print_debug(zone_name, target, trans)
		var nextzone = load_zone(zone_name)
		match (trans):
			Trans.into_container: # Target is the container node
				assert(target)
				if zone_name == current_zone.zone_name:
					tween.interpolate_method(main_camera, "scale_mask", 5.0, 0.5,
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
				else:
					player.z_index = 10
					tween.interpolate_property(player, "scale", Vector2.ONE, Vector2(1.0/16.0, 1.0/16.0),
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
					tween.interpolate_property(player, "position", null, target.position,
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
					tween.interpolate_method(main_camera, "scale_mask", 5.0, 0.1,
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
					tween.interpolate_property(main_camera, "zoom", Vector2.ONE, Vector2(1.0/16.0, 1.0/16.0),
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
					main_camera.target = target
					nextzone.scale = Vector2(1.0/16.0, 1.0/16.0)
					nextzone.z_index = 10
					nextzone.position = -nextzone.get_node("player_spawn").position * nextzone.scale
					target.add_child(nextzone)
			Trans.into_hole: # Target is null - use player spawn
				tween.interpolate_method(main_camera, "scale_mask", 5.0, 0.5,
					goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
			Trans.outof_container: # Target is exit node
				assert(target)
				if zone_name == current_zone.zone_name:
					tween.interpolate_method(main_camera, "scale_mask", 5.0, 0.5,
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
				else:
					tween.interpolate_property(player, "scale", Vector2.ONE, Vector2(16.0, 16.0),
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
					tween.interpolate_property(player, "position", null, target.position,
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
					tween.interpolate_method(main_camera, "scale_mask", 1.0, 100.0,
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
					tween.interpolate_property(main_camera, "zoom", Vector2.ONE, Vector2(16.0, 16.0),
						goto_duration, tween.TRANS_QUAD, tween.EASE_IN_OUT)
					main_camera.target = target
					nextzone.scale = Vector2(16.0, 16.0)
					nextzone.position = -target.position * nextzone.scale
					current_zone.add_child(nextzone)
		tween.start()
		goto_timer.start(goto_duration)

func load_zone(zone_name: String) -> Zone:
	# Add new zone to dictionary
	if not zones.has(zone_name):
		print_debug("loading new zone: ", level_dir + "/%s.tscn" % zone_name)
		var new_zone = load(level_dir + "/%s.tscn" % zone_name).instance()
		new_zone.depth = current_zone.depth + 1
		new_zone.zone_name = zone_name
		zones[zone_name] = new_zone
	return zones[zone_name]

func goto_zone(zone_name: String, target: Node2D, trans: int):
	assert(zones.has(zone_name))
	var last_zone_name = current_zone.zone_name
	print_debug(zone_name)

	# Remove last zone from temporary loc in tree
	var next_zone = zones[zone_name]
	if next_zone.get_parent():
		next_zone.get_parent().remove_child(next_zone)
	next_zone.scale = Vector2.ONE
	next_zone.position = Vector2.ZERO
	next_zone.z_index = 0
	
	player.get_node("wall_mask").enabled = true
	tween.remove_all()
	player.scale = Vector2.ONE
	main_camera.zoom = Vector2.ONE
	main_camera.scale_mask(1.0)
	
	# Make goto zone the current one
	current_zone.remove_child(player)
	current_zone.remove_child(main_camera)
	get_tree().get_root().remove_child(current_zone)
	current_zone = next_zone
	get_tree().get_root().add_child(current_zone)
	
	if trans == Trans.into_hole or trans == Trans.into_container:
		player.position = current_zone.get_node("player_spawn").position
	else:
		player.position = target.position
	main_camera.target = player
	main_camera.position = player.position
	main_camera.zoom = Vector2.ONE
	main_camera.transition_mask.hide()

	current_zone.add_child(player)
	current_zone.add_child(main_camera)
		
	# Add exit
	if trans == Trans.into_hole or trans == Trans.into_container:
		if not current_zone.has_node("exit"):
			current_zone.add_child(_exit.instance())
		var exit = current_zone.get_node("exit")
		exit.exit_to = last_zone_name
		exit.position = current_zone.get_node("player_spawn").position
		assert(target)
		exit.exit_node = target
	
	# Notify level controller
	if level_controller != null:
		level_controller.zone_change()
	
	print_debug("now inside ", zone_name)
	
	player.frozen = false

func goto_level(name: String):
	self.level_name = name
	if level_controller != null:
		level_controller.get_parent().remove_child(level_controller)
		level_controller = null
	current_zone.get_parent().remove_child(current_zone)
	current_zone = null
	sack_count = 0
	zones.clear()
	var err = get_tree().change_scene("res://levels/%s/start.tscn" % level_name)
	assert(err == OK)

func _input(event):
	if event.is_action_pressed("restart"):
		goto_level(level_name)

