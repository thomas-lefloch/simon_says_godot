extends Control

@export var gutter_size = 10
@export var signal_size = 50

const signal_default = preload("res://signals/signal_default.png")
const signal_flashing = preload("res://signals/signal_flashing.png")
const signal_valid = preload("res://signals/signal_good.png")
const signal_wrong = preload("res://signals/signal_wrong.png")

enum SignalState {
	DEFAULT,
	FLASHING,
	VALID,
	WRONG
}

var textureByState = {
	SignalState.DEFAULT: signal_default,
	SignalState.FLASHING: signal_flashing,
	SignalState.VALID: signal_valid,
	SignalState.WRONG: signal_wrong
}

func set_signal_state(idx: int, state: SignalState):
	get_child(idx).texture = textureByState[state]

func create_and_show_signals(signal_count: int) -> void:
	var total_size = signal_size * signal_count + (gutter_size * signal_count - 1)
	for i in signal_count:
		var sig  = TextureRect.new()
		sig.set_size(Vector2(50, 50))
		sig.set_texture(signal_default)
		add_child(sig)
	show()
	
func clear_all_signals():
	for child in get_children():
		child.texture = textureByState[SignalState.DEFAULT]

func reset():
	for child in get_children():
		self.remove_child(child)
		child.queue_free()
