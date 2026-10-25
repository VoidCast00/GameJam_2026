class_name UpgradeObjUI
extends PanelContainer
var cost:int
var upgrade_name:String
var upgrade_desc:String

@onready var upgrade_nameText: Label = $HBox/VBoxText/UpgradeName
@onready var upgrade_descText: Label = $HBox/VBoxText/UpgradeDesc
@onready var buy_upgradeButton: AnimatedButton = $HBox/VBoxBuy/BuyUpgrade
@onready var costText: Label = $HBox/VBoxBuy/MarginContainer/Cost

func _ready() -> void:
	buy_upgradeButton.pressed.connect(buy)
	costText.text = str(cost)
	upgrade_descText.text = upgrade_name
	upgrade_nameText.text = upgrade_name


func buy():
	Global.cash -= cost
	print("heres your  upgrade: " + str(upgrade_descText))
