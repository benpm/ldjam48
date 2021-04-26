extends Node2D

onready var initpos := position

func _process(_delta):
    position.y = initpos.y + sin((OS.get_ticks_msec() / 1000.0)) * 4.0