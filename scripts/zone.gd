extends Node2D

class_name Zone

var depth: int = 0
var zone_name: String = "" setget set_zone_name, get_zone_name

func _enter_tree():
	if get_zone_name() == "start":
		$"/root/Controller".start_level()

func _ready():
	$"/root/Controller".ready_level()

func get_zone_name() -> String:
	if not zone_name:
		var path = get_tree().current_scene.filename
		zone_name = path.get_file().get_basename()
		return zone_name
	else:
		return zone_name

func set_zone_name(name: String) -> void:
	zone_name = name
