#PoisonLane.gd
extends Control

@export var ability_name: String = "poison"

@onready var icon: TextureRect = $Icon
@onready var up_arrow: TextureRect = $UpArrow
@onready var down_arrow: TextureRect = $DownArrow
@onready var bar: ProgressBar = $Bar

var max_level := 0

func _ready():
	max_level = AbilityManager.get_max_level(ability_name)
	bar.max_value = max_level
	bar.value = AbilityManager.get_level(ability_name)
	_update_lock_state()


func _process(delta):
	_update_fill()
	_handle_upgrade_hover()
	_handle_downgrade_hover()


func _update_fill():
	bar.value = AbilityManager.get_level(ability_name)


func _handle_upgrade_hover():
	if not AbilityManager.is_unlocked(ability_name):
		return

	if _mouse_over(up_arrow) and Input.is_action_just_pressed("ui_accept"):
		if AbilityManager.upgrade(ability_name):
			bar.value = AbilityManager.get_level(ability_name)


func _handle_downgrade_hover():
	if not AbilityManager.is_unlocked(ability_name):
		return

	if _mouse_over(down_arrow) and Input.is_action_just_pressed("ui_accept"):
		if AbilityManager.downgrade(ability_name):
			bar.value = AbilityManager.get_level(ability_name)


func _mouse_over(node: Control) -> bool:
	var rect = node.get_global_rect()
	var mpos = get_viewport().get_mouse_position()
	return rect.has_point(mpos)


func _update_lock_state():
	if AbilityManager.is_unlocked(ability_name):
		icon.self_modulate = Color(1,1,1,1)
		up_arrow.self_modulate = Color(1,1,1,1)
		down_arrow.self_modulate = Color(1,1,1,1)
	else:
		icon.self_modulate = Color(0.3,0.3,0.3,1)
		up_arrow.self_modulate = Color(0.3,0.3,0.3,1)
		down_arrow.self_modulate = Color(0.3,0.3,0.3,1)
