extends Node2D

var animation = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	animation += delta
	

	
	$ByGuglopwn.rotation -= cos(animation)*0.005/2
	
	$AndGhost.position -= Vector2(cos(animation/2)*1,cos(animation)*0.5)/2
	
	if animation > 12.566:
		animation -= 12.566
