extends Node2D

@export var music_player : Node2D
@export var notes_container : Node2D
@export var up_buttons: TextureButton 
@export var down_buttons: TextureButton 
@export var left_buttons: TextureButton 
@export var right_buttons: TextureButton 

@export var player_number: int

@export var leftc: String
@export var rightc: String
@export var upc: String
@export var downc: String


const NOTE_SCENE = preload("res://Scenes/Game_Scenes/note.tscn")
const BUTTON_SPAWN_OFFSET := Vector2(16, 16)
const NOTE_Y_OFFSET := 400
const FALLING_SPEED_SCALE := 0.5 
const TIMING_OFFSET := (1.0/FALLING_SPEED_SCALE)

var delta_sum := 0.0

@onready var notes: Dictionary = {
 36: {
	"key": "cima_nota",
	#"button": get_node("CanvasLayer/Buttons/UpButton"),
	"button": "up",
	"texture": preload("res://Assets/Sprites/arrow_up_note.png"),
	"queue":[],
	 "color":Color("#ad6dea")
 },
 38: {
	"key": "baixo_nota",
	#"button": get_node("CanvasLayer/Buttons/DownButton"),
	"button": "down",
	"texture": preload("res://Assets/Sprites/arrow_down_note.png"),
	"queue":[],
	 "color":Color("#0ce7a7")
 },
 40: {
	"key": "esquerda_nota",
	#"button": get_node("CanvasLayer/Buttons/LeftButton"),
	"button": "left",
	"texture": preload("res://Assets/Sprites/arrow_left_note.png"),
	"queue":[],
	 "color":Color("#fb4771")
 },
 602: {
	"key": "direita_nota",
	#"button": get_node("CanvasLayer/Buttons/RightButton"),
	"button": "right",
	"texture": preload("res://Assets/Sprites/arrow_right_note.png"),
	"queue":[],
	 "color":Color("#ffec6d")
 },
42: {
	"key": "direita_nota",
	#"button": get_node("CanvasLayer/Buttons/RightButton"),
	"button": "right",
	"texture": preload("res://Assets/Sprites/arrow_right_note.png"),
	"queue":[],
	 "color":Color("#ffec6d")
 }
}

func _ready() -> void:
	notes[42]["key"] = rightc
	notes[602]["key"] = rightc
	notes[40]["key"] = leftc
	notes[36]["key"] = upc
	notes[38]["key"] = downc
	
func _process(delta):
	delta_sum = music_player.delta_sum
	_check_input()
	_check_missed_notes()


func receive_note_event(id: int):
	var note_data: Dictionary = notes.get(id)
	if note_data:
		var note = NOTE_SCENE.instantiate()
		notes_container.add_child(note)
		note.color = note_data.color;
		match note_data["button"]:
			"up":
				note.global_position = up_buttons.global_position + BUTTON_SPAWN_OFFSET - Vector2(0, NOTE_Y_OFFSET)
			"down":
				note.global_position = down_buttons.global_position + BUTTON_SPAWN_OFFSET - Vector2(0, NOTE_Y_OFFSET)
			"left":
				note.global_position = left_buttons.global_position + BUTTON_SPAWN_OFFSET - Vector2(0, NOTE_Y_OFFSET)
			"right":
				note.global_position = right_buttons.global_position + BUTTON_SPAWN_OFFSET - Vector2(0, NOTE_Y_OFFSET)

		note.texture = note_data["texture"]
		note.speed = NOTE_Y_OFFSET * FALLING_SPEED_SCALE
		note.expected_time = delta_sum + TIMING_OFFSET
		

		# add to queue
		note_data["queue"].push_back(note)


func _check_input() -> void:
	for note_data in notes.values():
		if Input.is_action_just_pressed(note_data["key"]):
			_check_note_hit(note_data)

func _check_note_hit(note_data: Dictionary) -> void:
	if not note_data["queue"].is_empty():
		var next_note: Node2D = note_data["queue"].front()
		if next_note.test_hit(delta_sum):
			note_data["queue"].pop_front().hit(delta_sum, player_number)
			
		else:
			Highscore.update_points(Highscore.TimingJudgement.WHAT, player_number)
	else:
		Highscore.update_points(Highscore.TimingJudgement.WHAT, player_number)


func _check_missed_notes() -> void:
	for note_data in notes.values():
		if not note_data["queue"].is_empty():
			var next_note: Node2D = note_data["queue"].front()
			if note_data["queue"].front().test_miss(delta_sum):
				note_data["queue"].pop_front().miss(player_number)
