extends RigidBody2D

export var threshold = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if linear_velocity.length() > threshold:
		if abs(linear_velocity.x) > abs(linear_velocity.y):
			$AnimatedSprite.play("side_roll")
		else:
			$AnimatedSprite.play("vertical_roll")
	else:
		$AnimatedSprite.stop()
