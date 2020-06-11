extends Node2D

remotesync var controller_path = null
remotesync var x_input = 0
remotesync var y_input = 0

func set_directional_input(horizontal, vertical):
	rset("x_input", horizontal)
	rset("y_input", vertical)

func input(_event):
	pass

puppetsync func request_control(player_path):
	var player = get_node(player_path)
	if controller_path == null:
		controller_path = player_path
		player.set_module(get_path())
