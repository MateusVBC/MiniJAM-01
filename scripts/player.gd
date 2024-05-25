extends CharacterBody2D

@export var speed := Vector2(10, 5);

var shoot_cd := false;

#camera zoom = 0,175
func _physics_process(delta):

	var input_vector := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"));
	global_position += (input_vector * speed);

func _process(delta):
	if Input.is_action_pressed("fire_weapon"):
		if !shoot_cd:
			shoot_cd = true
			shot_laser()
			await get_tree().create_timer(0.5).timeout
			shoot_cd = false

func shot_laser():
	var laser = laser_scene.instantiate()
	laser.global_position = muzzle.global_position;
	laser.rotation_degrees = rotation_degrees + 180;
	emit_signal("laser_shot", laser);
