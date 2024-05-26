class_name Player
extends Area2D

signal projectile_shoot(projectile)

@onready var muzzle = $Muzzle;
@onready var health = $HealthComponent
var projectile_scene = preload("res://scenes/projectile.tscn");

@export var speed := Vector2(10, 5);

var shoot_cd := false;
var damage_cd := false;
var melee_damage := 5;
var projectile_damage := 1;

#camera max zoom = 0,174
func _physics_process(delta):
	var input_vector := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"));
	global_position += (input_vector * speed);

func _process(delta):
	if Input.is_action_pressed("fire_weapon"):
		if !shoot_cd:
			shoot_cd = true
			shoot_projectile()
			await get_tree().create_timer(1).timeout
			shoot_cd = false

func take_damage(damage):
	if !damage_cd:
		shoot_cd = true;
		health.take_damage(damage);
		await get_tree().create_timer(0.5).timeout;
		shoot_cd = false;

func shoot_projectile():
	var projectile = projectile_scene.instantiate()
	projectile.melee_damage = projectile_damage;
	projectile.global_position = muzzle.global_position;
	emit_signal("projectile_shoot", projectile); 
