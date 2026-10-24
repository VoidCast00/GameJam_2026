extends PanelContainer

#colors
const BG := Color(0.07, 0.07, 0.08, 0.85)
const TEXT := Color(0.92, 0.91, 0.88)
const MUTED := Color(0.55, 0.55, 0.55)
const LINE := Color(1, 1, 1, 0.08)
const FILL := Color(0.78, 0.86, 0.9)
const RED := Color(0.9, 0.25, 0.2)

#blink below this (0.25 = 25%)
const LOW := 0.25

@onready var margin: MarginContainer = $MarginContainer
@onready var box: VBoxContainer = $MarginContainer/VBoxContainer
@onready var title: Label = $MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var value_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Value
@onready var bar: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar

var panel_style := StyleBoxFlat.new()
var back_style := StyleBoxFlat.new()
var fill_style := StyleBoxFlat.new()


func _ready() -> void:
	_style()


func _process(_delta: float) -> void:
	var max_oxygen: float = Global.oxygenTankSize
	var oxygen: float = Global.oxygen

	#bar and text
	bar.max_value = max_oxygen
	bar.value = oxygen
	value_label.text = "%d / %d" % [ceili(oxygen), int(max_oxygen)]

	_blink(oxygen / max_oxygen)


#red warning
func _blink(ratio: float) -> void:
	var t := Time.get_ticks_msec() / 1000.0
	var alert := 0.0  #0 normal, 1 full red
	var empty := ratio <= 0.0

	if empty:
		#fast on off
		alert = 1.0 if fmod(t, 0.25) < 0.125 else 0.0
	elif ratio < LOW:
		#slow pulse
		alert = (sin(t * 6.0) + 1.0) / 2.0

	fill_style.bg_color = FILL.lerp(RED, alert)
	panel_style.border_color = LINE.lerp(RED, alert)
	value_label.add_theme_color_override("font_color", TEXT.lerp(RED, alert))

	#empty bar turns red too
	var back := Color(1, 1, 1, 0.06)
	back_style.bg_color = back.lerp(Color(RED, 0.4), alert) if empty else back


#look
func _style() -> void:
	custom_minimum_size.x = 220

	#panel
	panel_style.bg_color = BG
	panel_style.set_corner_radius_all(6)
	panel_style.set_border_width_all(1)
	panel_style.border_color = LINE
	add_theme_stylebox_override("panel", panel_style)

	#padding
	for side in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(side, 16)
	box.add_theme_constant_override("separation", 10)

	#title
	title.text = "OXYGEN"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", MUTED)

	#value
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.add_theme_font_size_override("font_size", 14)
	value_label.add_theme_color_override("font_color", TEXT)

	#bar
	bar.show_percentage = false
	bar.custom_minimum_size.y = 6
	back_style.bg_color = Color(1, 1, 1, 0.06)
	back_style.set_corner_radius_all(3)
	fill_style.bg_color = FILL
	fill_style.set_corner_radius_all(3)
	bar.add_theme_stylebox_override("background", back_style)
	bar.add_theme_stylebox_override("fill", fill_style)
