extends Sprite
export var dir = Vector2()
onready var pos = $Position2D
export var fire = false
export var open = true
signal fire(dir,pos)

func _physics_process(_delta):
	var posi = pos.global_position
	if open:
		$AnimationPlayer.play("fire")
	if fire:
		emit_signal("fire",dir,posi)
		fire = false
		
	
	
	
	
