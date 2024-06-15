extends Node

class_name StreamerbotSocket

@export var ws_url = "ws://127.0.0.1:8088"

var socket = WebSocketPeer.new()
var sub_data := {}
var socket_connected = false
var req = {
	"request": "GetEvents",
	"id": "69420"
}

func _ready():
	var error = socket.connect_to_url(ws_url)
	Globals.twitch_event_received.connect(_twitch_event_received)
	Globals.youtube_event_received.connect(_youtube_event_received)
	Globals.kofi_event_received.connect(_kofi_event_received)
	Globals.pause_subs.connect(_on_subs_paused)
	Globals.active_viewers_requested.connect(_request_active_viewers)
	ElgatoStreamDeck.on_key_down.connect(_stream_deck)
	pass

func _process(_delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if !socket_connected:
			socket_connected = true
			_subscribe()

		while socket.get_available_packet_count() && socket_connected:
			var packet = socket.get_packet()
			var sb_response = JSON.parse_string(packet.get_string_from_utf8())
			if typeof(sb_response) == TYPE_DICTIONARY:
				process_response(sb_response)
				pass
			#if socket.was_string_packet():
				#packet.get_string_from_ascii()
	elif state == WebSocketPeer.STATE_CLOSING:
	# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.

func _subscribe():
	Globals.sb_request = "Unsubscribe"
	var data := Globals.sb_events
	var temp_data = {"request": "GetEvents", "id": "42069"}
	socket.send_text(JSON.stringify(data))

func _unsubscribe():
	Globals.sb_request = "Unsubscribe"
	var data := Globals.sb_events
	var temp_data = {"request": "GetEvents", "id": "42069"}
	socket.send_text(JSON.stringify(data))


func process_response(res: Dictionary):
	if res.has("id") && res.id == "424242":
		print(res)
	if res.has("events") && res.id == "666":
		Globals.credits_returned.emit(res.events)
		#print(res.events)
	if res.has("event"):
		if res.event.source == "Raw" \
			&& res.event.type == "Action" \
			&& res.data.arguments.has("credits") \
			&& res.data.arguments.credits:
				socket.send_text(JSON.stringify({"request": "GetCredits", "id": "666"}))

		#print(res.event)

		match res.event.source.to_lower():
			"twitch":
				Globals.twitch_event_received.emit(res)
			"youtube":
				Globals.youtube_event_received.emit(res)
			"kofi":
				Globals.kofi_event_received.emit(res)
			_:
				pass
	else:
		print(res)
	pass

func _twitch_event_received(res):
	#print(res)
	match res.event.type:
		"ChatMessage":
			print(res.data.message.displayName,": ", res.data.message.message)
		"Follow":
			Globals.new_follower.emit(res.data.user_name)
		"Cheer":
			Globals.cheer.emit(res.data.message.displayName, res.data.message.bits, res.data.message.message)
		"Raid":
			Globals.raid.emit(res.data.displayName, res.data.viewerCount, res.data.profileImage, res.data)
	#raid,
	#raider_name,
	#viewer_count,
	#raider_image,
	#data)
			pass
		pass

func _youtube_event_received(res):
	print(res)

func _stream_deck(e):
	print(e)

func _on_subs_paused():
	_unsubscribe()
	get_tree().create_timer(300).timeout
	_subscribe()
	pass

func _kofi_event_received(res):
	print(res)

func _request_active_viewers():
	socket.send_text(JSON.stringify({
	  "request": "GetActiveViewers",
	  "id": "424242"
	}))
