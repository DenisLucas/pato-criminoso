extends Control

func _on_scene_updatescore(score):
	$Label.text = "$%s" % str(score) 


func _on_scene_notenough(left):
	print("hi")
	$Label2.text = "You still needs %s$, to get out" % str(left)
	$Timer.start()
	

func _on_Timer_timeout():
	$Label2.text = ""


func _on_scene_Updatetimer(time):
	$Label3.text = time


func _on_scene_start(left):
		$Label2.text = "You need %s$, to get out of the house" % str(left)
		$Timer.start()
