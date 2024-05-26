extends Area2D

enum TYPES{DAMAGE, ATK_SPD, MV_SPD, COLECT_RANGE}

var spr_green = preload("res://assets/sprites/experience/green_square.png")
var spr_yellow = preload("res://assets/sprites/experience/yellow_square.png")
var spr_red = preload("res://assets/sprites/experience/red_square.png")
var spr_grey = preload("res://assets/sprites/experience/red_square.png")

var target = null
var speed := -1
var type: TYPES = TYPES.DAMAGE;

@export var experience = 1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected

func _ready():
	match type:
		TYPES.DAMAGE:
			sprite.texture = spr_red
		TYPES.ATK_SPD:
			sprite.texture = spr_yellow
		TYPES.MV_SPD:
			sprite.texture = spr_green

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	sound.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return experience

func _on_snd_collected_finished():
	queue_free()
