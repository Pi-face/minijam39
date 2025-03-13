extends RigidBody2D 

@export var speed: float = 300  
@export var turn_speed: float = 2.0  
@export var player: Node2D  

var movement_direction: Vector2 = Vector2.UP  

func _ready():
    if player == null:
        var players = get_tree().get_nodes_in_group("player")
        if players.size() > 0:
            player = players[0]

func _physics_process(delta: float) -> void:
    if player == null:
        return

    var target_direction = (player.global_position - global_position).normalized()
    
    if movement_direction != target_direction:
        movement_direction = movement_direction.slerp(target_direction, turn_speed * delta).normalized()

    rotation = movement_direction.angle() + deg_to_rad(90)

    # Use forces instead of setting velocity directly
    var desired_velocity = movement_direction * speed
    linear_velocity = linear_velocity.lerp(desired_velocity, 0.1)  # Smooth acceleration
