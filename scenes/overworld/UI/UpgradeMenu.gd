#UpgradeMenu
extends Control

# Each lane is accessed by node paths
@onready var damage_lane = $Panel/DamageLane
@onready var poison_lane = $Panel/PoisonLane
@onready var stun_lane = $Panel/StunLane
@onready var range_lane = $Panel/RangeLane
#@onready var instakill_lane = $Panel/InstakillLane  # If you add one

func _ready():
	# Initialize bars according to current ability levels
	_init_lane(damage_lane, "damage")
	_init_lane(poison_lane, "poison")
	_init_lane(stun_lane, "stun")
	_init_lane(range_lane, "range")
#	_init_lane(instakill_lane, "instakill")

	# Connect arrows
	_connect_lane(damage_lane, "damage")
	_connect_lane(poison_lane, "poison")
	_connect_lane(stun_lane, "stun")
	_connect_lane(range_lane, "range")
#	_connect_lane(instakill_lane, "instakill")


func _init_lane(lane: Node, ability: String):
	var bar: ProgressBar = lane.get_node("Bar")
	bar.max_value = AbilityManager.get_max_level(ability)
	bar.value = AbilityManager.get_level(ability)

	# Gray-out locked lanes
	if !AbilityManager.is_unlocked(ability):
		lane.modulate = Color(0.5, 0.5, 0.5)
	else:
		lane.modulate = Color(1,1,1)


func _connect_lane(lane: Node, ability: String):
	var up = lane.get_node("UpArrow")
	var down = lane.get_node("DownArrow")
	var bar = lane.get_node("Bar")

	up.gui_input.connect(func(event):
		if event is InputEventMouseMotion:
			_upgrade(ability, bar)
	)

	down.gui_input.connect(func(event):
		if event is InputEventMouseMotion:
			_downgrade(ability, bar)
	)


func _upgrade(ability: String, bar: ProgressBar):
	if !AbilityManager.is_unlocked(ability):
		return

	if AbilityManager.upgrade(ability):
		bar.value = AbilityManager.get_level(ability)


func _downgrade(ability: String, bar: ProgressBar):
	if !AbilityManager.is_unlocked(ability):
		return

	if AbilityManager.downgrade(ability):
		bar.value = AbilityManager.get_level(ability)
