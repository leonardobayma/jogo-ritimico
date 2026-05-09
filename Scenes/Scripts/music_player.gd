extends Node2D

signal music_has_ended
signal music_has_started
signal received_note(id)

@export var midi_player: MidiPlayer
@export var mp3_player: AudioStreamPlayer
var next_music
var changing_music
var delta_sum := 0.0
var prev_ending_time

const FALLING_SPEED_SCALE := 0.5 
const TIMING_OFFSET := (1.0/FALLING_SPEED_SCALE)


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
	midi_player.play()
	set_next_music("res://Assets/Sounds/rhythm_tut.mid", "res://Assets/Sounds/rhythm_tut.mp3")

func _process(delta: float) -> void:
	delta_sum += delta
	if delta_sum >= TIMING_OFFSET and not mp3_player.playing:
		mp3_player.play()


	if changing_music:
		if !midi_player.playing:
			midi_player.file = next_music[0]
			if midi_player.play_speed > 1.8:
				midi_player.play_speed = 1
			else:
				midi_player.play_speed = snapped(midi_player.play_speed + .2, 0.1)
			midi_player.play()

		if delta_sum >= (TIMING_OFFSET + prev_ending_time):
			mp3_player.stream = load(next_music[1])
			mp3_player.play(0.0)
			print(mp3_player.pitch_scale)
			if mp3_player.pitch_scale > 1.8:
				mp3_player.pitch_scale = 1
			else:
				mp3_player.pitch_scale = snapped(mp3_player.pitch_scale + 0.2, 0.1)
			changing_music = false

func start_music():
	music_has_started.emit()
	midi_player.play()

func set_next_music(midi_path: String, mp3_path: String):
	next_music = [midi_path, mp3_path]

func music_has_ended_emmiter():
	music_has_ended.emit()

func pause_music():
	midi_player.pause()


func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	if event.type == SMF.MIDIEventType.note_on:
		var note_data: Dictionary = notes.get(event.note)
		if note_data:
			received_note.emit(event.note)
		else:
			print("Note not find")

func get_current_time():
	return delta_sum

func change_music():
	prev_ending_time = delta_sum
	changing_music = true

func _on_midi_player_finished() -> void:
	change_music()
