extends Area2D

const FOOD_FULL = 1
const FOOD_EMPTY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func refill():
	$AnimatedSprite.frame = FOOD_FULL

func empty():
	$AnimatedSprite.frame = FOOD_EMPTY

func _on_Food_area_entered(area):
	if area.name == "Body":
		refill()
