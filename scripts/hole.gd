extends Interactable

export(String) var to_zone

func _enter_tree():
	self.does_something = true

func interacted_with(item: Item):
	.interacted_with(item)
	controller.goto_zone_animate(to_zone, null, Controller.Trans.into_hole)
