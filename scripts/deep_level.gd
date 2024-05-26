extends Area2D
@export var level := 0;

signal _player_entered_deep_level(level);

func _on_area_entered(area):
	if area is Player:
		emit_signal("_player_entered_deep_level", level);
