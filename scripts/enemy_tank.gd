extends Node2D

@export var turn_speed: float = 0.9
@export var turret_rotation_speed: float = 2.6

var forward_velocity = 0
var acceleration = 100
var max_velocity = 150

var mouse_global_pos: Vector2 = Vector2.ZERO

@onready var reload_component: ReloadComponent = $ReloadComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass