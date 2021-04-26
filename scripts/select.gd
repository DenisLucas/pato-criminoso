extends Node2D

var save_path = "user://save.dat"
export var phasesU = 1
var time = []
var selPhase = 0

func _ready():
	var data = loadData()
	if data != null:
		phasesU = data["phase"]
		$phase1/Label.text = "{sec}:{min}".format({"sec":data["time"][0][0],"min":data["time"][0][1]})
	else:
		phasesU = 1
func _process(_delta):
	if phasesU >= 1:
		$phase1/CollisionShape2D.disabled = false
	if phasesU >= 2:
		$phase2/CollisionShape2D.disabled = false
	if phasesU >= 3:
		$phase3/CollisionShape2D.disabled = false
	if phasesU >= 4:
		$phase4/CollisionShape2D.disabled = false
	if phasesU >= 5:
		$phase5/CollisionShape2D.disabled = false
	
	if Input.is_action_just_pressed("click"):
		if selPhase == 1:
			var _scene = get_tree().change_scene("res://scenes/test.tscn") 

func _on_phase1_mouse_entered():
	selPhase = 1
func _on_phase2_mouse_entered():
	selPhase = 2
func _on_phase3_mouse_entered():
	selPhase = 3
func _on_phase4_mouse_entered():
	selPhase = 4
func _on_phase5_mouse_entered():
	selPhase = 5
func _on_phase_mouse_exited():
	selPhase = 0

func saveData():
	var data =  {
		"phase" : 1,
		"time" : [[0,0],[0,0],[0,0],[0,0],[0,0]],
		"timer" : [0,0],
		"bestTime" : [0,0],
	}
	var file = File.new()
	if !file.file_exists(save_path):
		var error = file.open(save_path, file.WRITE)
		if error == OK:
			file.store_var(data)
			file.close()
	loadData()
	
func loadData():
	var file = File.new()
	var playerData
	if file.file_exists(save_path):
		var error = file.open(save_path,file.READ)
		if error == OK:
			playerData = file.get_var()
			file.close()
	else:
		saveData()
	return playerData
			

