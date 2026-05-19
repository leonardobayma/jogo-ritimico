extends Node

var points = 0
var p1_points = 0
var p2_points = 0

var displayed_points_1 = 0
var displayed_points_2 = 0

var last_scene = null

enum TimingJudgement {
	MISS,
	WHAT,
	OK,
	GOOD,
	PERFECT
}

const FEEDBACK_SCENE = preload("res://Scenes/Game_Scenes/feedback.tscn")

var feedback_container: Node = null


func _ready() -> void:
	last_scene = get_tree().current_scene
	startup(last_scene)


func startup(scene):
	feedback_container = get_node_or_null("/root/Main/FeedbackContainer")

	if feedback_container != null:
		print("FeedbackContainer encontrado!")
	else:
		print("FeedbackContainer nao encontrado.")


func _process(delta: float) -> void:
	var current = get_tree().current_scene

	if current != last_scene and current != null:
		last_scene = current
		startup(current)

	update_displayed_points()

	if Input.is_action_just_pressed("aa"):
		p1_points = 0
		p2_points = 0


func update_points(type: TimingJudgement, player: int):

	match(type):

		TimingJudgement.MISS:
			points -= 100
			_spawn_note_feedback("MISS", player)

		TimingJudgement.WHAT:
			points -= 100
			_spawn_note_feedback("WHAT", player)

		TimingJudgement.OK:
			points += 200
			_spawn_note_feedback("OK", player)

		TimingJudgement.GOOD:
			points += 500
			_spawn_note_feedback("GOOD", player)

		TimingJudgement.PERFECT:
			points += 1000
			_spawn_note_feedback("PERFECT", player)

	if player == 1:
		p1_points += points

	elif player == 2:
		p2_points += points

	points = 0


func update_displayed_points() -> void:

	var difference_1 = abs(p1_points - displayed_points_1)
	var step = max(1, difference_1 * 0.2)

	if displayed_points_1 < p1_points:
		displayed_points_1 = min(displayed_points_1 + step, p1_points)

	elif displayed_points_1 > p1_points:
		displayed_points_1 = max(displayed_points_1 - step, p1_points)

	displayed_points_1 = int(displayed_points_1)

	var difference_2 = abs(p2_points - displayed_points_2)
	var step_2 = max(1, difference_2 * 0.2)

	if displayed_points_2 < p2_points:
		displayed_points_2 = min(displayed_points_2 + step_2, p2_points)

	elif displayed_points_2 > p2_points:
		displayed_points_2 = max(displayed_points_2 - step_2, p2_points)

	displayed_points_2 = int(displayed_points_2)


func _spawn_note_feedback(text, player: int):

	if feedback_container == null:
		return

	var feedback = FEEDBACK_SCENE.instantiate()

	feedback.set_text(text)

	if player == 1:
		feedback.global_position = Vector2(128, 240)
	else:
		feedback.global_position = Vector2(280, 240)

	feedback_container.add_child(feedback)
