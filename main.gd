extends CanvasLayer

const SignalState = preload("res://SignalState.gd")

@export var round_count = 7

@onready var square_ids : Array[int] = $Square.get_square_ids()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$SignalContainer.create_and_show_signals(round_count)
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	$Square.flash_square(square_ids[randi() % square_ids.size()])
	pass # Replace with function body.
