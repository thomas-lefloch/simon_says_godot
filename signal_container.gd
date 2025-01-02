extends Control

@export var gutter_size = 10
@export var signal_size = 50

const signal_default = preload("res://signals/signal_default.png")
const signal_flashing = preload("res://signals/signal_flashing.png")
const signal_good = preload("res://signals/signal_good.png")
const signal_wrong = preload("res://signals/signal_wrong.png")

enum SignalState {
	DEFAULT,
	FLASHING,
	GOOD,
	WRONG
}

var textureByState = {
	SignalState.DEFAULT: signal_default,
	SignalState.FLASHING: signal_flashing,
	SignalState.GOOD: signal_good,
	SignalState.WRONG: signal_wrong
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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
