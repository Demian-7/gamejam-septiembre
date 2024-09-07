class_name Enemy
extends CharacterBody2D

signal entity_death


@export var health: float = 100.0
@export var speed: float = 40
@export var damage: float = 10


func takeDamage(dmg: float) -> void:
	health -= dmg
	if health<= 0:
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		area.get_parent().takeDamage(damage)
		
	
