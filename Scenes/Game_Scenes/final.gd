extends Control
@export var text: Label
@export var p1: Label
@export var p2: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1.text = "J1 = " + str(Highscore.p1_points)
	p2.text = "J2 = " + str(Highscore.p2_points)
	if Highscore.p1_points == Highscore.p2_points:
		text.text = "EMPATE"
		print("EMPATE")
	elif Highscore.p1_points > Highscore.p2_points:
		text.text = "JOGADOR 1 VENCEU"
		print("JOGADOR 1 VENCEU")
	else:
		text.text = "JOGADOR 2 VENCEU"
		print("JOGADOR 2 VENCEU")
	Highscore.p1_points = 0
	Highscore.p2_points = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game_Scenes/menu.tscn")
