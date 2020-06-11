extends CanvasLayer

var controller
onready var bridge_button = get_node("Bridge")
onready var cannon_button = get_node("Cannon")

func _ready():
	bridge_button.connect("button_down", self, "bridge_pressed")
	cannon_button.connect("button_down", self, "cannon_pressed")

func bridge_pressed():
	var module = get_parent().get_parent().get_node("ModuleManager/BridgeModule")
	module.rpc("request_control", controller.get_path())

func cannon_pressed():
	var module = get_parent().get_parent().get_node("ModuleManager/CannonModule")
	module.rpc("request_control", controller.get_path())
