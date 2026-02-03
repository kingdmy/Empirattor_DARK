extends Area2D

signal interaction_started(dialogue_data)

@export var dialogue_lines: Array[String] = [
	"Привет, путник.",
	"Ты в потерянном мире.",
	"Это не лучшее место..."
]
@export var npc_name = "Хранитель"

var player_in_range = false
var player_ref = null

@onready var e_indicator = $EIndicator  # Ссылка на Label

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Скрываем индикатор при старте
	if e_indicator:
		e_indicator.visible = false

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
		
		# СКРЫВАЕМ индикатор [E]
		if e_indicator:
			e_indicator.visible = false
			print("NPC: Скрываю индикатор [E]")

func _process(delta):
	# ПОВОРОТ
	if player_in_range and player_ref:
		update_facing()
	
	# ДИАЛОГ
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("NPC: Кнопка E нажата, отправляю сигнал")
		var dialogue_data = {
			"npc_name": npc_name,
			"lines": dialogue_lines
		}
		interaction_started.emit(dialogue_data)

func update_facing():
	if not player_ref:
		return
	
	var sprite = $Sprite2D
	if not sprite:
		return
	
	if player_ref.global_position.x > global_position.x:
		sprite.scale.x = -1.0
	else:
		sprite.scale.x = 1.0
