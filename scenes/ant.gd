extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("npc")  # ← вот эта строка!
	# Запускаем idle-анимацию при старте
	if animated_sprite:
		animated_sprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
