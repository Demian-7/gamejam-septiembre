class_name Bullet
extends Node2D

@export var speed: float = 1500
@export var max_range: float = 1000

var traveled_distance: float = 0
var direction := Vector2.RIGHT



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	
	look_at(direction)
	traveled_distance += speed * delta
	if traveled_distance > max_range:
		queue_free()
	


func _on_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		queue_free()
	pass # Replace with function body.
