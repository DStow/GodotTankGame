extends Node

const PROJECTILE = preload("uid://djac4ru4lcibf")

func spawn_projectile(position: Vector2, direction: float) -> Node2D:
	var projectile = PROJECTILE.instantiate() as Projectile
	projectile.global_position = position
	projectile.global_rotation = direction
	add_child(projectile)
	return projectile
