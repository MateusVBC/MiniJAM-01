extends Node
class_name ExperienceManager

func _on_enemy_death_create_exp(exp):
	call_deferred("add_child", exp);
