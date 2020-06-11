extends KinematicBody2D

const max_acceleration = 250
remotesync var acceleration = 0
remotesync var velocity = Vector2.ZERO
onready var bridge_module = get_node("ModuleManager/BridgeModule")
onready var cannon_module = get_node("ModuleManager/CannonModule")

func _ready():
	rset_config("rotation", MultiplayerAPI.RPC_MODE_REMOTESYNC)
	rset_config("position", MultiplayerAPI.RPC_MODE_REMOTESYNC)

func _physics_process(delta):
	var rotation_direction = bridge_module.x_input
	var acceleration_direction = bridge_module.y_input

	acceleration = max_acceleration * delta * acceleration_direction
	velocity += Vector2(cos(rotation - PI / 2), sin(rotation - PI / 2)) * acceleration

	velocity = self.move_and_slide(velocity)
	self.rotate(rotation_direction * PI * delta)

	if (is_network_master()):
		synchronize()

func synchronize():
	rset_unreliable("position", position)
	rset_unreliable("velocity", velocity)
	rset_unreliable("rotation", rotation)
	rset_unreliable("acceleration", acceleration)
