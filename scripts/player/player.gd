class_name Player
extends CharacterBody2D

@export var speed : float = 500

#Player movement
var target_direction := Vector2.ZERO

#Shooting and reloading
var bullet := preload("res://nodes/bullet.tscn")
var cooldown_timer: Timer
var can_shoot := true
var max_ammo := 4
var current_ammo := 4
signal reloading

func _ready() -> void:
	#Timer para el cooldown del disparo
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = 1
	add_child(cooldown_timer)
	
	
	


func _physics_process(delta: float) -> void:
	# Vector de movimiento
	target_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	# Vector de dirección normalizado para mantener la misma velocidad en todas las direcciones
	if target_direction.length() > 0:
		target_direction = target_direction.normalized()

	
	velocity = target_direction * speed
	move_and_slide()
	
	#Disparar
	if Input.is_key_pressed(KEY_F):
		if current_ammo >=1 && can_shoot:
			shoot()
			
	#Recargar
	if Input.is_key_pressed(KEY_R):
		if current_ammo <4:
			reload()
		
	# Creacion de las balas y manejo del cooldown
func shoot() -> void:
	
	var bullet_instance:= bullet.instantiate() as Bullet
	bullet_instance.position = global_position
	bullet_instance.direction = target_direction
		
	get_parent().add_child(bullet_instance)
	
	current_ammo -= 1
	can_shoot = false
	cooldown_timer.start()
	

func on_timer_timeout() -> void:
	can_shoot = true
	

func reload() -> void:
	current_ammo = max_ammo
	emit_signal("reloading")
