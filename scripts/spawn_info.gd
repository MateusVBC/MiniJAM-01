extends Resource
class_name SpawnInfo

enum SIDES{BOTTOM, LEFT, RIGHT};

@export var deep_start:int
@export var deep_end:int
@export var enemy:Resource
@export var enemy_num:int
@export var enemy_spawn_delay:int
@export var enemy_spawn_side:Array[SIDES]

var spawn_delay_counter = 0
