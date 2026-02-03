extends Area2D

signal interaction_started(dialogue_data)  # Изменили сигнал!

# Массив реплик NPC
@export var dialogue_lines: Array[String] = [
	"Привет, путник.",
	"Ты в потерянном мире.",
    "Это не лучшее место..."
]
@export var npc_name = "Хранитель"

var player_in_range = false
var current_line = 0  # Текущая реплика

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("NPC: Кнопка E нажата, отправляю сигнал")
		var dialogue_data = {
			"npc_name": npc_name,
			"lines": dialogue_lines
		}
		interaction_started.emit(dialogue_data)
