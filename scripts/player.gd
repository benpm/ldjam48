extends KinematicBody2D

var vel: Vector2
var speed: float = 2.5
var on_interactable: Interactable = null
var on_trigger: Trigger = null
var held_item: Item = null

onready var anim: AnimationPlayer = $animator

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vel = Vector2(0, 0)
	if Input.is_action_pressed("left"):
		vel.x = -speed
		anim.play("walk_left")
	elif Input.is_action_pressed("right"):
		vel.x = speed
		anim.play("walk_right")
	if Input.is_action_pressed("up"):
		vel.y = -speed
		anim.play("walk_up")
	elif Input.is_action_pressed("down"):
		vel.y = speed
		anim.play("walk_down")
	
	if vel.x != 0.0 and vel.y != 0.0:
		vel = vel.normalized() * speed
	
	if vel.length() == 0.0:
		match (anim.current_animation):
			"walk_left": anim.play("walk_left")
			"walk_right": anim.play("walk_right")
			"walk_up": anim.play("walk_up")
			"walk_down": anim.play("walk_down")
	
	anim.playback_speed = vel.length()
	
	if on_interactable == null:
		if held_item != null and Input.is_action_just_pressed("pick up"):
			# Set down item
			held_item.position = position
			held_item.put_down()
			remove_child(held_item)
			get_parent().add_child(held_item)
			held_item = null
	elif on_interactable != null:
		if on_interactable.is_type("Item") and held_item == null and Input.is_action_just_pressed("pick up"):
			# Pick up item
			held_item = on_interactable
			held_item.position = Vector2(0, -8)
			held_item.picked_up()
			held_item.get_parent().remove_child(held_item)
			add_child(held_item)
			on_interactable = null
		else:
			if Input.is_action_just_pressed("interact") and (held_item == null or on_interactable.can_interact_holding):
				# Interact with object
				on_interactable.interacted_with(held_item)

func used_held_item():
	remove_child(held_item)
	held_item = null
	print_debug("used item")

func _physics_process(delta):
	vel = move_and_slide(vel * 60) / 60
	for i in get_slide_count():
		var col = get_slide_collision(i)

func _on_intersect_area(area: Area2D) -> void:
	if area.has_method("get_type"):
		print_debug("player step on ", area.name, area.get_type())
		if area != held_item:
			match area.get_type():
				"Interactable", "Item":
					on_interactable = area
				"Trigger":
					on_trigger = area
					area.trigger(self)

func _off_intersect_area(area: Area2D) -> void:
	if area.has_method("get_type"):
		print_debug("player step off ", area.name, area.get_type())
		if area != held_item:
			match area.get_type():
				"Interactable", "Item":
					on_interactable = null
				"Trigger":
					on_trigger = null
					area.untrigger(self)

