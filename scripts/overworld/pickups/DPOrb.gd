#DPOrb.gd
extends Node2D

var target_position: Vector2
var homing := false
var speed := 350.0

func _ready():
	# Burst outward randomly upon spawning
	var random_dir = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	position += random_dir * randf_range(10, 35)

	# Tiny delay before homing
	await get_tree().create_timer(randf_range(0.15, 0.28)).timeout
	homing = true

func _process(delta):
	if homing:
		var dir = (target_position - global_position).normalized()
		global_position += dir * speed * delta

		# When close to the target → give DP, disappear
		if global_position.distance_to(target_position) < 12:
			DPManager.add_dp(1)
			queue_free()
