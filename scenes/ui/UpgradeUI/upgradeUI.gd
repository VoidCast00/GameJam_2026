class_name UpgradeObjUI
extends PanelContainer

var id: String

@onready var upgrade_nameText: Label = $HBox/VBoxText/UpgradeName
@onready var upgrade_descText: Label = $HBox/VBoxText/UpgradeDesc
@onready var buy_upgradeButton: AnimatedButton = $HBox/VBoxBuy/BuyUpgrade
@onready var costText: Label = $HBox/VBoxBuy/MarginContainer/Cost
@onready var trait_icon: Panel = $HBox/TraitIcon


func _ready() -> void:
	buy_upgradeButton.pressed.connect(_on_buy)
	Upgrades.bought.connect(_on_bought)
	visibility_changed.connect(refresh)
	_setup_icon()
	refresh()


#show the trait image for this upgrade, if one exists in assets/traits
func _setup_icon() -> void:
	var path := "res://assets/traits/%s.png" % id
	if not ResourceLoader.exists(path):
		trait_icon.hide()
		return

	var box := StyleBoxTexture.new()
	box.texture = load(path)
	trait_icon.add_theme_stylebox_override("panel", box)


func _on_buy() -> void:
	Upgrades.buy(id)


func _on_bought(_id: String) -> void:
	refresh()


#update text and button
func refresh() -> void:
	var data: Dictionary = Upgrades.ALL[id]
	var level = Upgrades.get_level(id)

	upgrade_nameText.text = "%s  %d/%d" % [data["name"], level, data["max_level"]]
	upgrade_descText.text = data["desc"]

	if Upgrades.is_maxed(id):
		#one time upgrades disappear
		if data.get("once", false):
			hide()
		costText.text = "MAX"
		buy_upgradeButton.disabled = true
	else:
		costText.text = str(Upgrades.get_cost(id)) + "$"
		buy_upgradeButton.disabled = not Upgrades.can_buy(id)
