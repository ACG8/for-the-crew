extends "res://spaceship/Module.gd"

onready var laser_packed_scene = preload("res://spaceship/Laser.tscn")

func input(event):
	if event is InputEventMouseButton:
		rpc("shoot")

mastersync func shoot():
	var projectile = laser_packed_scene.instance()
	var target = get_global_mouse_position()
	projectile.position = self.global_position
	projectile.rotation = get_angle_to(target) + PI / 2
	get_tree().get_root().add_child(projectile)
