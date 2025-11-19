#CameraFollow.gd
extends Camera2D

@export var bob_height: float = 2.0
@export var bob_speed: float = 1.0

var t := 0.0
var shake_amount := 0.0
var shake_speed := 0.0

func _process(delta: float) -> void:
	t += delta * bob_speed
	offset.y = sin(t) * bob_height

	# Apply shake
	if shake_amount > 0:
		offset.x = randf_range(-shake_amount, shake_amount)
		offset.y = sin(t) * bob_height + randf_range(-shake_amount, shake_amount)
		shake_amount = lerp(shake_amount, 0.0, delta * shake_speed)

func shake(amount: float, speed: float) -> void:
	shake_amount = amount
	shake_speed = speed
