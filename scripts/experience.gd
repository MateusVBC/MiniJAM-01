extends Area2D


const EXP_ENUM = preload("res://scripts/exp_enum.gd");

var spr_green = preload("res://assets/sprites/experience/green_esphere.png")
var spr_yellow = preload("res://assets/sprites/experience/yellow_gem.png")
var spr_red = preload("res://assets/sprites/experience/red_crystal.png")
var spr_grey = preload("res://assets/sprites/experience/grey_crystal.png")

var target = null
var speed := 0
var type: EXP_ENUM.EXP_TYPES = EXP_ENUM.EXP_TYPES.DAMAGE;

@export var experience = 1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected

func _ready():
	match type:
		EXP_ENUM.EXP_TYPES.DAMAGE:
			sprite.texture = spr_red
		EXP_ENUM.EXP_TYPES.ATK_SPD:
			sprite.texture = spr_yellow
		EXP_ENUM.EXP_TYPES.MV_SPD:
			sprite.texture = spr_green

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 100*delta

func collect():
	sound.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return experience

func _on_snd_collected_finished():
	queue_free()
