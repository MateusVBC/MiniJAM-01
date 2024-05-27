extends Node
class_name Deepness

var current_level := 1;

func _ready():
	for child in get_children():
		child.connect("_player_entered_deep_level", refresh_deep_level);

func refresh_deep_level(level):
	if level > current_level:
		current_level = level;
