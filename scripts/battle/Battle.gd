extends Node2D

@onready var player_hp = $PlayerHP
@onready var scene_transition = $CanvasLayer/Transition
@onready var number_of_enemies = get_tree().get_nodes_in_group("Enemies").size()
var battle_over = false
var cursor = load("res://Assets/Placeholder Art/cursor.png")

func exit_battle():
	battle_over = true
	scene_transition.play("fade_out")

func _ready():
	scene_transition.play("fade_in")
	Input.set_custom_mouse_cursor(cursor, 0, Vector2(16, 16))
	player_hp.value = BattleManager.player_hp
	

func _process(delta):
	player_hp.value = BattleManager.player_hp
	number_of_enemies = get_tree().get_nodes_in_group("Enemies").size()
	if number_of_enemies == 0 and battle_over == false:
		exit_battle()
	elif player_hp.value <= 0 and battle_over == false:
		exit_battle()
