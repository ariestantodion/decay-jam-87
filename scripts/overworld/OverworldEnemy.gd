#OverworldEnemy.gd
extends Node2D

@onready var visuals := $Visuals
@onready var aggro_area := $AggroArea
@onready var hitbox := $Collision

var player: Node2D = null
var chasing: bool = false
var move_speed: float = 70.0

func _on_aggro_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		chasing = true
	
		var cam: Camera2D = body.get_node("Camera2D")
		if cam:
			cam.shake(0.3, 4.0) # magnitude, speed

func _on_aggro_area_body_exited(body):
	if body == player:
		chasing = false
		player = null

func _physics_process(delta: float) -> void:
	if chasing and player:
		var direction := (player.global_position - global_position).normalized()
		global_position += direction * move_speed * delta

func _start_battle():
	# Optional safety: Prevent multiple triggers
	set_physics_process(false)

	# TODO: Add fade transition later
	
	#DPManager.add_dp(1)   # TESTING DP ONLY
	get_tree().change_scene_to_file("res://scenes/battle/Battle_Test.tscn")

func _on_collision_body_entered(body):
	if body.is_in_group("player"):
		_start_battle()
