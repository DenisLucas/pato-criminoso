extends Node2D


var score = 0
export var minscore = 0 
var sec = 0
var minu = 0
var onending = false
signal updatescore(score)
signal notenough(left)
signal Updatetimer(time)
signal start(left)
var save_path = "user://save.dat"

func _ready():
	var timer = timerLoad()
	minu = timer[0]
	sec = timer[1]
	emit_signal("start",minscore)
	
func _process(_delta):
	if onending:
		if score >= minscore:
			$Timer.stop()
			saveData()
			var _scene = get_tree().change_scene("res://scenes/select.tscn") 
		else:
			var left = minscore - score
			emit_signal("notenough",left)
	
func _on_coins_upscore(quantity):
	score += quantity
	emit_signal("updatescore",score)
	

func _on_fim_body_entered(body):
	if body.is_in_group("player"):
		onending = true

func _on_fim_body_exited(body):
	if body.is_in_group("player"):
		onending = false



func _on_Timer_timeout():
	sec += 1
	if sec >= 60:
		minu += 1
		sec -= 60
	var time = "{min}:{sec}"
	time = time.format({"min": str(minu), "sec": str(sec)})
	emit_signal("Updatetimer",time)

func saveData():
	var file = File.new()
	var playerData
	if file.file_exists(save_path):
		var error = file.open(save_path,file.READ)
		if error == OK:
			playerData = file.get_var()
			file.close()
	if playerData["phase"] < 2:
		playerData["phase"] = 2
	if playerData["time"][0] != [0,0]: 
		if playerData["time"][0][0] > minu:
			 playerData["time"][0] = [minu,sec]
		if playerData["time"][0][0] == minu and playerData["time"][0][1] > sec:
			 playerData["time"][0] = [minu,sec]
	else:
		playerData["time"][0] = [minu,sec]
	playerData["timer"] = [minu,sec]
	var fileS = File.new()
	var error = fileS.open(save_path, file.WRITE)
	if error == OK:
		fileS.store_var(playerData)
		fileS.close()

func timerSave():
	var file = File.new()
	var playerData
	if file.file_exists(save_path):
		var error = file.open(save_path,file.READ)
		if error == OK:
			playerData = file.get_var()
			file.close()
	if playerData != null:
		playerData["timer"][0] = minu
		playerData["timer"][1] = sec
		var files = File.new()
		var error = files.open(save_path, file.WRITE)
		if error == OK:
			files.store_var(playerData)
			files.close()
	else:
		print("erro")

func timerLoad():
	var file = File.new()
	var playerData
	if file.file_exists(save_path):
		var error = file.open(save_path,file.READ)
		if error == OK:
			playerData = file.get_var()
			file.close()
	return playerData["timer"]
	
func _on_hit_body_entered(body):
	if body.is_in_group("player"):
		timerSave()
		var _scene = get_tree().change_scene("res://scenes/test.tscn") 
