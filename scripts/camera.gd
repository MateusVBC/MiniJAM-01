extends Camera2D

signal stop_moving_player()

func _stop_moving_player():
	emit_signal("stop_moving_player");
