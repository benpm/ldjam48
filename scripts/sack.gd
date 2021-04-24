extends Item

export(String) var to_zone

func picked_up():
	.picked_up()
	print_debug("sack picked up")

func interacted_with():
	.interacted_with()
	controller.goto_zone_animate(to_zone, true, self)
