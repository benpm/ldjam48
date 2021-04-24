extends Interactable

var exit_to: Level = null

func interacted_with():
	var player = self.container_level.get_node("player")
	var camera = self.container_level.get_node("main_camera")
	
	# Move player and camera to inner level
	player.get_parent().remove_child(player)
	camera.get_parent().remove_child(camera)
	exit_to.add_child(player)
	exit_to.add_child(camera)
	
	# Set player position
	player.position = self.container_level.get_parent().position
	
	# Scale animation
	self.controller.goto_level(exit_to)
	
	self.container_level.get_parent().remove_child(self.container_level)
