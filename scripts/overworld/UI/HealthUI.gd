#HealthUI.gd
extends Control

@onready var bar = $HealthBar

func _ready():
	bar.max_value = PlayerHealthManager.max_hp
	bar.value = PlayerHealthManager.hp

func _process(delta):
	bar.value = PlayerHealthManager.hp
