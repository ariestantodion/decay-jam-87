#BattleManager.gd
extends Node

var player_hp = 100
var damage_effect_active = false
var poison_active = false
var stun_active = false
var poison_cooldown = false
var stun_cooldown = false

func take_damage(damage: int):
	player_hp = max(player_hp - damage, 0)
	PlayerHealthManager.take_damage(damage)
