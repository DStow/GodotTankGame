extends CharacterBody2D

class_name EnemyTank

@export var turn_speed: float = 0.9
@export var turret_rotation_speed: float = 1.4

var forward_velocity: float = 0
var acceleration: int = 100
var max_velocity: int = 150

var mouse_global_pos: Vector2 = Vector2.ZERO

@onready var reload_component: ReloadComponent = $ReloadComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var enemy_targeting_component: EnemyTargetingComponent = $EnemyTargetingComponent
@onready var turret: Sprite2D = $Turret
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var _player_last_seen: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if the player can be seen
	handle_player_targetting(delta)
	
	if _player_last_seen != Vector2.ZERO:
		navigation_agent_2d.target_position = _player_last_seen
		var next_pos = navigation_agent_2d.get_next_path_position()
		print("Next pos", next_pos)

func handle_player_targetting(delta: float):
	var visible_player: Tank = enemy_targeting_component.target_player()
	if visible_player != null:
		_player_last_seen = visible_player.global_position
		
	print("Player tank found", visible_player)
	# Turn to face the player
	if _player_last_seen == Vector2.ZERO:
		return
	
	if(!is_turret_facing_desired(_player_last_seen)):
		var required_rotation: float = get_turret_rotation_to_target(_player_last_seen)
		required_rotation = clampf(required_rotation, turret_rotation_speed * -1 * delta, turret_rotation_speed * delta)
		turret.rotation += required_rotation

func _on_hitbox_area_entered(area: Area2D) -> void:
	var parent: Node2D = area.get_parent()
	if parent.is_in_group("projectile"):
		var proj: Projectile = parent as Projectile
		health_component.take_damage(proj.get_damage())
		proj.splash()

func _on_health_component_no_health() -> void:
	queue_free()

func is_turret_facing_desired(target: Vector2) -> bool:
	var rotation_required: float = get_turret_rotation_to_target(target)
	return abs(rotation_required) < 0.01
	
func get_turret_rotation_to_target(target: Vector2) -> float:
	var direction: Vector2 = (target - turret.global_position).normalized()
	var current_rotation: float = turret.global_rotation
	var change: float = direction.angle() - current_rotation
	return wrapf(change, -PI, PI)
