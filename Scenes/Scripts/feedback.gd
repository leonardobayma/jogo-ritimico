# Feedback Node
extends Node2D

func _ready() -> void:
 var target_pos = position - Vector2(0,32)
 var tween = get_tree().create_tween()
 tween.tween_property(self, "modulate", Color(1,1,1,0.0), 0.5).set_trans(Tween.TRANS_QUAD)
 tween.parallel().tween_property(self, "position", target_pos, 0.5)
 tween.tween_callback(queue_free)

func set_text(text):
 $BackgroundLabel.text = text;
 $Label.text = text;
