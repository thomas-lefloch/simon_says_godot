extends CanvasLayer

# Number of flashing buttons by round
@export var rounds: Array[int] = [3, 4, 5, 6, 7]

@export var start_delay : float = 0.5
@export var message_duration: int = 1

@export var message_delay :float = .3
@export var lose_message = "You lose !"
@export var retry_label = "Try again ?"
@export var win_message = "You win !"
@export var next_round_label = "Next"

@onready var square_ids : Array[int] = $Square.get_square_ids()


var current_round = 0
var selected_squares_in_order : Array[int] = []
var pressed_square_index = 0

func reset_game_state():
	current_round = 0
	selected_squares_in_order = []
	pressed_square_index = 0
	$SignalContainer.reset()

func next_round():
	# we replay the last round ad vitam aeternam
	if current_round < rounds.size() - 1:
		current_round += 1
	selected_squares_in_order = []
	pressed_square_index = 0
	$SignalContainer.reset()

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
		$SignalContainer.clear_all_signals()
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
		
		# We want the use to see it's mistake before displaying the message
		var delay_timer = Timer.new()
		delay_timer.wait_time = message_delay
		delay_timer.one_shot = true
		delay_timer.timeout.connect(func():
			display_message_followed_by_start_button(lose_message, retry_label)
			reset_game_state()
		)
		add_child(delay_timer)
		delay_timer.start()
		
		
	if pressed_square_index == rounds[current_round] - 1:
		$Square.disable_all_squares()
		var delay_timer = Timer.new()
		delay_timer.wait_time = message_delay
		delay_timer.one_shot = true
		delay_timer.timeout.connect(func():
			display_message_followed_by_start_button(win_message, next_round_label)
			next_round()
		)
		add_child(delay_timer)
		delay_timer.start()
	else :
		pressed_square_index += 1


func display_message_followed_by_start_button(message: String, button_label: String):
	$SignalContainer.hide()
	$StartButton.hide()
	$Message.text = message
	$Message.show()
	var message_timer = Timer.new()
	message_timer.wait_time = message_duration
	message_timer.one_shot = true
	message_timer.timeout.connect(func():
		$Message.hide()
		$StartButton.text = button_label
		$StartButton.show()
	)
	add_child(message_timer)
	message_timer.start()


	
