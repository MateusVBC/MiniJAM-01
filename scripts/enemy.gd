extends Area2D

@export var speed := Vector2(3.0, -0.5);
@export var melee_damage := 1;
@onready var health = $HealthComponent;
@onready var cshape = $CollisionShape2D

var on_chase = false;
var player: Player = null;

func _physics_process(delta):
	global_position.y += speed.y;
	if on_chase:
		if (player.global_position.y < global_position.y &&
		abs(player.global_position.x - global_position.x) > (speed.x + cshape.shape.radius)):
			global_position.x += get_axis_player() * speed.x;

func _on_area_entered(area):
	if area is Player:
		health.take_damage(area.melee_damage);
	area.take_damage(melee_damage);

func _on_death(entity):
	#toca animação de morte
	pass # Replace with function body.

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
	pass # Replace with function body.
