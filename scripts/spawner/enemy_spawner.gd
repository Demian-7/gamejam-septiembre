class_name EnemySpawner
extends Node

@export var spawns: Array[SpawnInfo] = []
@export var player: Player

@export var time: float = 0

signal changetime(time: float)

func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns: Array[SpawnInfo] = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy: PackedScene = i.enemy
				var counter: int  = 0
				while counter < i.enemy_num:
					var enemy_spawn: Enemy = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					add_sibling(enemy_spawn)
					counter += 1
	emit_signal("changetime", time)

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
