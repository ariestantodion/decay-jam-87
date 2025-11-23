#PlantEnemy.gd
extends CharacterBody2D

@onready var enemy_hp = $EnemyHealth
@onready var enemy_attack = $EnemyAttack
@onready var enemy_sprite = $EnemySprite
@onready var animation = $AnimationPlayer
@onready var original_sprite_color: Color = enemy_sprite.self_modulate
@export var DP_value = 10
@export var enemy_damage = 25
@export var min_attack_delay = 3
@export var max_attack_delay = 5
@export var max_hp: float = 100
@export var attack_charge_time = 10
@export var move_speed = 150
@export var move_direction = 1
var stunned_hp_style = StyleBoxFlat.new()
var poison_hp_style = StyleBoxFlat.new()
var normal_hp_style = StyleBoxFlat.new()
var normal_attack_style = StyleBoxFlat.new()
var mouse_over: bool = false
var damage_per_second = 30
var poison_damage = 10
var is_stunned = false
var stun_delay = 2
var delay_active = false
var initial_attack_complete = false

#Detects when cursor is over enemy
func area_2d_entered():
	mouse_over = true
	while mouse_over:
		enemy_sprite.self_modulate.a = 0.5
		await get_tree().create_timer(0.1).timeout
		enemy_sprite.self_modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout

#Detects when cursor leaves enemy
func area_2d_exited():
	mouse_over = false

#Changes left/right motion of enemy, controlled by Timer node
func change_move_direction():
	move_direction *= -1
	velocity.x = move_speed * move_direction

func initial_attack_delay():
	enemy_attack.value = 0
	await get_tree().create_timer(randf_range(min_attack_delay, max_attack_delay)).timeout
	initial_attack_complete = true

#Decreases player hp and pauses until next attack begins
func deal_damage():
	BattleManager.take_damage(enemy_damage)
	BattleManager.damage_effect_active = true
	enemy_attack.value = 0
	delay_active = true
	await get_tree().create_timer(randf_range(min_attack_delay, max_attack_delay)).timeout
	delay_active = false
	
#Removes enemy from Battle, gives player DP
func die():
	velocity.x = 0 * move_direction
	animation.play("enemy_fade_out")
	await get_tree().create_timer(0.7).timeout
	DPManager.add_dp(DP_value)
	remove_from_group("Enemies")
	queue_free()

#Decreases enemy_hp by poison_damage 5 times
func poisoned():
	BattleManager.poison_active = true
	enemy_hp.add_theme_stylebox_override("fill", poison_hp_style)
	enemy_sprite.self_modulate = Color(0, 1.0, 0)
	for i in range(5):
		enemy_hp.value -= poison_damage
		if enemy_hp.value/max_hp <= 0.66 and enemy_hp.value/max_hp > 0.33:
			enemy_sprite.frame = 1
		if  enemy_hp.value/max_hp <= 0.33:
			enemy_sprite.frame = 2
		if enemy_hp.value <= 0:
			die()
		await get_tree().create_timer(1.0).timeout
	enemy_hp.add_theme_stylebox_override("fill", normal_hp_style)
	enemy_sprite.self_modulate = original_sprite_color
	BattleManager.poison_active = false

#Resets enemy_attack to 0 and pauses attack charge for length of stun_delay
#Also prevents enemy movement for the duration of the stun
func stunned():
	BattleManager.stun_active = true
	is_stunned = true
	enemy_sprite.self_modulate = Color(0.6, 0.6, 0.6)
	enemy_attack.value = 0
	velocity.x = 0 * move_direction
	$Timer.paused = true
	for i in range(stun_delay * 2):
		enemy_attack.value = enemy_attack.max_value - 0.1
		enemy_attack.add_theme_stylebox_override("fill", stunned_hp_style)
		await get_tree().create_timer(0.25).timeout
		enemy_attack.value = 0
		await get_tree().create_timer(0.25).timeout
	is_stunned = false
	enemy_attack.add_theme_stylebox_override("fill", normal_attack_style)
	velocity.x = move_speed * move_direction
	enemy_sprite.self_modulate = original_sprite_color
	$Timer.paused = false
	BattleManager.stun_active = false

func _ready():
	add_to_group("Enemies")
	$Timer.start()
	velocity.x = move_speed * move_direction
	
	poison_hp_style.bg_color = Color("00ab2f")
	poison_hp_style.border_color = Color("000000")
	poison_hp_style.border_width_bottom = 2
	poison_hp_style.border_width_top = 2
	poison_hp_style.border_width_left = 2
	poison_hp_style.border_width_right = 2
	poison_hp_style.corner_radius_bottom_left = 5
	poison_hp_style.corner_radius_bottom_right = 5
	poison_hp_style.corner_radius_top_left = 5
	poison_hp_style.corner_radius_top_right = 5
	
	stunned_hp_style.bg_color = Color("e6cf77")
	stunned_hp_style.border_color = Color("000000")
	stunned_hp_style.border_width_bottom = 2
	stunned_hp_style.border_width_top = 2
	stunned_hp_style.border_width_left = 2
	stunned_hp_style.border_width_right = 2
	stunned_hp_style.corner_radius_bottom_left = 5
	stunned_hp_style.corner_radius_bottom_right = 5
	stunned_hp_style.corner_radius_top_left = 5
	stunned_hp_style.corner_radius_top_right = 5
	
	normal_attack_style.bg_color = Color("00aacf")
	normal_attack_style.border_color = Color("000000")
	normal_attack_style.border_width_bottom = 2
	normal_attack_style.border_width_top = 2
	normal_attack_style.border_width_left = 2
	normal_attack_style.border_width_right = 2
	normal_attack_style.corner_radius_bottom_left = 5
	normal_attack_style.corner_radius_bottom_right = 5
	normal_attack_style.corner_radius_top_left = 5
	normal_attack_style.corner_radius_top_right = 5
	
	normal_hp_style.bg_color = Color("ff2c22")
	normal_hp_style.border_color = Color("000000")
	normal_hp_style.border_width_bottom = 2
	normal_hp_style.border_width_top = 2
	normal_hp_style.border_width_left = 2
	normal_hp_style.border_width_right = 2
	normal_hp_style.corner_radius_bottom_left = 5
	normal_hp_style.corner_radius_bottom_right = 5
	normal_hp_style.corner_radius_top_left = 5
	normal_hp_style.corner_radius_top_right = 5
	
	enemy_hp.add_theme_stylebox_override("fill", normal_hp_style)
	enemy_attack.max_value = attack_charge_time
	enemy_hp.max_value = max_hp
	enemy_hp.value = max_hp
	
func _process(delta):
	#move_and_slide()
	if not initial_attack_complete:
		initial_attack_delay()
	if not is_stunned and enemy_attack.value < enemy_attack.max_value and not delay_active and BattleManager.player_hp > 0:
		enemy_attack.value += 1 * delta
	elif enemy_attack.value >= enemy_attack.max_value:
		deal_damage()
	if mouse_over:
		enemy_hp.value -= damage_per_second * delta
		if enemy_hp.value/max_hp <= 0.66 and enemy_hp.value/max_hp > 0.33:
			enemy_sprite.frame = 1
		if  enemy_hp.value/max_hp <= 0.33:
			enemy_sprite.frame = 2
		if enemy_hp.value <= 0:
			die()
	if mouse_over and Input.is_key_pressed(KEY_Z) and not BattleManager.poison_cooldown:
		poisoned()
	if mouse_over and Input.is_key_pressed(KEY_X) and not BattleManager.stun_cooldown:
		stunned()
