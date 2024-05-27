extends Node2D

@onready var projectiles := $Projectiles;
@onready var player := $Player;

@export var deep := 0;

func _ready():
	player.connect("projectile_shoot", _on_player_laser_shot);

func _on_player_laser_shot(projectile):
	projectiles.add_child(projectile);

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene();
