extends Node

class_name ReloadComponent

@export var reload_time: float = 2.0

var _remaining_reload_time: float = 0

var _is_reloading: bool = false

func can_fire() -> bool:
	return !_is_reloading
	
func fire() -> void:
	_is_reloading = true
	_remaining_reload_time = reload_time

func _process(delta: float) -> void:
	if _is_reloading:
		_remaining_reload_time -= delta
		if _remaining_reload_time < 0:
			_is_reloading = false

func is_reloading() -> bool:
	return _is_reloading
	
func reload_progress() -> float:
	var left = reload_time - _remaining_reload_time
	var result = (left / reload_time)
	return result
