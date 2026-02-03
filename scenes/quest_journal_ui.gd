extends CanvasLayer

signal dialogue_finished

@onready var name_label = $Panel/NameLabel
@onready var dialogue_label = $Panel/DialogueLabel
@onready var panel = $Panel
@onready var continue_label = $Panel/ContinueLabel

var type_timer: Timer
var dialogue_lines: Array[String] = []
var current_line_index = 0
var is_typing = false
var type_speed = 0.05
var current_text = ""
var char_index = 0

func _ready():
	# Регистрируем в группе
	add_to_group("dialogue_ui")
	
	# Таймер
	type_timer = Timer.new()
	add_child(type_timer)
	type_timer.timeout.connect(_on_type_timeout)
	type_timer.wait_time = type_speed
	type_timer.name = "TypeTimer"
	
	hide_journal()

# Старая функция (фиксированная позиция)
func show_journal(dialogue_data):
	current_line_index = 0
	is_typing = false
	type_timer.stop()
	name_label.text = dialogue_data["npc_name"]
	dialogue_lines = dialogue_data["lines"]
	dialogue_label.text = ""
	
	panel.visible = true
	# Центрируем
	panel.position = get_viewport().get_visible_rect().size / 2 - panel.size / 2
	
	start_typing_line()

# НОВАЯ: Журнал над NPC
func show_journal_over_npc(npc_node, dialogue_data):
	print("UI: Показываю журнал над NPC")
	
	current_line_index = 0
	is_typing = false
	type_timer.stop()
	
	name_label.text = dialogue_data["npc_name"]
	dialogue_lines = dialogue_data["lines"]
	dialogue_label.text = ""
	
	panel.visible = true
	
	# Позиционируем над NPC
	position_over_npc(npc_node)
	
	start_typing_line()

# Позиционирование над NPC
func position_over_npc(npc_node):
	if not npc_node:
		return
	
	var npc_pos = npc_node.global_position
	var camera = get_viewport().get_camera_2d()
	
	if camera:
		var camera_pos = camera.global_position
		var viewport = get_viewport().get_visible_rect()
		
		# NPC позиция на экране
		var screen_pos = (npc_pos - camera_pos) + viewport.size / 2
		
		# Поднимаем выше NPC
		screen_pos.y -= 150
		
		# Ограничиваем краями
		screen_pos.x = clamp(screen_pos.x, panel.size.x / 2, viewport.size.x - panel.size.x / 2)
		screen_pos.y = clamp(screen_pos.y, panel.size.y / 2, viewport.size.y - panel.size.y / 2)
		
		panel.position = screen_pos - panel.size / 2
	else:
		# Фолбэк
		panel.position = get_viewport().get_visible_rect().size / 2 - panel.size / 2
		panel.position.y -= 100

func start_typing_line():
	if current_line_index >= dialogue_lines.size():
		hide_journal()
		return
	
	current_text = dialogue_lines[current_line_index]
	char_index = 0
	is_typing = true
	dialogue_label.text = ""
	type_timer.start()

func _on_type_timeout():
	if char_index < current_text.length():
		dialogue_label.text += current_text[char_index]
		char_index += 1
	else:
		is_typing = false
		type_timer.stop()
		continue_label.visible = true

func hide_journal():
	panel.visible = false
	dialogue_lines.clear()
	current_line_index = 0
	is_typing = false
	type_timer.stop()
	continue_label.visible = false
	dialogue_finished.emit()

func _process(delta):
	if not panel.visible:
		return
	
	if Input.is_action_just_pressed("interact"):
		if is_typing:
			dialogue_label.text = current_text
			char_index = current_text.length()
			is_typing = false
			type_timer.stop()
			continue_label.visible = true
		else:
			current_line_index += 1
			continue_label.visible = false
			start_typing_line()

func _on_close_button_pressed():
	hide_journal()
