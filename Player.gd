extends Node

remotesync var module_path

var gui_packed_scene = preload("res://GUI.tscn")
var camera_packed_scene = preload("res://Camera.tscn")

func _ready():
	if(is_network_master()):
		set_process_input(true)
	else:
		set_process_input(false)

func _input(event):
	if module_path != null:
		var module = get_node(module_path)
		var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		var vertical = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
		module.set_directional_input(horizontal, vertical)
		module.input(event)

remotesync func set_module(path):
	if module_path != null:
		var module = get_node(module_path)
		module.rset("controller_path", null)
	rset("module_path", path)

remotesync func join_ship():
	if is_network_master():
		var gui = gui_packed_scene.instance()
		var camera = camera_packed_scene.instance()
		get_parent().get_parent().add_child(camera)
		camera.add_child(gui)
		gui.controller = self

