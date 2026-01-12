extends Node
class_name InventoryManager

var items: Dictionary = {}	# {item_id: count}

func _ready() -> void:
	# Register this scene instance into GameManager so everyone can access it safely.
	GameManager.register_inventory_manager(self)

func add_item(item_id: String, amount: int = 1) -> void:
	items[item_id] = items.get(item_id, 0) + amount
	SignalManager.emit_inventory_changed()
	SignalManager.emit_capacity_changed(get_current_weight(), GameManager.max_capacity)

func remove_item(item_id: String, amount: int = 1) -> bool:
	if not items.has(item_id) or items[item_id] < amount:
		return false
	items[item_id] -= amount
	if items[item_id] <= 0:
		items.erase(item_id)
	SignalManager.emit_inventory_changed()
	SignalManager.emit_capacity_changed(get_current_weight(), GameManager.max_capacity)
	return true

func get_count(item_id: String) -> int:
	return items.get(item_id, 0)

func get_current_weight() -> float:
	var total: float = 0.0
	for id in items.keys():
		var def: Item = _get_item_def(id)
		if def:
			total += def.weight * items[id]
	return total

func can_fit(item_id: String, amount: int) -> bool:
	var def: Item = _get_item_def(item_id)
	if not def:
		return false
	var projected := get_current_weight() + def.weight * amount
	return projected <= GameManager.max_capacity

func _get_item_def(id: String) -> Item:
	# Centralized lookup via ItemDatabase for consistency and caching.
	return ItemDatabase.get_item(id)
