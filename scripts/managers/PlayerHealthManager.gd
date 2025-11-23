#PlayerHealthManager
extends Node

var max_hp := 100
var hp := 100

signal hp_changed(new_hp)

func reset():
	hp = max_hp
	emit_signal("hp_changed", hp)

func take_damage(amount: int):
	hp = clamp(hp - amount, 0, max_hp)
	emit_signal("hp_changed", hp)

func heal(amount: int):
	hp = clamp(hp + amount, 0, max_hp)
	emit_signal("hp_changed", hp)
