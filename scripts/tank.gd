extends CharacterBody2D

class_name Tank

@export var turn_speed: float = 0.9
@export var turret_rotation_speed: float = 2.6
@export var targetting_reticle: TargettingReticle

var forward_velocity: float = 0
var acceleration: int = 100
var max_velocity: int = 150

var mouse_global_pos: Vector2 = Vector2.ZERO

@onready var projectile_spawn_position: Marker2D = $Turret/ProjectileSpawnPosition
@onready var turret: Sprite2D = $Turret
@onready var laser_spawn_position: Marker2D = $Turret/LaserSpawnPosition
@onready var time_to_target: Label = $CanvasLayer/TimeToTarget
@onready var reload_component: ReloadComponent = $ReloadComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetting_reticle.set_active_reload_component(reload_component)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("turn_left"):
		rotate(-1 * turn_speed * delta)
	elif Input.is_action_pressed("turn_right"):
		rotate(turn_speed * delta)
		
	if Input.is_action_pressed("drive_forward"):
		forward_velocity += acceleration * delta
	elif Input.is_action_pressed("drive_reverse"):
		forward_velocity -= acceleration * delta
	else:
		if forward_velocity > 0:
			forward_velocity -= (acceleration * 2) * delta
			forward_velocity = clampf(forward_velocity, 0, max_velocity)
		elif forward_velocity < 0:
			forward_velocity += (acceleration * 2) * delta
			forward_velocity = clampf(forward_velocity, 0, -max_velocity)

	forward_velocity = clampf(forward_velocity, -max_velocity, max_velocity)

	var motion_vector: Vector2 = Vector2(forward_velocity, 0).rotated(rotation)
	
	velocity = motion_vector
	var collided: bool = move_and_slide()
	if collided and forward_velocity > 20:
		forward_velocity = 20
	
	if(!is_turret_facing_desired()):
		var required_rotation: float = get_turret_rotation_to_target(targetting_reticle.global_position)
		var time_to_complete: float = snappedf(abs(required_rotation) / turret_rotation_speed, 0.1)
		time_to_target.text = str(time_to_complete) + "s"
		required_rotation = clampf(required_rotation, turret_rotation_speed * -1 * delta, turret_rotation_speed * delta)
		turret.rotation += required_rotation

	# Now check again after the rotation has been applied
	if(!is_turret_facing_desired()):
		targetting_reticle.set_looking_at_target(false)
		time_to_target.visible = false
		time_to_target.global_position = targetting_reticle.global_position
	else:
		targetting_reticle.set_looking_at_target(true)
		time_to_target.visible = false
		
func get_turret_rotation_to_target(target: Vector2) -> float:
	var direction: Vector2 = (target - turret.global_position).normalized()
	var current_rotation: float = turret.global_rotation
	var change: float = direction.angle() - current_rotation
	return wrapf(change, -PI, PI)
	
func is_turret_facing_desired() -> bool:
	var rotation_required: float = get_turret_rotation_to_target(targetting_reticle.global_position)
	return abs(rotation_required) < 0.01
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and is_turret_facing_desired() and reload_component.can_fire() :
			reload_component.fire()
			ProjectileManager.spawn_projectile(projectile_spawn_position.global_position, turret.global_rotation)
