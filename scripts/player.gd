extends CharacterBody2D

@export var speed := Vector2(10, 5);

#camera zoom = 0,175
func _physics_process(delta):

	var input_vector := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"));
	
	global_position += (input_vector * speed)

	move_and_slide()
