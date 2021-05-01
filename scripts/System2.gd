extends Node2D

var score = 0
var sec = 0
var minu = 0
var Psec = 0
var Pminu = 0
var onending = false
var bullets =  []
var sequence = true
export var Nscene = 2
export var minscore = 0 
export var Sscene = 0

const ball = preload("res://scenes/ball.tscn")
export var NS = "res://scenes/select.tscn"

signal updatescore(score)
signal notenough(left)
signal Updatetimer(time)
signal start(left)

onready var saveload = get_node("/root/SaveLoad")

func _ready():
	var timer = timerLoad()
	minu = timer[0]
	sec = timer[1]
	emit_signal("start",minscore)
	
func _process(_delta):
	if Input.is_action_just_pressed("start"):
		sequence = false
		var _scene = get_tree().change_scene("res://scenes/select.tscn") 
	if onending:
		if score >= minscore:
			$Timer.stop()
			saveData()
			var _scene = get_tree().change_scene(NS) 
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
	Psec += 1
	if sec >= 60:
		minu += 1
		sec -= 60
	if Psec >= 60:
		Pminu += 1
		Psec -= 60
	var time = "{min}:{sec}"
	time = time.format({"min": str(minu), "sec": str(sec)})
	emit_signal("Updatetimer",time)

func saveData():
	var playerData = saveload.loadfiles()
	if playerData["phase"] <= Nscene:
		playerData["phase"] = Nscene
	if playerData["time"][Sscene][0] != 0 and playerData["time"][Sscene][1] != 0:
		if playerData["time"][Sscene][0] > Pminu or playerData["time"][Sscene][0] == 0:
			 playerData["time"][Sscene] = [Pminu,Psec]
		if playerData["time"][Sscene][0] == Pminu and playerData["time"][0][1] > Psec:
			 playerData["time"][Sscene] = [Pminu,Psec]
	else:
		playerData["time"][Sscene] = [Pminu,Psec]
	playerData["timer"] = [minu,sec]
	SaveLoad.savefile(playerData)

func timerSave():
	var playerData = SaveLoad.loadfiles()
	if playerData != null:
		playerData["timer"][0] = minu
		playerData["timer"][1] = sec
		SaveLoad.savefile(playerData)
	else:
		print("erro")

func timerLoad():
	var playerData = SaveLoad.loadfiles()
	return playerData["timer"]

	
func _on_hit_body_entered(body):
	if body.is_in_group("player"):
		death()
		
func death():
	timerSave()
	var _scene = get_tree().reload_current_scene()
	 
func _on_blaster_fire(dir,posi):
	var gold = ball.instance()
	$".".add_child(gold)
	gold.global_position = posi
	gold.setDir(dir)
	bullets.append(gold)


func _on_Player_hit():
	death()
