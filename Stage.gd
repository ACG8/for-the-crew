extends Node2D

func _ready():
	NetworkSingleton.emit_signal("stage_loaded")
