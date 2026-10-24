class_name AnimatedButton
extends Button

@export_category("Hover")
@export var hover_scale:= Vector2(1.1, 1.1) 
@export var hover_animation_lenght:= 0.1
@export var un_hover_animation_lenght:=0.1

@export_category("Press")
@export var press_scale:= Vector2(0.95, 0.95)
@export var press_animation_lenght_1:= 0.1
@export var press_animation_lenght_2:= 0.1

var animation_tween: Tween


func _ready() -> void:
	pressed.connect(_button_press)
	
	mouse_entered.connect(_button_hover)
	mouse_exited.connect(_button_unhover)
	
	pivot_offset_ratio = Vector2.ONE / 2.0
	  


func _button_press() -> void:
	if animation_tween:
		animation_tween.kill()
	animation_tween = create_tween().set_trans(Tween.TRANS_SINE)
	
	animation_tween.tween_property(self, "scale", press_scale, press_animation_lenght_1)
	animation_tween.chain().tween_property(self, "scale", hover_scale, press_animation_lenght_2)


func _button_hover() -> void:
	if animation_tween:
		animation_tween.kill()
	animation_tween = create_tween().set_trans(Tween.TRANS_SINE)
	
	animation_tween.tween_property(self, "scale", hover_scale, hover_animation_lenght)
func _button_unhover() -> void:
	if animation_tween:
		animation_tween.kill()
	animation_tween = create_tween().set_trans(Tween.TRANS_SINE)
	animation_tween.tween_property(self, "scale", Vector2.ONE, un_hover_animation_lenght)
