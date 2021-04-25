extends Item

export(String) var to_zone

func _ready():
	$sprite_manager.set_frame($"/root/Controller".sack_count)
	$"/root/Controller".sack_count += 1

func picked_up():
	.picked_up()
	print_debug("sack picked up")

func interacted_with(item: Item):
	.interacted_with(item)
	controller.goto_zone_animate(to_zone, true, self)
