#DP_UI.gd
extends Control

func _process(delta):
	# Pull all dp_label nodes
	var label_list := get_tree().get_nodes_in_group("dp_label")
	if label_list.is_empty():
		return

	var label: Label = label_list[0]
	label.text = str(DPManager.dp)
