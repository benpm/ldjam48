extends Item

const exit_tscn: PackedScene = preload("res://objects/exit.tscn")

export(PackedScene) var create_scene
var inner_level: Level = null

func _ready():
	assert(create_scene != null)

func picked_up():
	.picked_up()
	print_debug("sack picked up")

func interacted_with():
	.interacted_with()
	var player = self.container_level.get_node("player")
	var camera = self.container_level.get_node("main_camera")
	
	# Create inner level if none exists
	if inner_level == null:
		inner_level = create_scene.instance()
		inner_level.position = Vector2(0, 0)
		inner_level.scale = Vector2(1.0 / 16.0, 1.0 / 16.0)
		inner_level.z_index = 1
		inner_level.depth = container_level.depth + 1
		var exit = exit_tscn.instance()
		exit.exit_to = container_level
		exit.position = inner_level.get_node("player_spawn").position
		inner_level.add_child(exit)
	add_child(inner_level)
		
	# Move player and camera to inner level
	player.get_parent().remove_child(player)
	camera.get_parent().remove_child(camera)
	inner_level.add_child(player)
	inner_level.add_child(camera)
	
	# Set player position
	player.position = inner_level.get_node("player_spawn").position
	
	# Scale animation
	self.controller.goto_level(inner_level)
