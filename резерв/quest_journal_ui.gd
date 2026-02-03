extends CanvasLayer

# Ссылки на элементы UI (назначь их в редакторе!)
@onready var name_label = $Panel/NameLabel
@onready var dialogue_label = $Panel/DialogueLabel
@onready var panel = $Panel

func _ready():
	# Прячем журнал при старте
	hide_journal()

func show_journal(name_from_signal, text_from_signal):  # ДВА параметра!
	name_label.text = name_from_signal
	dialogue_label.text = text_from_signal
	panel.visible = true

func hide_journal():
	panel.visible = false  # Прячем панель

# Вызывается при нажатии кнопки закрытия (назначь в редакторе)
func _on_close_button_pressed():
	hide_journal()
