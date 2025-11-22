extends Node

var player_hp = 100
var damage_effect_active = false
var poison_cooldown_active = false
var stun_cooldown_active = false

func take_damage(damage):
	player_hp -= damage
	
