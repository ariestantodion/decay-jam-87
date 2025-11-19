#DPManager.gd
extends Node

var dp: int = 0

func add_dp(amount: int) -> void:
	dp += amount
	print("DP: ", dp)

func spend_dp(amount: int) -> bool:
	if dp >= amount:
		dp -= amount
		print("DP spent: ", amount, " | Remaining: ", dp)
		return true
	else:
		print("Not enough DP!")
		return false
