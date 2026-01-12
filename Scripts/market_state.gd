extends Node
class_name MarketState

@export var gold_drift_rate: float = 0.05	# % toward target per tick
@export var stock_drift_rate: float = 0.1	# % toward target per tick

func initialize_npc(npc_node: NPCNode) -> void:
	# Initialize runtime values on the NPC node (gold + stock).
	if npc_node == null or npc_node.npc_data == null:
		return
	npc_node._initialize_from_resource()

func tick_restock(npc_node: NPCNode, town_node: TownNode, region_node: RegionNode, ticks: int) -> void:
	# Progressive restock and gold drift. Call from TimeManager tick while traveling.
	if npc_node == null or npc_node.npc_data == null:
		return
	if town_node == null or town_node.town_data == null:
		return
	if region_node == null or region_node.region_data == null:
		return
	var gold: int = npc_node.gold
	for i in ticks:
		# Target gold scales with econ powers and nesting status.
		var target_gold: float = float(npc_node.npc_data.base_gold)
		target_gold *= npc_node.npc_data.economic_power
		target_gold *= town_node.get_economic_factor()
		target_gold *= region_node.get_status_factor()
		# Gold drift toward target.
		var gold_delta := int(round((target_gold - float(gold)) * gold_drift_rate))
		gold += gold_delta
		# Restock each sell entry toward max, limited by gold (cost uses base price).
		for entry in npc_node.npc_data.sells:
			var item_id: String = entry.get("item_id", "")
			if item_id.is_empty():
				continue
			var target := max(0, entry.get("max_stock", 0))
			var current := npc_node.stock.get(item_id, 0)
			if current >= target:
				continue
			var step := int(ceil(float(target - current) * stock_drift_rate * npc_node.npc_data.stock_speed * town_node.town_data.stock_speed))
			var item_def := ItemDatabase.get_item(item_id)
			var unit_cost := 1
			if item_def != null:
				unit_cost = max(1, item_def.base_price)
			var affordable := gold / unit_cost
			var add_amount := min(step, target - current, affordable)
			if add_amount <= 0:
				continue
			gold -= add_amount * unit_cost
			npc_node.stock[item_id] = current + add_amount
			if npc_node.npc_data != null:
				SignalManager.emit_npc_stock_changed(npc_node.npc_data.id, item_id, npc_node.stock[item_id])
	npc_node.gold = max(0, gold)
	if npc_node.npc_data != null:
		SignalManager.emit_npc_gold_changed(npc_node.npc_data.id, npc_node.gold)
