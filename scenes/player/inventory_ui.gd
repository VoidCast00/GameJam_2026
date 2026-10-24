extends PanelContainer

@onready var inventory:Node = $"../Inventory"
@onready var item_list: VBoxContainer = $MarginContainer/VBoxContainer/ItemList


func _ready() -> void:
	if not inventory:
		push_error("inventory not set in inspector")
		return
	inventory.changed.connect(_on_changed)
	refresh()


func _on_changed(_item: String, _amount: int) -> void:
	refresh()



func refresh() -> void:
	for child in item_list.get_children():
		child.queue_free()


	if inventory.items.is_empty():
		add_row("empty")
		return

	for item in inventory.items:
		add_row("%s: %d" % [item, inventory.items[item]])


func add_row(text: String) -> void:
	var label := Label.new()
	label.text = text
	item_list.add_child(label)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = !visible
