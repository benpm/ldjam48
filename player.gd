extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel: Vector2
var speed: float = 2
var on_item: Area2D = null
var picked_item: Area2D = null
onready var anim: AnimatedSprite = $sprite

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
	
	anim.speed_scale = vel.length()
	
	if on_item != null and Input.action_press("pickup") and on_item == null:
		on_item.get_parent().remove_child(on_item)
		add_child(on_item)
		picked_item = on_item

func _physics_process(delta):
	vel = move_and_slide(vel * 60) / 60
	for i in get_slide_count():
		var col = get_slide_collision(i)

func _on_pickup_area_area_entered(area: Area2D) -> void:
	on_item = area
	print(area.name)

func _on_pickup_area_area_exited(area: Area2D) -> void:
	on_item = null
