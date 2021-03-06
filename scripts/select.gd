extends Node2D

var save_path = "user://save.dat"
export var phasesU = 1
var time = []
var selPhase = 0

func _ready():
	var saveload = get_node("SaveLoad")
	var data = saveload.loadfiles()
	if data == null:
		saveload.savefile()
	if data != null:
		phasesU = data["phase"]
		$phase1/Label.text = "{sec}:{min}".format({"sec":data["time"][0][0],"min":data["time"][0][1]})
		$phase2/Label2.text = "{sec}:{min}".format({"sec":data["time"][1][0],"min":data["time"][1][1]})
		$phase3/Label3.text = "{sec}:{min}".format({"sec":data["time"][2][0],"min":data["time"][2][1]})
		$phase4/Label4.text = "{sec}:{min}".format({"sec":data["time"][3][0],"min":data["time"][3][1]})
		$phase5/Label5.text = "{sec}:{min}".format({"sec":data["time"][4][0],"min":data["time"][4][1]})
		data["timer"] = [0,0]
		saveload.savefile(data)
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
		elif selPhase == 2:
			var _scene = get_tree().change_scene("res://scenes/phase2.tscn")
		elif selPhase == 3:
			var _scene = get_tree().change_scene("res://scenes/phase3.tscn") 

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




