extends Node2D

@export var spawns: Array[SpawnInfo] = [];

@onready var player = $"../Player"
@onready var deepness = $"../Deepness"
@onready var camera = $"../Camera"

func _on_timer_timeout():
	var enemy_spawns = spawns
	for spawn_info in enemy_spawns:
		if (
			deepness.current_level >= spawn_info.deep_start &&
			deepness.current_level <= spawn_info.deep_end
		):
			if spawn_info.spawn_delay_counter < spawn_info.enemy_spawn_delay:
				spawn_info.spawn_delay_counter += 1
			else:
				spawn_info.spawn_delay_counter = 0
				var new_enemy = spawn_info.enemy
				var counter = 0
				while  counter < spawn_info.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position(spawn_info.enemy_spawn_side)
					add_child(enemy_spawn)
					counter += 1

func get_random_position(spawn_side):
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var camera_width = (vpr.x / camera.zoom.x);
	var camera_height = (vpr.y / camera.zoom.y);
	
	var top_left = Vector2(player.global_position.x - camera_width/2, player.global_position.y - camera_height)
	var top_right = Vector2(player.global_position.x + camera_width/2, player.global_position.y - camera_height)
	var bottom_left = Vector2(player.global_position.x - camera_width/2, player.global_position.y + camera_height)
	var bottom_right = Vector2(player.global_position.x + camera_width/2, player.global_position.y + camera_height)
	var pos_side = 0;
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	if spawn_side.size() == 0:
		pos_side = randi_range(1,3);
	else:
		pos_side = spawn_side.pick_random();
	
	match pos_side:
		SpawnInfo.SIDES.BOTTOM:
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		SpawnInfo.SIDES.RIGHT:
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		SpawnInfo.SIDES.LEFT:
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
