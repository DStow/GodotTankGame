extends Node2D

class_name EnemyTargetingComponent

var _player_tank: Tank = null
var _papi: EnemyTank = null
var _raycast: RayCast2D = null

func _ready() -> void:
	_papi = get_parent()
	setup_raycast()
	
	# Find player tank
	_player_tank = get_tree().get_nodes_in_group("player")[0]
	print("Enemy targeting component found a player!", _player_tank)

func setup_raycast() -> void:
	_raycast = RayCast2D.new()
	add_child(_raycast)
	_raycast.enabled = true
	_raycast.collision_mask = 0b11

# Call this, if the tank can see the player tank,
# it will return the player tank otherwise null
func target_player() -> Tank:
	_raycast.target_position = _raycast.to_local(_player_tank.global_position)
	if _raycast.is_colliding():
		if _raycast.get_collider() == _player_tank:
			return _player_tank
	return null
