# The game controller singleton

extends Node2D

# Packed objects
const _player: PackedScene = preload("res://objects/player.tscn")
const _main_camera: PackedScene = preload("res://objects/main_camera.tscn")
const _exit: PackedScene = preload("res://objects/exit.tscn")

var zones: Dictionary		# Mapping from local zone names to zone scene nodes
var current_zone: Node2D	# Currently entered zone, this should be active scene node
var zone_clone: Node2D		# Clone of the next zone for animation purposes
var level_dir: String		# Resource path to the directory which is the current level
var level_controller: Node	# The level controller node, if there is one
var level_name: String		# The of the current level, also the name of the current level directory

var player: Node2D			# The player node
var main_camera: Camera2D	# The main camera node

# Types of transitions
enum Trans {
	into_container, outof_container, into_hole
}

var goto_duration := 0.5
var goto_campos: Vector2
var goto_zonename: String
var goto_to_node: Node2D
var goto_from_node: Node2D
var goto_trans: int

var sack_count := 0			# Global sack count for the purpose of auto coloring

onready var zone_tween := Tween.new()
onready var music := AudioStreamPlayer.new()
onready var soundFX := Node2D.new()

var sounds: Dictionary

# Called on game start
func _ready() -> void:

	# Load all the audio
	var audioDir = Directory.new()
	audioDir.open("res://audio/")
	audioDir.list_dir_begin(true, true)
	var fname = audioDir.get_next()
	while fname:
		if fname.get_extension() == "ogg":
			var streamName: String = fname.get_basename()
			var stream: AudioStreamOGGVorbis = load("res://audio/" + fname)
			stream.loop = false
			var streamPlayer = AudioStreamPlayer2D.new()
			streamPlayer.name = streamName
			streamPlayer.stream = stream
			streamPlayer.autoplay = false
			streamPlayer.bus = "FX"
			streamPlayer.attenuation = 2.0
			sounds[streamName] = streamPlayer
			soundFX.add_child(streamPlayer)
		fname = audioDir.get_next()
	
	sounds["walk"].stream.loop = true

	zone_tween.repeat = false
	add_child(zone_tween)

	music.stream = load("res://audio/music.mp3")
	music.stream.loop = true
	music.play()
	music.volume_db = -7.0
	add_child(music)

	add_child(soundFX)

	# start_level called by Zone on tree enter
	zone_tween.connect("tween_all_completed", self, "_goto_zone_sig")

func play_sound(name: String, pos = null):
	sounds[name].stop()
	if pos != null:
		sounds[name].position = pos
	sounds[name].play()

func sound_playing(name: String, playing: bool, pos = null):
	if sounds[name].playing != playing:
		sounds[name].playing = playing
	if pos != null:
		sounds[name].position = pos

# Called when transition to new zone is complete
func _goto_zone_sig():
	goto_zone(goto_zonename, goto_from_node, goto_to_node, goto_trans)

# Called when entering a new level
func start_level():
	if current_zone != null:
		return
	
	# Starting zone
	current_zone = $"/root/scene"
	zones[current_zone.zone_name] = current_zone
	
	# Level directory
	level_dir = get_tree().current_scene.filename.get_base_dir()
	level_name = level_dir.get_file()
	
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

func goto_zone_animate(zone_name: String, from_node: Node2D, to_node: Node2D, trans: int):
	if not player.frozen:
		goto_zonename = zone_name
		goto_to_node = to_node
		goto_from_node = from_node
		goto_trans = trans
		player.frozen = true
		player.get_node("wall_mask").enabled = false
		main_camera.transition_mask.show()
		main_camera.transition_mask.scale = Vector2(5.0, 5.0)
		if trans != Trans.into_hole:
			zone_clone = clone_zone(zone_name)
		match (trans):
			Trans.into_container: # Target is the container node
				assert(from_node)
				player.z_index = 10
				# Player scales down, camera zooms in
				zone_tween.interpolate_property(player, "scale", Vector2.ONE, Vector2(1.0/16.0, 1.0/16.0),
					goto_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
				zone_tween.interpolate_property(player, "position", null, from_node.position,
					goto_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
				zone_tween.interpolate_method(main_camera, "scale_mask", 5.0, 0.1,
					goto_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
				zone_tween.interpolate_property(main_camera, "zoom", Vector2.ONE, Vector2(1.0/16.0, 1.0/16.0),
					goto_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
				main_camera.target = from_node
				zone_clone.scale = Vector2(1.0/16.0, 1.0/16.0)
				zone_clone.z_index = 10
				zone_clone.position = -zone_clone.get_node("player_spawn").position * zone_clone.scale
				from_node.add_child(zone_clone)
			Trans.into_hole: # Target is null - use player spawn
				zone_tween.interpolate_method(main_camera, "scale_mask", 5.0, 0.5,
					goto_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			Trans.outof_container: # Target is exit node
				assert(from_node)
				assert(to_node)
				# Player scales up, camera zooms out
				zone_tween.interpolate_property(player, "scale", Vector2.ONE, Vector2(16.0, 16.0),
					goto_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
				zone_tween.interpolate_method(main_camera, "scale_mask", 1.0, 100.0,
					goto_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
				zone_tween.interpolate_property(main_camera, "zoom", Vector2.ONE, Vector2(16.0, 16.0),
					goto_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
				zone_clone.scale = Vector2(16.0, 16.0)
				zone_clone.position = -to_node.position * zone_clone.scale + from_node.position
				zone_clone.z_index = -10
				current_zone.z_index = 10
				player.z_index = 20
				from_node.add_child(zone_clone)
		zone_tween.start()

func load_zone(zone_name: String) -> Zone:
	# Add new zone to dictionary
	if not zones.has(zone_name):
		var new_zone = load(level_dir + "/%s.tscn" % zone_name).instance()
		new_zone.depth = current_zone.depth + 1
		new_zone.zone_name = zone_name
		zones[zone_name] = new_zone
	var zone = zones[zone_name]
	set_owner_rec(zone, zone)
	return zone
# Recursively set's owner of obj to _owner
func set_owner_rec(obj: Node, _owner: Node):
	obj.owner = _owner
	for child in obj.get_children():
		set_owner_rec(child, _owner)
# Clone a zone by name
func clone_zone(zone_name: String) -> Zone:
	var orig_zone: Zone = load_zone(zone_name)
	var zone = orig_zone.duplicate(DUPLICATE_USE_INSTANCING);
	if zone.get_node("player"):
		zone.remove_child(zone.get_node("player"))
	if zone.get_node("main_camera"):
		zone.remove_child(zone.get_node("main_camera"))
	set_owner_rec(zone, zone)
	zone.clone = true
	return zone

func goto_zone(zone_name: String, from_node: Node2D, to_node: Node2D, trans: int):
	var last_zone_name = current_zone.zone_name

	# Remove cloned zone
	if zone_clone:
		zone_clone.get_parent().remove_child(zone_clone)
		zone_clone = null
	
	# Next zone
	var next_zone = load_zone(zone_name)
	next_zone.scale = Vector2.ONE
	next_zone.position = Vector2.ZERO
	next_zone.z_index = 0
	
	player.get_node("wall_mask").enabled = true
	zone_tween.remove_all()
	player.scale = Vector2.ONE
	player.z_index = 0
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
		player.position = to_node.position
	main_camera.target = player
	main_camera.position = player.position
	main_camera.zoom = Vector2.ONE
	main_camera.transition_mask.hide()

	# Add player and camera to newly entered zone, setting ownership so they remain attached
	current_zone.add_child(player)
	current_zone.add_child(main_camera)
		
	# Add exit
	if trans == Trans.into_hole or trans == Trans.into_container:
		if not current_zone.has_node("exit"):
			current_zone.add_child(_exit.instance())
		var exit = current_zone.get_node("exit")
		exit.exit_to = last_zone_name
		exit.position = current_zone.get_node("player_spawn").position
		assert(from_node)
		exit.exit_node = from_node
	
	# Ensure correct ownership
	set_owner_rec(current_zone, current_zone)
	
	# Notify level controller
	if level_controller != null:
		level_controller.zone_change()
	
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

