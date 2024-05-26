extends Node

signal died(entity)

var health := 0.0;
@export var max_health = 5;

func _ready():
	health = max_health;

func take_damage(damage):
	health -= damage;
	print('tomou dano ' + str(damage) + ' de dano')
	if(health <= 0):
		emit_signal("died", self);
		$"..".queue_free();
	

func heal(health_value):
	if(health + health_value <= max_health):
		health += health_value;
	else:
		health = max_health;
