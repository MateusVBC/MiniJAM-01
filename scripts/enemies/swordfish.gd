extends Area2D

signal enemy_death(enemy);

const EXPERIENCE = preload("res://scenes/experience.tscn")
const EXP_ENUM = preload("res://scripts/exp_enum.gd")
const VARIANT_SPRITE = preload("res://assets/sprites/enemies/swordfish_saw.png")

@onready var health = $HealthComponent;
@onready var cshape = $CollisionShape2D;
@onready var sprite = $Sprite2D;

@export var speed := Vector2(100.0, 100.0);
@export var melee_damage := 1;
@export var xp_drop = Vector2(3,7);

var flip = null;
var variant := false;
var entered_screen := false;
var exp_type: Array[EXP_ENUM.EXP_TYPES] = [];
var on_chase = false;
var player: Player = null;

func _ready():
	
	#valida se é variante
	if randf() < 0.1:
		exp_type = [EXP_ENUM.EXP_TYPES.DAMAGE, EXP_ENUM.EXP_TYPES.MV_SPD]
		sprite.texture = VARIANT_SPRITE;
		speed.x = 200.0;
		melee_damage = 3;
	else: 
		exp_type = [EXP_ENUM.EXP_TYPES.COLECT_RANGE, EXP_ENUM.EXP_TYPES.ATK_SPD]
		
	if flip == null:
		flip = [-1,1].pick_random();
		
	if flip < 0:
		$Sprite2D.flip_h = true;
		
	await get_tree().create_timer(0.5).timeout
	if not entered_screen:
		queue_free();
	
func _process(delta):
		global_position.y += 2

func _physics_process(delta):
	global_position.x += (speed.x * delta) * flip;
	if on_chase:
		if (abs(player.global_position.y - global_position.y) > ((speed.y * delta) + cshape.shape.radius)):
			var a = get_axis_player()
			global_position.y += get_axis_player() * (speed.y * delta);

func _on_area_entered(area):
	if area is Player:
		health.take_damage(area.get_melee_damage());
	area.take_damage(melee_damage);

func _on_death(entity):
	var xp = EXPERIENCE.instantiate();
	xp.global_position = global_position;
	xp.experience = randi_range(xp_drop.x, xp_drop.y)
	xp.type = randf_range(0, EXP_ENUM.EXP_TYPES.size())
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
	if player.global_position.y > global_position.y:
		return 1
	else:
		return 0 

func _on_screen_exited():
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _entered_screen():
	entered_screen = true;
