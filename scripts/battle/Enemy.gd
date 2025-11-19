extends Node2D

@onready var enemy_hp = get_node("Area2D/EnemyHealth")
@onready var enemy_attack = get_node("Area2D/EnemyAttack")
@onready var enemy_sprite = get_node("Area2D/EnemySprite")
@export var max_hp: float = 100
@export var attack_time = 10
var stunned_hp_style = StyleBoxFlat.new()
var poison_hp_style = StyleBoxFlat.new()
var normal_hp_style = StyleBoxFlat.new()
var normal_attack_style = StyleBoxFlat.new()
var mouse_over: bool = false
var damage_per_second = 30
var poison_damage = 1
var is_stunned = false
var stun_delay = 2

#Detects when cursor is over enemy
func area_2d_entered():
	mouse_over = true

#Detects when cursor leaves enemy
func area_2d_exited():
	mouse_over = false

#Removes enemy from Battle, gives player DP
func die():
	#Add signal that gives player DP
	queue_free()

#Decreases enemy_hp by poison_damage 5 times
func poisoned():
	enemy_hp.add_theme_stylebox_override("fill", poison_hp_style)
	for i in range(5):
		enemy_hp.value -= poison_damage
		await get_tree().create_timer(1.0).timeout
	enemy_hp.add_theme_stylebox_override("fill", normal_hp_style)

#Resets enemy_attack to 0 and pauses attack charge for length of stun_delay
func stunned():
	is_stunned = true
	enemy_attack.value = 0
	for i in range(stun_delay * 2):
		enemy_attack.value = enemy_attack.max_value - 0.1
		enemy_attack.add_theme_stylebox_override("fill", stunned_hp_style)
		await get_tree().create_timer(0.25).timeout
		enemy_attack.value = 0
		await get_tree().create_timer(0.25).timeout
	is_stunned = false
	enemy_attack.add_theme_stylebox_override("fill", normal_attack_style)

func _ready():
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
	enemy_attack.max_value = attack_time
	enemy_hp.max_value = max_hp
	enemy_hp.value = max_hp
		
func _process(delta):
	if not is_stunned and enemy_attack.value < enemy_attack.max_value:
		enemy_attack.value += 1 * delta
	elif enemy_attack.value >= enemy_attack.max_value:
		enemy_attack.value = 0
		#Add code that damages player
	if mouse_over:
		enemy_hp.value -= damage_per_second * delta
		if enemy_hp.value/max_hp <= 0.5 and enemy_hp.value/max_hp > 0.25:
			enemy_sprite.frame = 1
		if  enemy_hp.value/max_hp <= 0.25:
			enemy_sprite.frame = 2
		if enemy_hp.value <= 0:
			die()
	if mouse_over and Input.is_key_pressed(KEY_Z):
		poisoned()
	if mouse_over and Input.is_key_pressed(KEY_X):
		stunned()
