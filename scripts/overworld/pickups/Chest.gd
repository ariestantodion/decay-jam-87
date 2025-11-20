#Chest.gd
extends Area2D

@export var dp_reward_min: int = 150
@export var dp_reward_max: int = 300
@export var orb_count: int = 80  # total orbs to spawn (each orb = +1 DP)

var player_in_range := false
@onready var closed_sprite := $Closed
@onready var open_sprite := $Open
@onready var prompt := $E_Prompt

func _ready():
	open_sprite.visible = false
	prompt.visible = false

func _process(delta):
	if player_in_range:
		# Floating E prompt animation
		prompt.position.y = sin(Time.get_ticks_msec() / 200.0) * 3 - 20
		
		if Input.is_action_just_pressed("ui_accept"):  # E by default
			open_chest()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		prompt.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		prompt.visible = false

func open_chest():
	# Prevent re-opening
	set_process(false)
	prompt.visible = false
	closed_sprite.visible = false
	open_sprite.visible = true
	
	# Burst DP orbs
	var spawn_count = randi_range(dp_reward_min, dp_reward_max)
	spawn_dp_orbs(spawn_count)
