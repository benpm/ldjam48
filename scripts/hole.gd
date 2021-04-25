extends Interactable

export(String) var to_zone

func interacted_with(item: Item):
	.interacted_with(item)
	controller.goto_zone_animate(to_zone, true, null)
