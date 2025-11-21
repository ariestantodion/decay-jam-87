#DP_UI.gd
extends Control

func _process(delta):
	$DP_Label.text = str(DPManager.dp)
