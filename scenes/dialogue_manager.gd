extends Node

signal dialogue_started(npc_name, lines)
signal dialogue_continued()
signal dialogue_ended()

var is_dialogue_active = false

func start_dialogue(npc_name, lines):
	if is_dialogue_active:
		return
	
	is_dialogue_active = true
	dialogue_started.emit(npc_name, lines)
	print("Диалог-менеджер: диалог начат")

func continue_dialogue():
	if not is_dialogue_active:
		return	
	
	dialogue_continued.emit()
	print("Диалог-менеджер: продолжаем")

func end_dialogue():
	is_dialogue_active = false
	dialogue_ended.emit()
	print("Диалог-менеджер: диалог окончен")
