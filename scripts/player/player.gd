class_name Player
extends CharacterBody2D

signal reloading

const BULLET := preload("res://nodes/bullet.tscn")

@export var speed: float = 500
@export var shoot_cd: float = 0.2
@export var health : float = 100

#Player movement
var target_direction := Vector2.ZERO

#Shooting and reloading

var cooldown_timer: Timer
var can_shoot := true
var max_ammo := 4
var current_ammo := 4

func _ready() -> void:
	#Timer para el cooldown del disparo
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = shoot_cd
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(on_timer_timeout)
	add_child(cooldown_timer, true)
	

func _physics_process(delta: float) -> void:
	# Vector de movimiento
	target_direction = Input.get_vector("player_move_left", "player_move_right", "player_move_up", "player_move_down")

	velocity = target_direction * speed
	move_and_slide()
	
	#Disparar
	if Input.is_action_just_pressed("player_shoot"):
		if current_ammo > 0 && can_shoot:
			shoot()
	
	#Recargar
	if Input.is_action_just_pressed("player_reload"):
		if current_ammo < max_ammo:
			reload()
	

# Creacion de las balas y manejo del cooldown
func shoot() -> void:
	var bullet_instance:= BULLET.instantiate() as Bullet
	bullet_instance.position = global_position
	bullet_instance.direction = global_position.direction_to(get_global_mouse_position()).normalized()
	
	add_sibling(bullet_instance)
	
	current_ammo -= 1
	can_shoot = false
	cooldown_timer.start()

func on_timer_timeout() -> void:
	can_shoot = true

func reload() -> void:
	current_ammo = max_ammo
	emit_signal("reloading")

func takeDamage(dmg: float) -> void:
	health -= dmg
	
	if health<= 0:
		queue_free()
