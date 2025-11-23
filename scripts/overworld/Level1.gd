#Level1.gd
extends Node2D

func _ready():
	# If we just came back from battle
	if SpawnManager.last_player_position != Vector2.ZERO:
		$Player.global_position = SpawnManager.last_player_position

		# Remove defeated enemy
		if SpawnManager.enemy_to_remove != "":
			var enemy = get_node_or_null(SpawnManager.enemy_to_remove)
			if enemy:
				enemy.queue_free()

		# Reset memory
		SpawnManager.last_player_position = Vector2.ZERO
		SpawnManager.enemy_to_remove = ""
