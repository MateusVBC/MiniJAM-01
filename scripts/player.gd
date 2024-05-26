class_name Player
extends Area2D

signal projectile_shoot(projectile)

@onready var muzzle = $Muzzle;
@onready var health = $HealthComponent;
@onready var camera = $"../Camera"
@onready var cshape = $CollisionShape2D;
@onready var viewport_size = get_viewport_rect().size;

var projectile_scene = preload("res://scenes/projectile.tscn");

var speed := Vector2(300, 250);
var melee_damage := 5;

@export var projectile_damage := 1;
@export var loot_range_scale := 1;

@export var exp_dmg := 0;
@export var exp_mv_spd := 0;
@export var exp_atk_spd := 0;
@export var exp_clct_rng := 0;

var shoot_cd := false;
var damage_cd := false;
var move_player_camera := true;

func _ready():
	camera.connect("stop_moving_player", func(): move_player_camera = false)

#camera max zoom = 0,174
func _physics_process(delta):
	global_position += (
		Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		)
		* speed * delta
		);
	
	var camera_width = (viewport_size.x / camera.zoom.x) / 2;
	var camera_height = (viewport_size.y / camera.zoom.y) / 2;
	var cshap_width = (cshape.shape.radius * PI);
	
	global_position.x = clamp(
		global_position.x,
		(-camera_width + cshap_width),
		(camera_width - cshap_width)
	);
	
	global_position.y = clamp(
		global_position.y,
		(-camera_height + cshap_width) + camera.global_position.y,
		(camera_height - cshap_width) + camera.global_position.y
		);

func _process(delta):
	if Input.is_action_pressed("fire_weapon"):
		if !shoot_cd:
			shoot_cd = true
			shoot_projectile()
			await get_tree().create_timer(1).timeout
			shoot_cd = false
	
	#movimento da camera
	if move_player_camera:
		global_position.y += 2

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

func _on_loot_range_area_entered(area):
	if area.is_in_group("exp"):
		area.target = self;

enum TYPES{DAMAGE, ATK_SPD, MV_SPD, COLECT_RANGE}
func _on_collet_range_area_entered(area):
	if area.is_in_group("exp"):
		match area.type:
			area.TYPES.DAMAGE:
				
			
