class_name Enemy
extends CharacterBody2D

signal entity_death


@export var health: float = 100.0
@export var speed: float = 40

var _target: Player

@onready var _anim_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	_target = get_tree().get_first_node_in_group("Player")
	_anim_player.play("walk")

func _physics_process(delta: float) -> void:
	velocity = (_target.global_position - global_position).normalized() * speed

func on_death(drop_loot: bool = true) -> void:
	_anim_player.play("death")
	entity_death.emit()
	call_deferred("queue_free")

func _on_hurt_box_hurt(value: float) -> void:
	health -= value
	_anim_player.play("hurt")
	if health <= 0:
		if not $HurtBox.disabled:
			$HurtBox.disabled = true
			on_death()
	else:
		await _anim_player.animation_finished
		_anim_player.play("walk")
