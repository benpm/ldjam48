extends Item

export(String) var to_zone

func _enter_tree():
	self.does_something = true

func _ready():
	$sprite_manager.set_frame($"/root/Controller".sack_count)
	$"/root/Controller".sack_count += 1

func picked_up():
	.picked_up()
	print_debug("sack picked up")

func interacted_with(item: Item):
	.interacted_with(item)
	Controller.goto_zone_animate(to_zone, self, Controller.Trans.into_container)
	Controller.play_sound("into_bag")
