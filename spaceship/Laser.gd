extends Area2D

var lifetime = 2.00
const speed = 375

func _ready():
	set_network_master(1)
	rset_config("position", MultiplayerAPI.RPC_MODE_PUPPET)
	rset_config("rotation", MultiplayerAPI.RPC_MODE_PUPPET)

	if is_network_master():
		rset("rotation", rotation)

func _physics_process(delta):
	self.position += Vector2(cos(rotation - PI / 2), sin(rotation - PI / 2)) * delta * speed
	self.lifetime -= delta

	if is_network_master():
		if self.lifetime <= 0:
			rpc("die")

		rset("position", self.position)

remotesync func die():
	self.call_deferred("queue_free")
