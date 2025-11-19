#Player.gd
extends CharacterBody2D

@export var move_speed: float = 150.0

# Bobbing parameters
@export var bob_height: float = 4.0
@export var bob_speed: float = 2.0

var bob_time: float = 0.0
@onready var visuals := $Visuals

func _ready() -> void:
	DPManager.add_dp(100)

	print("Before:", AbilityManager.get_level("damage"))
	AbilityManager.upgrade("damage")
	print("After:", AbilityManager.get_level("damage"))

func _physics_process(delta: float) -> void:
	# Movement
	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * move_speed
	move_and_slide()

	# Bobbing ONLY the visual child, not the player root
	bob_time += delta * bob_speed
	var offset := sin(bob_time) * bob_height
	visuals.position.y = offset
