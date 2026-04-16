# Highscore.gd
extends Node

var points = 0;
var p1_points = 0;
var p2_points = 0;
var displayed_points_1 = 0;
var displayed_points_2 = 0;
enum TimingJudgement {MISS, WHAT, OK, GOOD, PERFECT}

const FEEDBACK_SCENE = preload("res://Scenes/Game_Scenes/feedback.tscn");
@onready var feedback_container = get_node("/root/Main/").get_node("FeedbackContainer");

func _process(delta: float) -> void:
 update_displayed_points()

func update_points(type: TimingJudgement, player: int):
 match(type):
  TimingJudgement.MISS:
   points -= 100;
   _spawn_note_feedback("MISS", player)
  TimingJudgement.WHAT:
   points -= 100;
   _spawn_note_feedback("WHAT", player)
  TimingJudgement.OK:
   points += 200
   _spawn_note_feedback("OK", player)
  TimingJudgement.GOOD:
   points += 500;
   _spawn_note_feedback("GOOD", player)
  TimingJudgement.PERFECT:
   points += 1000;
   _spawn_note_feedback("PERFECT", player)
 
 if player == 1:
   p1_points += points;
   print("player 1: ", p1_points)
 elif player == 2:
   p2_points += points;
   print("player 2: ", p2_points)
 points = 0

func update_displayed_points() -> void:
 var difference_1 = abs(p1_points - displayed_points_1)
 # Determine the step size dynamically
 var step = max(1, difference_1 * 0.2)
 if displayed_points_1 < p1_points:
  displayed_points_1 =  min(displayed_points_1 + step, p1_points);
 elif displayed_points_1 > p1_points:
  displayed_points_1 = max(displayed_points_1 - step,p1_points)
  
 displayed_points_1 = int(displayed_points_1)
 var difference_2 = abs(p2_points - displayed_points_2)
 # Determine the step size dynamically
 var step_2 = max(1, difference_2 * 0.2)
 if displayed_points_2 < p2_points:
  displayed_points_2 =  min(displayed_points_2 + step_2, p2_points);
 elif displayed_points_2 > p2_points:
  displayed_points_2 = max(displayed_points_2 - step_2, p2_points)
  
 displayed_points_2 = int(displayed_points_2)

func _spawn_note_feedback(text, player: int):
 var feedback = FEEDBACK_SCENE.instantiate();
 feedback.set_text(text)
 if player == 1:
  feedback.global_position = Vector2(128,240) 
 else:
  feedback.global_position = Vector2(280,240) 
 feedback_container.add_child(feedback);
