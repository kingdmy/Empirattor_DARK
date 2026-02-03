extends Area2D

# 0. НАШ КАСТОМНЫЙ СИГНАЛ
signal interaction_started(npc_name, dialogue_text)

# 1. ДАННЫЕ NPC
@export var npc_name = "Старый Страж"
@export_multiline var dialogue_text = "Привет, путник. "

# 2. ССЫЛКА НА ИГРОКА
var player_in_range = false

func _ready():
	# Подключаем встроенные сигналы Area2D
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":  # Проверяем по имени
		player_in_range = true
		print("NPC: Игрок рядом. Нажми E для разговора")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		print("NPC: Игрок ушёл")

func _process(delta):
	# Если игрок рядом и нажал E - начинаем диалог
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("Начало диалога с ", npc_name)
		# ИСПУСКАЕМ наш кастомный сигнал с данными
		interaction_started.emit(npc_name, dialogue_text)
