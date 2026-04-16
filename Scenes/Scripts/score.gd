# Score Node
extends Node2D
@export var player_number: int
func _process(delta: float) -> void:
 if player_number == 1:
   $Label.text = str(Highscore.displayed_points_1)
 else:
   $Label.text = str(Highscore.displayed_points_2)
