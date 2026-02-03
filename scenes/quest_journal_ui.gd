extends CanvasLayer

signal dialogue_finished

@onready var name_label = $Panel/NameLabel
@onready var dialogue_label = $Panel/DialogueLabel
@onready var panel = $Panel
@onready var continue_label = $Panel/ContinueLabel

# Таймер НЕ через @onready, а как обычная переменная
var type_timer: Timer

# ... остальные переменные без изменений ...
var dialogue_lines: Array[String] = []
var current_line_index = 0
var is_typing = false
var type_speed = 0.05
var current_text = ""
var char_index = 0

func _ready():
	# 1. Сначала создаём и настраиваем таймер
	type_timer = Timer.new()
	add_child(type_timer)
	type_timer.timeout.connect(_on_type_timeout)
	type_timer.wait_time = type_speed
	type_timer.name = "TypeTimer"
	# 2. Теперь можно прятать журнал (таймер уже создан)
	hide_journal()

func show_journal(dialogue_data):
	current_line_index = 0
	is_typing = false
	type_timer.stop()
	name_label.text = dialogue_data["npc_name"]
	dialogue_lines = dialogue_data["lines"]
	dialogue_label.text = ""
	
	panel.visible = true
	start_typing_line()  # Начинаем печатать первую реплику

func start_typing_line():
	if current_line_index >= dialogue_lines.size():
		hide_journal()
		return
	
	current_text = dialogue_lines[current_line_index]
	char_index = 0
	is_typing = true
	dialogue_label.text = ""
	type_timer.start()  # Запускаем таймер через переменную

func _on_type_timeout():
	if char_index < current_text.length():
		dialogue_label.text += current_text[char_index]
		char_index += 1
	else:
		is_typing = false
		type_timer.stop()
		# Показываем подсказку "Продолжить"
		continue_label.visible = true

func hide_journal():
	panel.visible = false
	dialogue_lines.clear()
	current_line_index = 0
	is_typing = false
	type_timer.stop()
	continue_label.visible = false
	dialogue_finished.emit()  # Скрываем подсказку при закрытии

func _process(delta):
	if not panel.visible:
		return
	
	# Если нажали E во время диалога
	if Input.is_action_just_pressed("interact"):
		if is_typing:
			# Пропустить анимацию - показать весь текст сразу
			dialogue_label.text = current_text
			char_index = current_text.length()
			is_typing = false
			type_timer.stop()
			continue_label.visible = true
		else:
			# Перейти к следующей реплике
			current_line_index += 1
			continue_label.visible = false
			start_typing_line()

func _on_close_button_pressed():
	hide_journal()
