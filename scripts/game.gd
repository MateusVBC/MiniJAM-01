extends Node2D

@onready var projectiles := $Projectiles;
@onready var player := $Player;

@export var deep := 0;

func _ready():
	player.connect("projectile_shoot", _on_player_laser_shot);

func _on_player_laser_shot(projectile):
	projectiles.add_child(projectile);
