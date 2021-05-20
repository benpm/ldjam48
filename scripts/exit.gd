extends Interactable

var exit_to: String
var exit_node: Node2D

func _enter_tree():
	self.does_something = true

func _ready():
	self.can_interact_holding = false

func interacted_with(item: Item):
	.interacted_with(item)
	if item == null:
		assert(exit_node)
		Controller.play_sound("outof_bag")
		Controller.goto_zone_animate(exit_to, exit_node, Controller.Trans.outof_container)

func can_interact(item) -> bool:
	return item == null