#OverworldEnemy.gd
extends Node2D

@onready var visuals := $Visuals
@onready var aggro_area := $AggroArea
@onready var hitbox := $Collision

@export var move_speed: float = 70.0
@export var battle_scene_path: String = "res://scenes/battle/PlantBattle.tscn"

var player: Node2D = null
var chasing: bool = false
var triggered: bool = false   # prevents double triggers

func _on_aggro_area_body_entered(body):
	if triggered:
		return

	if body.is_in_group("player"):
		player = body
		chasing = true

		# Camera shake (optional)
		var cam: Camera2D = body.get_node("Camera2D")
		if cam:
			cam.shake(0.3, 4.0)  # magnitude, speed


func _on_aggro_area_body_exited(body):
	if body == player:
		chasing = false
		player = null


func _physics_process(delta: float) -> void:
	if triggered:
		return

	if chasing and player:
		var direction := (player.global_position - global_position).normalized()
		global_position += direction * move_speed * delta


func _on_collision_body_entered(body):
	if triggered:
		return

	if body.is_in_group("player"):
		_start_battle(body)


func _start_battle(player_ref):
	triggered = true

	# Freeze player
	player_ref.set_physics_process(false)

	# 🟢 Remember overworld state globally
	SpawnManager.last_overworld_scene = get_tree().current_scene.scene_file_path
	SpawnManager.last_player_position = player_ref.global_position
	SpawnManager.enemy_to_remove = name  # use node name as ID

	print("Saving return info: ", SpawnManager.last_overworld_scene)

	# 🔥 Go to battle
	get_tree().change_scene_to_file(battle_scene_path)
