extends Node2D

onready var day_1 = [$Bed, $Fridge, $Desk, $Fridge, $Couch]
var day = []

var currentPos: int = 0;

var target
const speed: int = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	
	day = day_1.duplicate(true)
	$Body.position = day[currentPos].position
	target = day[currentPos].position
	update_target()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		$Body.position = $Body.position.move_toward(target, delta * speed)
		var distance = $Body.position.distance_to(target)
		
		if  distance <= 1:
			target = null

func _on_Schedule_timeout():
	update_target()
	
func update_target():
	currentPos = (currentPos + 1) % day.size()
	target = day[currentPos].position
