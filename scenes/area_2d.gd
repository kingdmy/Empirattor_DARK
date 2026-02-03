extends Area2D

signal interaction_started(dialogue_data)

@onready var animated_sprite = $AnimatedSprite2D

@export var dialogue_lines: Array[String] = [
	"Привет, путник.",
	"Ты в потерянном мире.",
	"Это не лучшее место..."
]
@export var npc_name = "Хранитель"

var is_in_dialogue = false
var player_in_range = false
var player_ref = null

@onready var e_indicator = $EIndicator  # Ссылка на Label

func _ready():
	# Инициализация спрайта
	if animated_sprite:
		animated_sprite.play("idle")
	
	# Подключаем сигналы
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Ищем UI и подключаем сигнал окончания диалога
	await get_tree().create_timer(0.1).timeout  # Ждём инициализации сцены
	connect_to_ui()
	
	# Скрываем индикатор при старте
	if e_indicator:
		e_indicator.visible = false

# Подключение к UI
func connect_to_ui():
	var ui = get_tree().get_first_node_in_group("dialogue_ui")
	if ui:
		# Подключаем сигнал окончания диалога
		if ui.has_signal("dialogue_finished"):
			ui.dialogue_finished.connect(reset_dialogue)
			print("NPC: Подключён к UI сигналу dialogue_finished")
		else:
			print("NPC: UI не имеет сигнала dialogue_finished")

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("player"):
		player_in_range = true
		player_ref = body
		update_facing()
		
		# ПОКАЗЫВАЕМ индикатор [E]
		if e_indicator:
			e_indicator.visible = true
			print("NPC: Показываю индикатор [E]")

func _on_body_exited(body):
	if body.name == "Player" or body.is_in_group("player"):
		player_in_range = false
		player_ref = null
		is_in_dialogue = false  # Сбрасываем флаг
		
		# СКРЫВАЕМ индикатор [E]
		if e_indicator:
			e_indicator.visible = false
			print("NPC: Скрываю индикатор [E]")

func _process(delta):
	# ПОВОРОТ к игроку
	if player_in_range and player_ref:
		update_facing()
	
	# НАЧАЛО ДИАЛОГА
	if player_in_range and Input.is_action_just_pressed("interact") and not is_in_dialogue:
		start_dialogue()

# Запуск диалога
func start_dialogue():
	print("NPC: Начинаю диалог")
	is_in_dialogue = true  # Блокируем повторные вызовы
	
	# Скрываем индикатор E во время диалога
	if e_indicator:
		e_indicator.visible = false
	
	var dialogue_data = {
		"npc_name": npc_name,
		"lines": dialogue_lines
	}
	
	# Пробуем новый метод с привязкой к NPC
	var ui = get_tree().get_first_node_in_group("dialogue_ui")
	if ui and ui.has_method("show_journal_over_npc"):
		print("NPC: Использую новый метод show_journal_over_npc")
		ui.show_journal_over_npc(self, dialogue_data)
	else:
		# Fallback на старый метод
		print("NPC: Использую старый метод (сигнал)")
		interaction_started.emit(dialogue_data)

func update_facing():
	if not player_ref:
		return
	
	if player_ref.global_position.x > global_position.x:
		animated_sprite.flip_h = true  # Игрок справа → смотрим вправо
	else:
		animated_sprite.flip_h = false   # Игрок слева → смотрим влево

# Сброс диалога (вызывается из UI)
func reset_dialogue():
	is_in_dialogue = false
	print("NPC: Диалог сброшен, можно начинать заново")
	
	# Показываем индикатор E снова, если игрок ещё в зоне
	if player_in_range and e_indicator:
		e_indicator.visible = true
