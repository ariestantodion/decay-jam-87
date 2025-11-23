#PoisonShrine.gd
extends Node2D

@onready var area := $InteractionArea
@onready var prompt := $E_Prompt
@onready var cutscene := $CutscenePlayer
@onready var visuals := $ShrineVisuals

var player_in_range := false
var activated := false

var prompt_base_pos: Vector2


func _ready():
	# Hide prompt until player enters range
	prompt.visible = false

	# Remember editor placement for bobbing
	prompt_base_pos = prompt.position

	# Connect area signals
	area.body_entered.connect(_on_area_entered)
	area.body_exited.connect(_on_area_exited)


func _process(delta):
	if player_in_range and not activated:
		# Floating E icon animation
		var bob := sin(Time.get_ticks_msec() / 200.0) * 3
		prompt.position = prompt_base_pos + Vector2(0, bob)

		# Action key (E mapped to ui_accept)
		if Input.is_action_just_pressed("ui_accept"):
			activate_shrine()


func _on_area_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		if not activated:
			prompt.visible = true


func _on_area_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		prompt.visible = false


func activate_shrine():
	activated = true
	prompt.visible = false

	# Trigger cutscene sequence
	if has_node("CutscenePlayer"):
		cutscene.play_cutscene()
