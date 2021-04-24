extends Interactable

var locked = true

func interacted_with(item):
	.interacted_with(item)
	if item.name == "key":
		locked = false
		$sprite_manager/animator.current_animation = "door_unlocked"
		item.get_parent().remove_child(item)
