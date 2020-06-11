extends Panel

onready var host_button = get_node("Host")
onready var host_port = get_node("Host/Port")

onready var join_button = get_node("Join")
onready var join_address = get_node("Join/Address")
onready var join_port = get_node("Join/Port")

func _ready():
	host_button.connect("button_down", self, "host_pressed")
	join_button.connect("button_down", self, "join_pressed")

func host_pressed():
	var port = int(host_port.text)
	NetworkSingleton.create_server(port)

func join_pressed():
	var address = join_address.text
	var port = int(join_port.text)
	NetworkSingleton.create_client(address, port)
