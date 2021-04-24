extends Interactable

var exit_to: String
var exit_node: Node2D

func interacted_with():
	.interacted_with()
	controller.goto_zone_animate(exit_to, false, exit_node)
