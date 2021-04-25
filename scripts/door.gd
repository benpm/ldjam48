extends Interactable

var locked = true

export(String) var to_level

func _ready():
	assert(ResourceLoader.exists("res://levels/%s/start.tscn" % to_level))

func interacted_with(item):
	.interacted_with(item)
	print_debug(item)
	if item != null and item.name == "key" and locked:
		locked = false
		$sprite_manager/animator.current_animation = "door_unlocked"
		item.get_parent().used_held_item()
	elif item == null and not locked:
		controller.goto_level(to_level)
