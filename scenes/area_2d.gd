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
	if animated_sprite:
		animated_sprite.play("idle")
		
		
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
		is_in_dialogue = false  # Сбрасываем флаг
		
		if e_indicator:
			e_indicator.visible = false

func _process(delta):
	# ПОВОРОТ
	if player_in_range and Input.is_action_just_pressed("interact") and not is_in_dialogue:
		print("NPC: Начинаю диалог")
		is_in_dialogue = true  # Блокируем повторные вызовы
		var dialogue_data = {
			"npc_name": npc_name,
			"lines": dialogue_lines
		}
		interaction_started.emit(dialogue_data)

func update_facing():
	if not player_ref:
		return
	
	var sprite = $AnimatedSprite2D
	if not sprite:
		return
	
	if player_ref.global_position.x > global_position.x:
		sprite.scale.x = -1.0
	else:
		sprite.scale.x = 1.0


func reset_dialogue():
	is_in_dialogue = false
	print("NPC: Диалог сброшен, можно начинать заново")
