extends Node

const MAX_CLIENTS = 12
var network_peer = NetworkedMultiplayerENet.new()
var peers = []
var stage_packed_scene = preload("res://Stage.tscn")
var stage_instance

signal stage_loaded

var player_packed_scene = preload("res://Player.tscn")

func _ready():
	network_peer.connect("peer_connected", self, "_peer_connected")
	network_peer.connect("peer_disconnected", self, "_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	network_peer.connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")

func create_server(port):
	self.connect("stage_loaded", self, "server_setup_after_load")
	get_tree().change_scene_to(stage_packed_scene)
	network_peer.create_server(port, MAX_CLIENTS)

func server_setup_after_load():
	stage_instance = get_tree().current_scene
	get_tree().network_peer = network_peer
	# The host does not play
#	peers.append(1)
#	create_player(1)

func create_client(address, port):
	self.connect("stage_loaded", self, "client_setup_after_load")
	get_tree().change_scene_to(stage_packed_scene)
	network_peer.create_client(address, port)

func client_setup_after_load():
	stage_instance = get_tree().current_scene
	get_tree().network_peer = network_peer

func _peer_connected(id):
	peers.append(id)
	create_player(id)

func _peer_disconnected(id):
	peers.remove(peers.find(id))
	destroy_player(id)

func _connected_to_server():
	create_player(get_tree().get_network_unique_id())

func _connection_failed():
	_server_disconnected()

func _server_disconnected():
	peers.clear()
	get_tree().change_scene("res://Lobby.tscn")

func destroy_player(id):
	var player_manager = stage_instance.get_node("Spaceship/PlayerManager")
	player_manager.remove_node(player_manager.get_node(String(id)))

func create_player(id):
	var new_player = player_packed_scene.instance()
	new_player.set_network_master(id)
	new_player.name = String(id)

	# Temporary hardcoding
	var spaceship = stage_instance.get_node("Spaceship")
	stage_instance.get_node("Spaceship/PlayerManager").add_child(new_player)
#	stage_instance.get_node("Spaceship/ModuleManager/CannonModule").controller = new_player
#	new_player.module = stage_instance.get_node("Spaceship/ModuleManager/CannonModule")
	new_player.rpc("join_ship")
