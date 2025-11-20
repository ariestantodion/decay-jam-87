#DPOrb
extends Node2D

var target_position: Vector2
var homing := false
var speed := 400.0

func _ready():
	# Random outward burst force
	var random_vec = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	position += random_vec * randf_range(10, 30)
	
	# Delay before homing
	await get_tree().create_timer(0.2).timeout
	homing = true

func _process(delta):
	if homing:
		var direction = (target_position - global_position).normalized()
		global_position += direction * speed * delta
		
		# If close to UI target → award DP and disappear
		if global_position.distance_to(target_position) < 10:
			DPManager.add_dp(1)
			queue_free()
