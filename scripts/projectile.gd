class_name Projectile
extends Area2D

@export var speed := 1000.0;
@export var melee_damage := 1;
@export var piercing := 1;
var last_area = null;

var movement_vector := Vector2(0, 1);

func _physics_process(delta):
	global_position += movement_vector * speed * delta;

func _on_screen_exited(): 
	queue_free();

func _on_area_entered(area: Area2D):
	if area.has_method('_take_damage') && area != last_area:
		last_area = area;
		area._take_damage(melee_damage);
		spent_pierce();

func spent_pierce():
	piercing -= 1;
	if piercing <= 0:
		queue_free();
