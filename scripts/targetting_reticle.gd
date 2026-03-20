extends Node2D

class_name TargettingReticle

@onready var cursor_sprite: Sprite2D = $CursorSprite

var _looking_at_target: bool = false
var _reload_component: ReloadComponent = null
var _mouse_global_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if global_position != _mouse_global_pos or _reload_component.is_reloading():
		queue_redraw()
	
	global_position = _mouse_global_pos

func set_looking_at_target(value: bool) -> void:
	if _looking_at_target == value:
		return
	_looking_at_target = value
	cursor_sprite.modulate = Color.GREEN if value else Color.RED
	queue_redraw()

func _draw() -> void:
	var radius: float = 32.0
	var thickness: float = 6.0
	var segments: int = 64

	draw_arc(Vector2.ZERO, radius, 0, TAU, segments, Color(0, 0, 0, 0.4), thickness)
	
	if !_reload_component.is_reloading():
		var color: Color = Color.WEB_GREEN
		if !_looking_at_target: color = Color.RED
		draw_arc(Vector2.ZERO, radius, 0, TAU, segments, color, thickness)
	else:
		var start_angle: float = -PI / 2
		var end_angle: float = start_angle + (TAU * _reload_component.reload_progress())
		draw_arc(Vector2.ZERO, radius, start_angle, end_angle, segments, Color.RED, thickness)

func _input(event):
	if event is InputEventMouseMotion:
		_mouse_global_pos = event.global_position

func set_active_reload_component(reload_component: ReloadComponent) -> void:
	_reload_component = reload_component
