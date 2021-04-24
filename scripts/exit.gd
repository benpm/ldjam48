extends Interactable

var exit_to: PackedScene = null

func interacted_with():
	assert(exit_to != null)
	var player = $"/root/scene/player"
	player.get_parent().remove_child(player)
	get_tree().change_scene_to(exit_to)
