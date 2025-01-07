extends Control

# Probably should be in it's own file
class Square:
	var id: int
	var initial_color: Color
	var flashing_time =  -1
	var interactable: Button


@export var flash_duration_ms = 1000
@onready var interactable_squares: Array[Button] = [
	get_child(1),
	get_child(2),
	get_child(3),
	get_child(4),
]

var squares: Array[Square] = []
signal square_pressed(square_id: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in interactable_squares.size():
		var interactable_square: Button = interactable_squares[i]
		
		var square: Square = Square.new()
		square.id = i
		square.initial_color = interactable_square.get_theme_stylebox("normal").bg_color
		square.interactable = interactable_square
		squares.append(square)
		
		interactable_square.pressed.connect(func(): 
			square_pressed.emit(i)
		)
		
		var disabled_style = StyleBoxFlat.new()
		disabled_style.bg_color = square.initial_color
		interactable_square.add_theme_stylebox_override("disabled", disabled_style)
		var hover_style = StyleBoxFlat.new()
		hover_style.bg_color = square.initial_color.lightened(.2)
		interactable_square.add_theme_stylebox_override("hover", hover_style)
		var pressed_style = StyleBoxFlat.new()
		pressed_style.bg_color = square.initial_color.lightened(.7)
		interactable_square.add_theme_stylebox_override("pressed", pressed_style)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_time = Time.get_ticks_msec()
	for square in squares:
		if current_time - square.flashing_time < flash_duration_ms:
			var lightened_percent = 1 - (float(current_time - square.flashing_time) / flash_duration_ms)
			square.interactable.get_theme_stylebox("normal").bg_color = square.initial_color.lightened(lightened_percent)
			square.interactable.get_theme_stylebox("disabled").bg_color = square.initial_color.lightened(lightened_percent)
			

func get_square_ids() -> Array[int]:
	var ids: Array[int] = []
	for square in squares:
		ids.append(square.id)
	return ids

func flash_square(square_id: int) -> void:
	for i in squares.size():
		if squares[i].id == square_id:
			squares[i].flashing_time = Time.get_ticks_msec()

func enable_all_squares():
	for square in squares:
		square.interactable.disabled = false

func disable_all_squares():
	for square in squares:
		square.interactable.disabled = true

func get_random_square_id() -> int:
	return squares[randi() % squares.size()].id
