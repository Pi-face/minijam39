extends Area2D

@export var speed: float = 600  # Speed of the bullet
@export var direction: Vector2 = Vector2.UP  # Default direction (moves up)

func _ready():
    await get_tree().create_timer(3.0).timeout
    queue_free()  # Destroy bullet after 3 seconds

func _physics_process(delta):
    position += direction * speed * delta  # Moves the bullet automatically