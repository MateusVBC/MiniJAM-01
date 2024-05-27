extends CanvasLayer

@onready var power_progress = $GUI/PowerProgress
@onready var movement_speed_progress = $GUI/MovementSpeedProgress
@onready var attack_speed_progress = $GUI/AttackSpeedProgress
@onready var collect_range_progress = $GUI/CollectRangeProgress
@onready var health_bar = $GUI/HealthBar

func set_progress_power(progress: float):
	power_progress.value = progress;
	
func set_progress_attack_speed(progress: float):
	attack_speed_progress.value = progress;
	
func set_progress_move_speed(progress: float):
	movement_speed_progress.value = progress;
	
func set_progress_collect_range(progress: float):
	collect_range_progress.value = progress;
	
func set_progress_health(progress: float):
	health_bar.value = progress;
	

func set_max_progress_power(progress: float):
	power_progress.max_value = progress;
	
func set_max_progress_attack_speed(progress: float):
	attack_speed_progress.max_value = progress;
	
func set_max_progress_move_speed(progress: float):
	movement_speed_progress.max_value = progress;
	
func set_max_progress_collect_range(progress: float):
	collect_range_progress.max_value = progress;
