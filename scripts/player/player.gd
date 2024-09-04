class_name Player
extends CharacterBody2D

@export var speed : float = 500
var target_direction := Vector2.ZERO


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
