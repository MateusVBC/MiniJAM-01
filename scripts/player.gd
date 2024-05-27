class_name Player
extends Area2D

signal projectile_shoot(projectile)

const EXP_ENUM = preload("res://scripts/exp_enum.gd");
var projectile_scene = preload("res://scenes/projectile.tscn");

@onready var audio_lvl_up = $AudioLvlUp
@onready var gui_layer = $GUILayer
@onready var muzzle = $Muzzle;
@onready var health = $HealthComponent;
@onready var camera = $"../Camera"
@onready var cshape = $CollisionShape2D;
@onready var viewport_size = get_viewport_rect().size;

var speed := Vector2(300, 250);
var melee_damage := 5;
var projectile_damage := 1;
 
@export var bonus_speed := Vector2(0.1,0.1);
@export var bonus_damage := 0.1;
@export var bonus_atack_speed := 1.0;
@export var loot_range_scale := 1.0;

@export var exp_dmg := 0;
@export var exp_mv_spd := 0;
@export var exp_atk_spd := 0;
@export var exp_clct_rng := 0;

var shoot_cd := false;
var damage_cd := false;
var move_player_camera := true;

func _ready():
	remove_child(gui_layer);
	camera.add_child(gui_layer);
	camera.connect("stop_moving_player", func(): move_player_camera = false);
	
	gui_layer.set_max_progress_power(ceil(bonus_damage) * 2);
	gui_layer.set_max_progress_attack_speed(ceil(bonus_atack_speed) * 2);
	gui_layer.set_max_progress_move_speed(ceil(bonus_speed.x) * 2);
	gui_layer.set_max_progress_collect_range(ceil(loot_range_scale) * 50);

func _physics_process(delta):
	global_position += (
		Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		)
		* get_move_speed() * delta
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
			await get_tree().create_timer(1/bonus_atack_speed).timeout
			shoot_cd = false
	
	#movimento da camera
	if move_player_camera:
		global_position.y += 2

func shoot_projectile():
	var projectile = projectile_scene.instantiate()
	projectile.melee_damage = get_projectile_damage();
	projectile.global_position = muzzle.global_position;
	emit_signal("projectile_shoot", projectile); 

func _on_loot_range_area_entered(area):
	if area.is_in_group("exp"):
		area.target = self;

func _on_collet_range_area_entered(area):
	if area.is_in_group("exp"):
		collect_exp(area.type, area.collect())

func collect_exp(type, exp):
		match type:
			EXP_ENUM.EXP_TYPES.DAMAGE:
				exp_dmg += exp;
				gui_layer.set_progress_power(exp_dmg)
				if exp_dmg >= ceil(bonus_damage) * 2:
					audio_lvl_up.play()
					exp_dmg = 0;
					gui_layer.set_progress_power(0)
					bonus_damage += 0.5;
					gui_layer.set_max_progress_power(ceil(bonus_damage) * 2);
					
			EXP_ENUM.EXP_TYPES.ATK_SPD:
				exp_atk_spd += exp
				gui_layer.set_progress_attack_speed(exp_atk_spd)
				if exp_atk_spd >= ceil(bonus_atack_speed) * 2:
					audio_lvl_up.play()
					exp_atk_spd = 0;
					gui_layer.set_progress_attack_speed(0)
					bonus_atack_speed += 0.01;
					gui_layer.set_max_progress_attack_speed(ceil(bonus_atack_speed) * 2);
					
			EXP_ENUM.EXP_TYPES.MV_SPD:
				exp_mv_spd += exp
				gui_layer.set_progress_move_speed(exp_mv_spd)
				if exp_mv_spd >= ceil(bonus_speed.x) * 2:
					audio_lvl_up.play()
					exp_mv_spd = 0;
					gui_layer.set_progress_move_speed(0)
					bonus_speed += Vector2(1, 0.5);
					gui_layer.set_max_progress_move_speed(ceil(bonus_speed.x) * 2);
					
			EXP_ENUM.EXP_TYPES.COLECT_RANGE:

				exp_clct_rng += exp
				gui_layer.set_progress_collect_range(exp_clct_rng)
				if exp_clct_rng >= ceil(loot_range_scale) * 50:
					audio_lvl_up.play()
					exp_clct_rng = 0;
					gui_layer.set_progress_collect_range(0)
					loot_range_scale += 0.1;
					gui_layer.set_max_progress_collect_range(ceil(loot_range_scale) * 50);
					
func get_melee_damage():
	return melee_damage + (bonus_damage * 2);

func get_projectile_damage():
	return projectile_damage + bonus_damage;

func get_move_speed():
	return speed + bonus_speed;

func take_damage(damage):
	if !damage_cd:
		damage_cd = true;
		await get_tree().create_timer(0.5).timeout;
		health.take_damage(damage);
		gui_layer.set_progress_health(health.health);
		damage_cd = false;

func _on_player_died(entity):
	get_tree().reload_current_scene()
