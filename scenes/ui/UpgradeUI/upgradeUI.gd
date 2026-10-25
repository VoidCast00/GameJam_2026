class_name UpgradeObjUI
extends PanelContainer

var id: String

@onready var upgrade_nameText: Label = $HBox/VBoxText/UpgradeName
@onready var upgrade_descText: Label = $HBox/VBoxText/UpgradeDesc
@onready var buy_upgradeButton: AnimatedButton = $HBox/VBoxBuy/BuyUpgrade
@onready var costText: Label = $HBox/VBoxBuy/MarginContainer/Cost


func _ready() -> void:
	buy_upgradeButton.pressed.connect(_on_buy)
	Upgrades.bought.connect(_on_bought)
	visibility_changed.connect(refresh)
	refresh()


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
