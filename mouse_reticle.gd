extends Node2D

class_name MouseReticle

@export var reload_component: ReloadComponent
@onready var cursor_sprite: Sprite2D = $CursorSprite

var _reload_progress: float = 1.0 # 1 is fully loaded
var _looking_at_target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		
	var radius = 32.0
	var thickness = 6.0
	var segments = 64

	# Background arc (dark, full circle)
	draw_arc(Vector2.ZERO, radius, 0, TAU, segments, Color(0, 0, 0, 0.4), thickness)
	
	if !reload_component.is_reloading():
		var color = Color.WEB_GREEN
		if !_looking_at_target: color = Color.RED
		draw_arc(Vector2.ZERO, radius, 0, TAU, segments, color, thickness)
	else:
		# Foreground arc (bright, shows progress)
		# Start from top (-PI/2) and sweep clockwise
		var start_angle = -PI / 2
		var end_angle = start_angle + (TAU * reload_component.reload_progress())
		draw_arc(Vector2.ZERO, radius, start_angle, end_angle, segments, Color.RED, thickness)
