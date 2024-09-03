class_name EnemySpawner
extends Node

@export var spawn: Array[SpawnInfo] = []
@export var player: Player

@export var time: float = 0

signal changetime(time: float)

func _on_timer_timeout() -> void:
	for info: SpawnInfo in spawn:
		if _current_round in info.round_spawn:
			if _current_time >= info.time_start and _current_time <= info.time_end:
				if _current_enemy_counter < max_enemy_counter:
					var counter = 0
					while counter < info.enemy_interval:
						var enemy_spawn = info.enemy.instantiate()
						enemy_spawn.entity_death.connect(_clear_enemies.bind(enemy_spawn))
						enemy_spawn.global_position = _get_random_position()
						add_child(enemy_spawn, true)
						_enemy_array.append(enemy_spawn)
						_current_enemy_counter += 1
						counter += 1

func get_random_position() -> Vector2:
	var vpr := get_viewport().get_visible_rect().size * randf_range(1.1, 1.4)
	var top_left := Vector2(player.global_position.x - vpr.x / 2, player.global_position.y - vpr.y / 2)
	var top_right := Vector2(player.global_position.x + vpr.x / 2, player.global_position.y - vpr.y / 2)
	var bottom_left := Vector2(player.global_position.x - vpr.x / 2, player.global_position.y + vpr.y / 2)
	var bottom_right := Vector2(player.global_position.x + vpr.x / 2, player.global_position.y + vpr.y / 2)
	var pos_side: PackedStringArray = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 := Vector2.ZERO
	var spawn_pos2 := Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn: float = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn: float = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)
