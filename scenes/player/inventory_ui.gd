extends PanelContainer

#colors
const BG := Color(0.07, 0.07, 0.08, 0.85)
const TEXT := Color(0.92, 0.91, 0.88)
const MUTED := Color(0.55, 0.55, 0.55)
const LINE := Color(1, 1, 1, 0.08)

@onready var inventory: Node = Inventory
@onready var margin: MarginContainer = $MarginContainer
@onready var box: VBoxContainer = $MarginContainer/VBoxContainer
@onready var title: Label = $MarginContainer/VBoxContainer/Title
@onready var separator: HSeparator = $MarginContainer/VBoxContainer/HSeparator
@onready var item_list: VBoxContainer = $MarginContainer/VBoxContainer/ItemList


func _process(delta: float) -> void:
	if Input.is_action_pressed("inventory"):
		visible = true
	else:
		visible = false

func _ready() -> void:
	_style()

	if not inventory:
		push_error("inventory autoload missing")
		return

	inventory.changed.connect(_on_changed)
	refresh()


func _on_changed(_item: String, _amount: int) -> void:
	refresh()


#look
func _style() -> void:
	custom_minimum_size.x = 220

	#panel
	var panel := StyleBoxFlat.new()
	panel.bg_color = BG
	panel.set_corner_radius_all(6)
	panel.set_border_width_all(1)
	panel.border_color = LINE
	add_theme_stylebox_override("panel", panel)

	#padding
	for side in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(side, 16)

	#spacing
	box.add_theme_constant_override("separation", 10)
	item_list.add_theme_constant_override("separation", 6)

	#title
	title.text = "INVENTORY"
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", MUTED)

	#line
	var line := StyleBoxLine.new()
	line.color = LINE
	line.thickness = 1
	separator.add_theme_stylebox_override("separator", line)


#rebuild list
func refresh() -> void:
	for child in item_list.get_children():
		child.queue_free()

	#empty
	if inventory.items.is_empty():
		var empty := _make_label("Empty", MUTED)
		item_list.add_child(empty)
		return

	#rows sorted by name
	var names: Array = inventory.items.keys()
	names.sort()
	for item in names:
		add_row(item, inventory.items[item])


func add_row(item: String, amount: int) -> void:
	var row := HBoxContainer.new()

	#name
	var name_label := _make_label(item.capitalize(), TEXT)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(name_label)

	#amount
	var amount_label := _make_label(str(amount), MUTED)
	amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(amount_label)

	item_list.add_child(row)


func _make_label(text: String, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", color)
	return label
