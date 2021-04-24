extends Item

export(String) var to_zone

func picked_up():
	.picked_up()
	print_debug("sack picked up")

func interacted_with(item: Item):
	.interacted_with(item)
	controller.goto_zone_animate(to_zone, true, self)
