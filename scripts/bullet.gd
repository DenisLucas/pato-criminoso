extends KinematicBody2D


export var shoot = false
var dir
var speed = 5
var movel = 300

func _physics_process(_delta):
	if shoot:
		var move = speed * dir
		if move.x >= movel:
			move.x = movel
		elif move.x <= -movel:
			move.x = -movel
		elif move.y >= movel:
			move.y = movel
		elif move.y <= -movel:
			move.x = -movel
		
		dir = move_and_slide(move)
		if dir == null:
			queue_free()
func setDir(direction):
	dir = direction
	shoot = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("ground"):
		queue_free()
		
func quit():
	queue_free()
