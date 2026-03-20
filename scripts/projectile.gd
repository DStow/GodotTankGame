extends Node2D

class_name Projectile

var speed: float = 500
var _damage: int = 8

@onready var collision_area: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var motion_vector: Vector2 = Vector2(speed, 0).rotated(rotation)
	position += motion_vector * delta

func splash() -> void:
	print("Splashing a projectile...")
	collision_area.set_deferred("monitorable", false)
	queue_free()
	
func get_damage() -> int:
	return _damage