extends Node2D

@onready var player_hp = $PlayerHP
@onready var scene_animations = $CanvasLayer/Animations
@onready var number_of_enemies = get_tree().get_nodes_in_group("Enemies").size()
@onready var poison_cooldown = $PoisonCooldown
@onready var stun_cooldown = $StunCooldown
@export var poison_cooldown_time = 5
@export var stun_cooldown_time = 5
var battle_over = false
var cursor = load("res://Assets/Placeholder Art/cursor.png")

#Ends Battle scene
func exit_battle():
	battle_over = true
	scene_animations.play("fade_out")

#func damage_effect():
	#scene_animations.play("PlayerDamageEffect")

func run_poison_cooldown():
	poison_cooldown.value = 0
	await get_tree().create_timer(1.0).timeout
	while poison_cooldown.value < poison_cooldown.max_value:
		poison_cooldown.value += 1
		await get_tree().create_timer(1.0).timeout
	BattleManager.poison_cooldown_active = false
	
func run_stun_cooldown():
	stun_cooldown.value = 0
	await get_tree().create_timer(1.0).timeout
	while stun_cooldown.value < stun_cooldown.max_value:
		stun_cooldown.value += 1
		await get_tree().create_timer(1.0).timeout
	BattleManager.stun_cooldown_active = false

func _ready():
	scene_animations.play("fade_in")
	Input.set_custom_mouse_cursor(cursor, 0, Vector2(16, 16))
	player_hp.value = BattleManager.player_hp
	poison_cooldown.max_value = poison_cooldown_time
	stun_cooldown.max_value = stun_cooldown_time
	poison_cooldown.value = poison_cooldown_time
	stun_cooldown.value = stun_cooldown_time
	
func _process(delta):
	player_hp.value = BattleManager.player_hp
	number_of_enemies = get_tree().get_nodes_in_group("Enemies").size()
	#if BattleManager.poison_cooldown_active:
		#run_poison_cooldown()
	#if BattleManager.stun_cooldown_active:
		#run_stun_cooldown()
	if BattleManager.damage_effect_active == true:
		scene_animations.play("PlayerDamageEffect")
		BattleManager.damage_effect_active = false
	if number_of_enemies == 0 and battle_over == false:
		exit_battle()
	elif player_hp.value <= 0 and battle_over == false:
		exit_battle()
