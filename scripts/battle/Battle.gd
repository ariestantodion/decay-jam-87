extends Node2D

@onready var player_hp = $PlayerHP
var cursor = load("res://Assets/Placeholder Art/cursor.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor, 0, Vector2(16, 16))
	player_hp.value = 100
