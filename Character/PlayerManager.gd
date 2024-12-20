extends Node
class_name PlayerManager

var player_data: Dictionary = {}
signal player_joined(player)
signal player_left(player)

func join(device: int):
	var player = next_player()
	print_debug("Join player: "+str(player))
	if player >= 0:
		# initialize default player data here
		# "team" and "car" are remnants from my game just to provide an example
		player_data[player] = {
			"device": device
		}
		player_joined.emit(player)

# call from outside
func handle_join_input():
	for device in get_unjoined_devices():
		if MultiplayerInput.is_action_just_pressed(device, "join"):
			join(device)
			
			
func get_unjoined_devices():
	var devices = Input.get_connected_joypads()
	# also consider keyboard player
	devices.append(-1)
	
	# filter out devices that are joined:
	return devices.filter(func(device): return !is_device_joined(device))
	
func next_player() -> int:
	for i in 2:
		if !player_data.has(i): return i
	return -1

# get player data.
# null means it doesn't exist.
func get_player_data(player: int, key: StringName):
	if player_data.has(player) and player_data[player].has(key):
		return player_data[player][key]
	return null

func get_player_device(player: int) -> int:
	return get_player_data(player, "device")

func is_device_joined(device: int) -> bool:
	for player_id in player_data:
		var d = get_player_device(player_id)
		if device == d: return true
	return false
