extends CanvasLayer

signal opened_changed(opened: bool)

const POTION_HEAL := 35
const BOMB_DAMAGE := 50
var quantities := {"Health Potion": 0, "Bomb": 0}

func _ready() -> void:
	_refresh()

func add_item(item_name: String) -> void:
	quantities[item_name] += 1
	_refresh()

func _refresh() -> void:
	%Potion.text = "Health Potion × %d    ·    Restores %d HP" % [quantities["Health Potion"], POTION_HEAL]
	%Bomb.text = "Bomb × %d    ·    Deals %d damage" % [quantities["Bomb"], BOMB_DAMAGE]

func consume(item_name: String) -> bool:
	if quantities.get(item_name, 0) <= 0:
		return false
	quantities[item_name] -= 1
	_refresh()
	return true

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_I:
		$Toggle.button_pressed = not $Toggle.button_pressed
		get_viewport().set_input_as_handled()

func _on_toggled(opened: bool) -> void:
	$Panel.visible = opened
	opened_changed.emit(opened)
