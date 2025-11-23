#Chest.gd
extends Area2D

# Reward range
@export var dp_reward_min: int = 150
@export var dp_reward_max: int = 300

# Orb scene reference
@export var dp_orb_scene: PackedScene

# Chest state
var player_in_range := false
var opened := false

# Node references
@onready var closed_sprite := $Closed
@onready var open_sprite := $Open
@onready var prompt := $E_Prompt

# Base prompt position for floating
var prompt_base_pos: Vector2


func _ready():
	open_sprite.visible = false
	prompt.visible = false
	prompt_base_pos = prompt.position


func _process(delta):
	if player_in_range and not opened:
		# Floating E icon
		var bob := sin(Time.get_ticks_msec() / 200.0) * 3
		prompt.position = prompt_base_pos + Vector2(0, bob)

		# Press E
		if Input.is_action_just_pressed("ui_accept"):
			open_chest()


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		if not opened:
			prompt.visible = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		prompt.visible = false


func open_chest():
	opened = true
	prompt.visible = false

	# Swap sprites
	closed_sprite.visible = false
	open_sprite.visible = true

	# DP reward
	var total_orbs := randi_range(dp_reward_min, dp_reward_max)

	spawn_dp_orbs(total_orbs)


func spawn_dp_orbs(amount: int):
	# --- GET THE DP ORB TARGET BY GROUP ---
	var list := get_tree().get_nodes_in_group("dp_orb_target")
	if list.is_empty():
		push_warning("No DPOrbTarget found in group 'dp_orb_target'")
		return

	var ui_target: Control = list[0]
	var viewport := get_viewport()

	for i in range(amount):
		var orb = dp_orb_scene.instantiate()
		orb.global_position = global_position

		# SCREEN position of the UI target
		var screen_pos: Vector2 = ui_target.get_global_rect().get_center()

		# Convert SCREEN → WORLD using viewport transform
		var canvas_xform: Transform2D = viewport.get_canvas_transform()
		var world_pos: Vector2 = canvas_xform.affine_inverse() * screen_pos

		orb.target_position = world_pos
		get_tree().current_scene.add_child(orb)
