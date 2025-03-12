extends CharacterBody2D

@export var speed = 100 
@export var turn_speed = 0.07
@export var bullet_scene: PackedScene  
@export var fire_rate: float = 0.2  

var slerp_ratio = 0.0
var movement_direction : Vector2 = Vector2.UP

func _ready():
	start_shooting()

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("steer_left", "steer_right", "steer_up", "steer_down")
	
	if input_direction != Vector2.ZERO and movement_direction != input_direction:
		slerp_ratio += delta * turn_speed
		movement_direction = movement_direction.slerp(input_direction, slerp_ratio).normalized()
	else:
		slerp_ratio = 0.0

	rotation = atan2(movement_direction.y, movement_direction.x) + deg_to_rad(90)
	global_position += movement_direction * speed * delta

func start_shooting():
	while true:
		shoot()
		await get_tree().create_timer(fire_rate).timeout  # Control the shooting speed

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.position = global_position
		bullet.rotation = rotation
		bullet.direction = movement_direction 
		get_parent().add_child(bullet)
