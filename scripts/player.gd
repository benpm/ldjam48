extends KinematicBody2D

var vel: Vector2
var facing: Vector2
var speed: float = 2.5
var on_interactable: Array
var on_item: Array
var on_trigger: Array
var held_item: Item = null
var frozen: bool = false

onready var shadow_scale: Vector2 = $shadow.scale

onready var anim: AnimationPlayer = $animator
onready var pickup_area: Area2D = $pickup_area

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if frozen:
		vel = Vector2(0, 0)
		return
	
	vel = Vector2(0, 0)
	if Input.is_action_pressed("left"):
		vel.x = -speed
		anim.play("walk_left")
		facing = Vector2(-1, 0)
	elif Input.is_action_pressed("right"):
		vel.x = speed
		anim.play("walk_right")
		facing = Vector2(1, 0)
	if Input.is_action_pressed("up"):
		vel.y = -speed
		anim.play("walk_up")
		facing = Vector2(0, -1)
	elif Input.is_action_pressed("down"):
		vel.y = speed
		anim.play("walk_down")
		facing = Vector2(0, 1)
	
	if vel.x != 0.0 and vel.y != 0.0:
		vel = vel.normalized() * speed
	
	if vel.length() == 0.0:
		match (anim.current_animation):
			"walk_left": anim.play("idle_left")
			"walk_right": anim.play("idle_right")
			"walk_up": anim.play("idle_up")
			"walk_down": anim.play("idle_down")
	
	anim.playback_speed = vel.length()

	# Move pickup area
	pickup_area.rotation = atan2(facing.y, facing.x) - PI / 2.0

	# Picking up / setting down items
	if Input.is_action_just_pressed("pick up"):
		if held_item == null and on_item.size() > 0:
			# Pick up item
			held_item = on_item.pop_front()
			held_item.position = Vector2(0, -20)
			held_item.picked_up()
			held_item.get_parent().remove_child(held_item)
			add_child(held_item)
			var item_shadow = held_item.get_node("sprite_manager/shadow")
			item_shadow.hide()
			$shadow.scale = item_shadow.scale
			on_interactable.erase(held_item)
		elif held_item:
			# Set down item
			held_item.position = pickup_area.get_node("collider").global_position
			held_item.put_down()
			remove_child(held_item)
			get_parent().add_child(held_item)
			held_item.get_node("sprite_manager/shadow").show()
			$shadow.scale = shadow_scale
			held_item = null
	
	if on_interactable.size() > 0 and Input.is_action_just_pressed("interact"):
		on_interactable.front().interacted_with(held_item)
	
	
	if held_item and on_interactable.size() > 0 and on_interactable.front().does_something:
		if on_interactable.front().can_interact(held_item):
			$hints.animation = "hint_interact"
		else:
			$hints.animation = "hint_nointeract"
		if not $hints.visible: $hints.show()
	elif on_item.size() > 0 and on_item.front() == on_interactable.front() and on_interactable.front().does_something:
		if held_item:
			if on_interactable.front().can_interact(held_item):
				$hints.animation = "hint_interact"
		else:
			$hints.animation = "hint_interact"
		if not $hints.visible: $hints.show()
	elif not held_item and on_item.size() > 0:
		$hints.animation = "hint_pickup"
		if not $hints.visible: $hints.show()
	elif not held_item and on_interactable.size() > 0:
		$hints.animation = "hint_interact"
		if not $hints.visible: $hints.show()
	elif $hints.visible:
		$hints.hide()
	
	if held_item:
		match (anim.current_animation):
			"walk_left", "idle_left": anim.play("walk_hold_left")
			"walk_right", "idle_right": anim.play("walk_hold_right")
			"walk_up", "idle_up": anim.play("walk_hold_up")
			"walk_down", "idle_down": anim.play("walk_hold_down")
	else:
		match (anim.current_animation):
			"walk_hold_left": anim.play("walk_left")
			"walk_hold_right": anim.play("walk_right")
			"walk_hold_up": anim.play("walk_up")
			"walk_hold_down": anim.play("walk_down")


func used_held_item():
	remove_child(held_item)
	held_item = null
	print_debug("used item")

func _physics_process(delta):
	vel = move_and_slide(vel * 60) / 60

func _on_intersect_area(area: Area2D) -> void:
	if area.has_method("get_type"):
		if area != held_item:
			var color = Color.white
			if area.is_type("Interactable") and not (area in on_interactable):
				if on_interactable.size() > 0:
					color = Color(0.5, 0.5, 0.5)
				on_interactable.append(area)
				if not area.can_interact(held_item):
					color = Color.red
				area.get_node("sprite_manager").outline = color
			if area.is_type("Item") and not (area in on_item):
				if on_item.size() > 0:
					color = Color(0.5, 0.5, 0.5)
				on_item.append(area)
				area.get_node("sprite_manager").outline = color
			if area.is_type("Trigger") and not (area in on_trigger):
				on_trigger.append(area)
				area.trigger(self)

func _off_intersect_area(area: Area2D) -> void:
	if area.has_method("get_type"):
		if area != held_item:
			if area.is_type("Interactable") and area in on_interactable:
				area.get_node("sprite_manager").outline = Color.transparent
				on_interactable.erase(area)
			if area.is_type("Item") and area in on_item:
				area.get_node("sprite_manager").outline = Color.transparent
				on_item.erase(area)
			if area.is_type("Trigger") and area in on_trigger:
				on_trigger.erase(area)
				area.untrigger(self)

