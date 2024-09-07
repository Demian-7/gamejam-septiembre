class_name Room
extends Node2D

@export var max_round: int
@export var time_per_round: int
@export var round_time: int

@export var spawn: Array[SpawnInfo]
@export var max_enemy_counter: int = 100

@export_category("DEBUG")
@export var debug: bool

var _current_round: int = 1
var _current_enemy_counter: int
var _current_time: int = 1
var _enemy_array: Array[Enemy]

var player: Player
var camera: Camera2D
var spawn_timer: Timer


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
	
	
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1
	add_child(spawn_timer)
	spawn_timer.timeout.connect(spawn_enemies)
	
	spawn_timer.start()

func _physics_process(delta: float) -> void:
	for enemy: Enemy in _enemy_array:
		enemy.velocity = (player.global_position - enemy.global_position).normalized() * enemy.speed
		if enemy.velocity.normalized().x > 0:
			enemy.scale.x = 1
			
		else:
			enemy.scale.x = -1
		enemy.move_and_slide()

func spawn_enemies() -> void:
	for info: SpawnInfo in spawn:
		if _current_round in info.round_spawn:
			if _current_time >= info.time_start and _current_time <= info.time_end:
				if _current_enemy_counter < max_enemy_counter:
					var counter: int = 0
					while counter < info.enemy_interval:
						var enemy_spawn: Enemy = info.enemy.instantiate()
						enemy_spawn.global_position = _get_random_position()
						add_child(enemy_spawn, true)
						_enemy_array.append(enemy_spawn)
						_current_enemy_counter += 1
						counter += 1
	
	_current_time += 1

func _get_random_position() -> Vector2:
	var vpr := get_viewport_rect().size * randf_range(1.1, 1.4)
	vpr /= 3
	var top_left := Vector2(player.global_position.x - vpr.x / 2, player.global_position.y - vpr.y / 2)
	var top_right := Vector2(player.global_position.x + vpr.x / 2, player.global_position.y - vpr.y / 2)
	var bottom_left := Vector2(player.global_position.x - vpr.x / 2, player.global_position.y + vpr.y / 2)
	var bottom_right := Vector2(player.global_position.x + vpr.x / 2, player.global_position.y + vpr.y / 2)
	var pos_side: String = ["up", "down", "right", "left"].pick_random()
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
	
	var x_spawn := randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn := randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)
