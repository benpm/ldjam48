extends Item

var exit_tscn: PackedScene = preload("res://objects/exit.tscn")

func picked_up():
	.picked_up()
	print_debug("sack picked up")

func interacted_with():
	.interacted_with()
	var player = $"/root/scene/player"
	player.get_parent().remove_child(player)
	get_tree().change_scene("res://scenes/level_1.tscn")
	var exit = exit_tscn.instance()
	$"/root/scene".add_child(exit_tscn.instance())
	
