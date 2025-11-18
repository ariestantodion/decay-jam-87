extends Node2D

@onready var enemy_hp = get_node("Area2D/EnemyHealth")
@onready var enemy_attack = get_node("Area2D/EnemyAttack")
@onready var enemy_sprite = get_node("Area2D/EnemySprite")
@export var max_hp: float = 100
@export var attack_time = 10
var mouse_over: bool = false
var damage_per_second = 30

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

func _ready():
	enemy_attack.max_value = attack_time
	enemy_hp.max_value = max_hp
	enemy_hp.value = max_hp
		
func _process(delta):
	if enemy_attack.value < enemy_attack.max_value:
		enemy_attack.value += 1 * delta
	else:
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
