extends ZoneTeleport

func _enter_tree():
	self.does_something = true

func interacted_with(item: Item):
	.interacted_with(item)
	Controller.goto_zone_animate(to_zone, self, null, Controller.Trans.into_hole)
