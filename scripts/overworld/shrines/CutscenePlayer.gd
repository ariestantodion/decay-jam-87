#CutscenePlayer	
extends Node

var playing := false

var original_cam_pos: Vector2
var original_cam_zoom: Vector2

@onready var shrine := get_parent()
@onready var visuals := shrine.get_node("ShrineVisuals")
@onready var anim := visuals.get_node("AnimationPlayer")
@onready var popup := get_tree().get_nodes_in_group("popup_panel")[0]
@onready var icon := visuals.get_node("AbilitySymbolSprite")


func play_cutscene():
	if playing:
		return
	playing = true

	var player = get_tree().current_scene.get_node("Player")
	player.set_physics_process(false)

	# Camera reference
	var cam = get_viewport().get_camera_2d()
	original_cam_pos = cam.global_position
	original_cam_zoom = cam.zoom

	# (1) Pan to shrine
	await pan_camera_to_shrine(cam)

	# (2) Zoom in on ability symbol
	await zoom_in_on_symbol(cam)

	# (3) Symbol explosion zoom
	await explode_symbol()

	# (4) Restore camera zoom & position
	await reset_camera(cam)

	# (5) Popup & ability unlock
	show_popup("POISON ABILITY UNLOCKED")
	AbilityManager.unlock("poison")

	# Keep popup visible briefly
	await get_tree().create_timer(1.8).timeout
	hide_popup()

	# (6) Restore player control
	player.set_physics_process(true)
	playing = false



# ---------------------------------------------------------
# CAMERA PAN
# ---------------------------------------------------------

func pan_camera_to_shrine(cam: Camera2D) -> void:
	var tween = create_tween()
	tween.tween_property(
		cam,
		"global_position",
		shrine.global_position,
		0.8
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished



# ---------------------------------------------------------
# ZOOM IN ON SYMBOL
# ---------------------------------------------------------

func zoom_in_on_symbol(cam: Camera2D) -> void:
	var tween = create_tween()

	tween.tween_property(
		cam,
		"zoom",
		Vector2(0.4, 0.4),  # zoom in
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await tween.finished



# ---------------------------------------------------------
# SYMBOL EXPLOSION ZOOM
# ---------------------------------------------------------

func explode_symbol() -> void:
	icon.scale = Vector2(1, 1)
	icon.visible = true

	var tween = create_tween()

	# Scale from normal size to huge (covers screen)
	tween.tween_property(
		icon,
		"scale",
		Vector2(10, 10),
		0.4
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Optional glow boost (if GlowSprite exists)
	if visuals.has_node("GlowSprite"):
		var glow = visuals.get_node("GlowSprite")
		tween.parallel().tween_property(
			glow,
			"modulate:a",
			2.0,
			0.3
		)

	await tween.finished

	# Remove icon explosively
	icon.visible = false



# ---------------------------------------------------------
# RESET CAMERA
# ---------------------------------------------------------

func reset_camera(cam: Camera2D) -> void:
	var tween = create_tween()

	# Reset zoom
	tween.tween_property(
		cam,
		"zoom",
		original_cam_zoom,
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Reset position
	tween.parallel().tween_property(
		cam,
		"global_position",
		original_cam_pos,
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await tween.finished



# ---------------------------------------------------------
# POPUP HANDLING
# ---------------------------------------------------------

func show_popup(text: String):
	popup.visible = true
	popup.get_node("Label").text = text
	popup.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(
		popup,
		"modulate:a",
		1.0,
		0.3
	)


func hide_popup():
	var tween = create_tween()
	tween.tween_property(
		popup,
		"modulate:a",
		0.0,
		0.3
	)
	await tween.finished
	popup.visible = false
