extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

var player_in_range = false
var player_ref = null

func _ready():
	# Подключаем сигналы
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Запускаем idle-анимацию
	if animated_sprite:
		animated_sprite.play("idle")

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("player"):
		player_in_range = true
		player_ref = body
		print("NPC: Игрок вошёл в зону")
		update_facing()  # Поворачиваемся сразу

func _on_body_exited(body):
	if body.name == "Player" or body.is_in_group("player"):
		player_in_range = false
		player_ref = null
		print("NPC: Игрок вышел из зоны")

func _process(delta):
	# Постоянно следим за игроком, пока он в зоне
	if player_in_range and player_ref:
		update_facing()

func update_facing():
	if not player_ref:
		return
	
	# Определяем направление
	if player_ref.global_position.x > global_position.x:
		# Игрок СПРАВА → NPC должен смотреть вправо
		animated_sprite.flip_h = false  # или scale.x = 1.0
	else:
		# Игрок СЛЕВА → NPC должен смотреть влево
		animated_sprite.flip_h = true   # или scale.x = -1.0
