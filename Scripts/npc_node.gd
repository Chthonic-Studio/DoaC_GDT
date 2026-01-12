@icon("res://Assets/Item Icons/fb1910.png")
class_name NPCNode extends Node

@export var npc_data: NPC
@export var town_node: TownNode

var gold: int = 0							# runtime gold stock
var stock: Dictionary = {}					# {item_id: current_amount}
var max_stock: Dictionary = {}				# {item_id: cap}
var sell_modifiers: Dictionary = {}			# {item_id: price_modifier}
var buy_modifiers: Dictionary = {}			# {item_id: price_modifier}

func _ready() -> void:
	_initialize_from_resource()

func _initialize_from_resource() -> void:
	# Called on enter-tree; can be re-called when loading a save.
	if npc_data == null:
		return
	gold = npc_data.base_gold
	stock.clear()
	max_stock.clear()
	sell_modifiers.clear()
	buy_modifiers.clear()
	for entry in npc_data.sells:
		var item_id: String = entry.get("item_id", "")
		if item_id.is_empty():
			continue
		var cap: int = max(0, entry.get("max_stock", 0))
		var modifier: float = entry.get("price_modifier", 0.0)
		max_stock[item_id] = cap
		stock[item_id] = cap	# start at full
		sell_modifiers[item_id] = modifier
	for entry in npc_data.buys:
		var item_id: String = entry.get("item_id", "")
		if item_id.is_empty():
			continue
		var modifier: float = entry.get("price_modifier", 0.0)
		buy_modifiers[item_id] = modifier
	# Notify UI listeners.
	SignalManager.emit_npc_gold_changed(npc_data.id, gold)
	for item_id in stock.keys():
		SignalManager.emit_npc_stock_changed(npc_data.id, item_id, stock[item_id])

func get_item_price_modifier(item_id: String) -> float:
	# Returns multiplicative factor (1 + modifier), default 1.0
	if sell_modifiers.has(item_id):
		return 1.0 + sell_modifiers[item_id]
	if buy_modifiers.has(item_id):
		return 1.0 + buy_modifiers[item_id]
	return 1.0

func change_gold(delta: int) -> void:
	gold = max(0, gold + delta)
	if npc_data != null:
		SignalManager.emit_npc_gold_changed(npc_data.id, gold)

func change_stock(item_id: String, delta: int) -> void:
	if not stock.has(item_id):
		stock[item_id] = 0
	var cap: int = max_stock.get(item_id, stock[item_id])
	stock[item_id] = clamp(stock[item_id] + delta, 0, cap)
	if npc_data != null:
		SignalManager.emit_npc_stock_changed(npc_data.id, item_id, stock[item_id])
