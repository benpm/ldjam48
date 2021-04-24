extends KinematicBody2D

var vel: Vector2
var speed: float = 2
var on_interactable: Interactable = null
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
	if Input.is_action_pressed("right"):
		vel.x = speed
	if Input.is_action_pressed("up"):
		vel.y = -speed
	if Input.is_action_pressed("down"):
		vel.y = speed
	
	anim.current_animation = "walk_down"
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
			if Input.is_action_just_pressed("interact"):
				# Interact with object
				on_interactable.interacted_with()

func _physics_process(delta):
	vel = move_and_slide(vel * 60) / 60
	for i in get_slide_count():
		var col = get_slide_collision(i)

func _on_interactable(area: Area2D) -> void:
	print(area.name, area.get_type())
	if area != held_item:
		on_interactable = area
	print_debug(area.name)

func _off_interactable(area: Area2D) -> void:
	on_interactable = null

