#Battle.gd
extends Node2D

@onready var player_hp_bar    = $PlayerHP
@onready var scene_animations = $CanvasLayer/Animations
@onready var number_of_enemies = get_tree().get_nodes_in_group("Enemies").size()

@onready var poison_cooldown = $PoisonCooldown
@onready var stun_cooldown   = $StunCooldown

@export var poison_cooldown_time = 200
@export var stun_cooldown_time   = 200

var battle_over := false
var cursor = load("res://Assets/Placeholder Art/cursor.png")


# -----------------------------------------------------
# RETURN TO OVERWORLD
# -----------------------------------------------------
func return_to_overworld():
	var path := SpawnManager.last_overworld_scene
	if path == "":
		path = "res://scenes/overworld/Level1.tscn"  # fallback

	get_tree().change_scene_to_file(path)


# -----------------------------------------------------
# EXIT BATTLE
# -----------------------------------------------------
func exit_battle():
	battle_over = true
	
	scene_animations.play("fade_out")
	await scene_animations.animation_finished
	
	return_to_overworld()


# -----------------------------------------------------
# READY
# -----------------------------------------------------
func _ready():
	scene_animations.play("fade_in")
	Input.set_custom_mouse_cursor(cursor, 0, Vector2(16, 16))

	# Sync UI with battle HP
	player_hp_bar.value = BattleManager.player_hp

	# Cooldowns
	poison_cooldown.max_value = poison_cooldown_time
	stun_cooldown.max_value   = stun_cooldown_time
	poison_cooldown.value     = poison_cooldown_time
	stun_cooldown.value       = stun_cooldown_time


# -----------------------------------------------------
# PROCESS
# -----------------------------------------------------
func _process(delta):
	# Update player HP bar
	player_hp_bar.value = BattleManager.player_hp

	# Recount enemies dynamically
	number_of_enemies = get_tree().get_nodes_in_group("Enemies").size()

	# POISON COOLDOWN LOGIC
	if poison_cooldown.value < poison_cooldown.max_value:
		BattleManager.poison_cooldown = true
	else:
		BattleManager.poison_cooldown = false

	if BattleManager.poison_active:
		poison_cooldown.value = 0
	else:
		run_poison_cooldown()


	# STUN COOLDOWN LOGIC
	if stun_cooldown.value < stun_cooldown.max_value:
		BattleManager.stun_cooldown = true
	else:
		BattleManager.stun_cooldown = false

	if BattleManager.stun_active:
		stun_cooldown.value = 0
	else:
		run_stun_cooldown()


	# DAMAGE FLASH
	if BattleManager.damage_effect_active:
		scene_animations.play("PlayerDamageEffect")
		BattleManager.damage_effect_active = false


	# BATTLE END
	if number_of_enemies == 0 and not battle_over:
		exit_battle()
	elif BattleManager.player_hp <= 0 and not battle_over:
		exit_battle()


# -----------------------------------------------------
# COOLDOWN HELPERS
# -----------------------------------------------------
func run_poison_cooldown():
	poison_cooldown.value += 1
	await get_tree().create_timer(1.0).timeout

func run_stun_cooldown():
	stun_cooldown.value += 1
	await get_tree().create_timer(1.0).timeout
