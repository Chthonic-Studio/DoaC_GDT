extends Node
class_name MarketState

## Runtime, mutable state per NPC. Resources stay immutable.
var npc_state: Dictionary = {}	# npc_id -> {gold:int, stock:Dictionary[item_id->int]}

@export var gold_drift_rate: float = 0.05	# % toward target per tick
@export var stock_drift_rate: float = 0.1	# % toward target per tick

func initialize_npc(npc: NPC) -> void:
	# Call once when entering a town or on new game.
	var stock := {}
	for entry in npc.sells:
		stock[entry.item_id] = max(0, entry.base_stock)
	npc_state[npc.id] = {
		"gold": npc.base_gold,
		"stock": stock,
	}

func get_gold(npc_id: String) -> int:
	if not npc_state.has(npc_id):
		return 0
	return npc_state[npc_id].get("gold", 0)

func add_gold(npc_id: String, delta: int) -> void:
	if not npc_state.has(npc_id):
		return
	npc_state[npc_id]["gold"] = max(0, npc_state[npc_id].get("gold", 0) + delta)

func get_stock(npc_id: String, item_id: String) -> int:
	if not npc_state.has(npc_id):
		return 0
	return npc_state[npc_id]["stock"].get(item_id, 0)

func adjust_stock(npc_id: String, item_id: String, delta: int) -> void:
	if not npc_state.has(npc_id):
		return
	var stock: Dictionary = npc_state[npc_id]["stock"]
	stock[item_id] = max(0, stock.get(item_id, 0) + delta)

#func tick_restock(npc: NPC, town: Town, region: Region, ticks: int) -> void:
	## Progressive restock and gold drift. Call from TimeManager tick while traveling.
	#if not npc_state.has(npc.id):
		#initialize_npc(npc)
	#var state := npc_state[npc.id]
	#var gold: int = state["gold"]
	#var stock: Dictionary = state["stock"]
#
	## Target gold scales with econ powers.
	#var target_gold: float = float(npc.base_gold) * npc.economic_power * town.economic_power
	#target_gold *= _region_factor(region)
	#for i in ticks:
		## Gold drift (percentage toward target).
		#var gold_delta := int(round((target_gold - gold) * gold_drift_rate))
		#gold += gold_delta
#
		## Restock each sell entry toward max, limited by gold (placeholder cost = base_price).
		#for entry in npc.sells:
			#var current := stock.get(entry.item_id, 0)
			#var target := entry.max_stock
			#if current >= target:
				#continue
			#var step := int(ceil((target - current) * stock_drift_rate))
			#var item_def := ItemDatabase.get_item(entry.item_id)
			#var unit_cost := if item_def != null else item_def.base_price : 1
			#var affordable := gold / max(1, unit_cost)
			#var add_amount := min(step, target - current, affordable)
			#if add_amount <= 0:
				#continue
			#gold -= add_amount * unit_cost
			#stock[entry.item_id] = current + add_amount
#
	#state["gold"] = max(0, gold)
