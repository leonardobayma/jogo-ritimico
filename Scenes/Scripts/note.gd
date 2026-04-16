# Note Node
extends Sprite2D


const SCREEN_BOTTOM := 1000
const TIME_TOLERANCE := {
 "PERFECT": 0.02,
 "GOOD": 0.05,
 "OK": 0.08
}

var speed: float = 100.0
var expected_time: float = 0.0


func _process(delta: float) -> void:
 global_position.y += speed * delta
 


func test_hit(time: float) -> bool:
 return abs(expected_time - time) <= TIME_TOLERANCE.OK

func hit(time: float, player: int) -> void:
 var time_difference: float = abs(expected_time - time)
 
 if time_difference < TIME_TOLERANCE.PERFECT:
  Highscore.update_points(Highscore.TimingJudgement.PERFECT, player)
 elif time_difference < TIME_TOLERANCE.GOOD:
  Highscore.update_points(Highscore.TimingJudgement.GOOD, player)
 else:
  Highscore.update_points(Highscore.TimingJudgement.OK, player)
 speed = 0.0
 var tween = get_tree().create_tween()
 tween.tween_property(self, "scale", Vector2(1.8, 1.8), 0.15)
 tween.parallel().tween_property(self, "modulate", Color(1,1,1,0.0), 0.15)
 tween.tween_callback(queue_free)
 

func test_miss(time: float) -> bool:
 return time > expected_time + TIME_TOLERANCE.OK
 
func miss(player: int) -> void:
 Highscore.update_points(Highscore.TimingJudgement.MISS, player)
 apply_greyscale()
 
func apply_greyscale():
 var mat =  ShaderMaterial.new()
 mat.shader = preload("res://Assets/Shaders/greyscale.gdshader")
 self.material = mat;

var color = Color(1,1,1);

func _ready() -> void:
 $GPUParticles2D.modulate = color;
