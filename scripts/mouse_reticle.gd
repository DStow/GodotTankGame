extends Node2D

class_name MouseReticle

@export var reload_component: ReloadComponent
@onready var cursor_sprite: Sprite2D = $CursorSprite

var _looking_at_target

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	rotation = -get_parent().global_rotation
	
	queue_redraw()
		
	if _looking_at_target:
		cursor_sprite.modulate = Color.GREEN
	else:
		cursor_sprite.modulate = Color.RED
		
func set_looking_at_target(value: bool) -> void:
	_looking_at_target = value
	
	
func _draw() -> void:
	var radius: float = 32.0
	var thickness: float = 6.0
	var segments: int = 64

	draw_arc(Vector2.ZERO, radius, 0, TAU, segments, Color(0, 0, 0, 0.4), thickness)
	
	if !reload_component.is_reloading():
		var color: Color = Color.WEB_GREEN
		if !_looking_at_target: color = Color.RED
		draw_arc(Vector2.ZERO, radius, 0, TAU, segments, color, thickness)
	else:
		var start_angle: float = -PI / 2
		var end_angle: float = start_angle + (TAU * reload_component.reload_progress())
		draw_arc(Vector2.ZERO, radius, start_angle, end_angle, segments, Color.RED, thickness)
