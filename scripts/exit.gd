extends Interactable

var exit_to: String
var exit_node: Node2D

func _ready():
	self.can_interact_holding = false

func interacted_with(item: Item):
	.interacted_with(item)
	controller.goto_zone_animate(exit_to, exit_node, Controller.Trans.outof_container)

func can_interact(item) -> bool:
	return item == null