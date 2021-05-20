extends Interactable

export(bool) var locked = true

export(String) var to_level

func _enter_tree():
	self.does_something = true

func _ready():
	assert(ResourceLoader.exists("res://levels/%s/start.tscn" % to_level))
	if locked:
		$sprite_manager.animation = "door_locked"
	else:
		$sprite_manager.animation = "door_unlocked"

func interacted_with(item):
	.interacted_with(item)
	if can_interact(item):
		if locked:
			locked = false
			$sprite_manager.animation = "door_unlocked"
			Controller.play_sound("unlock", position)
			item.get_parent().used_held_item()
		else:
			Controller.play_sound("door_open", position)
			Controller.goto_level(to_level)

func can_interact(item) -> bool:
	return not locked or (item != null and item.name == "key")