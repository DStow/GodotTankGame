extends Node

class_name HealthComponent

@export var max_health: int

var _current_health: int

signal no_health

func _ready() -> void:
	_current_health = max_health
	
func take_damage(damage: int) -> void:
	_current_health -= damage
	if _current_health < 0:
		_current_health = 0
		no_health.emit()
	print("Current health is ", _current_health)