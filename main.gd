extends CanvasLayer

# Number of flashing buttons by round
@export var rounds: Array[int] = [3, 4, 5, 6, 7]
@export var start_delay : float = 0.5

@onready var square_ids : Array[int] = $Square.get_square_ids()


var current_round = 0
var selected_squares_in_order : Array[int] = []
var pressed_square_index = 0


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$SignalContainer.create_and_show_signals(rounds[current_round])
	for i in range(rounds[current_round]):
		selected_squares_in_order.append($Square.get_random_square_id())
		var flash_timer = Timer.new()
		flash_timer.autostart = true
		flash_timer.one_shot = true
		flash_timer.wait_time = i * 1 + start_delay
		flash_timer.timeout.connect(func():
			$Square.flash_square(selected_squares_in_order[i])
			$SignalContainer.set_signal_state(i, $SignalContainer.SignalState.FLASHING)
		)
		add_child(flash_timer)
		flash_timer.start()
		
	var on_flash_end = Timer.new()
	on_flash_end.autostart = true
	on_flash_end.wait_time = rounds[current_round] - 1 + $Square.flash_duration_ms / 1000
	on_flash_end.one_shot = true
	on_flash_end.timeout.connect(func():
		$SignalContainer.reset_all_signals()
		$Square.enable_all_squares()
	)
	add_child(on_flash_end)
	on_flash_end.start()


func _on_square_pressed(square_id: int) -> void:
	if selected_squares_in_order[pressed_square_index] == square_id:
		$SignalContainer.set_signal_state(pressed_square_index, $SignalContainer.SignalState.VALID)
	else:
		$Square.disable_all_squares()
		$SignalContainer.set_signal_state(pressed_square_index, $SignalContainer.SignalState.WRONG)
		# TODO: display lose message and button to restart all rounds
		
	if pressed_square_index == rounds[current_round]:
		$Square.disable_all_squares()
		# TODO: display win message and button for next round
	else :
		pressed_square_index += 1
