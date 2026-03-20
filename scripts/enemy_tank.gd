extends CharacterBody2D

@export var turn_speed: float = 0.9
@export var turret_rotation_speed: float = 2.6

var forward_velocity: float = 0
var acceleration: int = 100
var max_velocity: int = 150

var mouse_global_pos: Vector2 = Vector2.ZERO

@onready var reload_component: ReloadComponent = $ReloadComponent
@onready var health_component: HealthComponent = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	var parent: Node2D = area.get_parent()
	if parent.is_in_group("projectile"):
		var proj: Projectile = parent as Projectile
		health_component.take_damage(proj.get_damage())
		proj.splash()

func _on_health_component_no_health() -> void:
	queue_free()
