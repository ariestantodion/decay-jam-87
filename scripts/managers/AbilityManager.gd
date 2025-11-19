#AbilityManager.gd
extends Node

# Ability data table
var abilities := {
	"damage": {
		"level": 0,
		"max_level": 5,
		"cost": 10,
		"unlocked": true
	},
	"poison": {
		"level": 0,
		"max_level": 5,
		"cost": 8,
		"unlocked": true
	},
	"stun": {
		"level": 0,
		"max_level": 5,
		"cost": 12,
		"unlocked": true
	},
	"range": {
		"level": 0,
		"max_level": 4,
		"cost": 15,
		"unlocked": false
	},
	"instakill": {
		"level": 0,
		"max_level": 3,
		"cost": 50,
		"unlocked": false
	}
}

# -------------------------
# PUBLIC API
# -------------------------

func get_level(name: String) -> int:
	return abilities[name]["level"]

func get_max_level(name: String) -> int:
	return abilities[name]["max_level"]

func is_unlocked(name: String) -> bool:
	return abilities[name]["unlocked"]

func get_cost(name: String) -> int:
	return abilities[name]["cost"]


# Attempt to upgrade (returns true/false)
func upgrade(name: String) -> bool:
	var a = abilities[name]

	if not a["unlocked"]:
		return false

	if a["level"] >= a["max_level"]:
		return false

	var cost = a["cost"]

	# Spend DP → only succeed if you have enough
	if DPManager.spend_dp(cost):
		a["level"] += 1
		return true

	return false


# Attempt to downgrade (refund)
func downgrade(name: String) -> bool:
	var a = abilities[name]

	if a["level"] <= 0:
		return false

	# Refund half the cost (tunable)
	var refund := int(a["cost"] * 0.5)
	DPManager.add_dp(refund)

	a["level"] -= 1
	return true


# Unlock ability (e.g. when entering a new biome)
func unlock(name: String) -> void:
	if abilities.has(name):
		abilities[name]["unlocked"] = true
