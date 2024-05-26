extends Area2D

signal enemy_death(enemy);

const Experience = preload("res://scenes/experience.tscn")
const EXP_ENUM = preload("res://scripts/exp_enum.gd")

@export var speed := Vector2(100.0, -1);
@export var melee_damage := 1;
@export var xp_drop = Vector2(1,3);

@onready var health = $HealthComponent;
@onready var cshape = $CollisionShape2D

var on_chase = false;
var player: Player = null;

func _physics_process(delta):
	global_position.y += speed.y;
	if on_chase:
		if (player.global_position.y < global_position.y &&
		abs(player.global_position.x - global_position.x) > (speed.x + cshape.shape.radius)):
			global_position.x += get_axis_player() * speed.x * delta;

func _on_area_entered(area):
	if area is Player:
		health.take_damage(area.melee_damage);
	area.take_damage(melee_damage);

func _on_death(entity):
	var xp = Experience.instantiate();
	xp.global_position = global_position;
	xp.experience = randf_range(xp_drop.x, xp_drop.y)
	xp.type = randf_range(0, EXP_ENUM.EXP_TYPES.size()-1)
	emit_signal("enemy_death", xp);

func _on_agro_entered(area):
	if player == null:
		player = area; 
	on_chase = true;

func _on_agro_exited(area):
	on_chase = false;

func _take_damage(damage):
	health.take_damage(damage);

func get_axis_player() -> int:
	if player.global_position.x > global_position.x:
		return 1  
	elif player.global_position.x < global_position.x:
		return -1 
	else:
		return 0 

func _on_screen_exited():
	await get_tree().create_timer(1.0).timeout
	queue_free()
