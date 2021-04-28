extends Node2D

var save_path = "user://save.dat"

func savefile(save=null):
	var data =  {
		"phase" : 1,
		"time" : [[0,0],[0,0],[0,0],[0,0],[0,0]],
		"timer" : [0,0],
		"bestTime" : [0,0],
	}
	var file = File.new()
	var error = file.open(save_path, file.WRITE)
	if error == OK:
		if save == null:
			file.store_var(data)
		else:
			file.store_var(save)
	else:
		file.close()
			
func loadfiles():
	var file = File.new()
	var playerData
	if file.file_exists(save_path):
		var error = file.open(save_path,file.READ)
		if error == OK:
			playerData = file.get_var()
			file.close()
	return playerData

