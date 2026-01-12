extends Node

## Returns the unit price the player pays to BUY one unit of item_id at this shop.
func get_buy_unit_price(item_id: String, quantity: int, town: Town, shop: NPC, region_status: GameEnums.Status, world_status: GameEnums.Status) -> int:
	var base_def: Item = _item_def(item_id)
	if base_def == null:
		return 0
	var base_price: float = float(base_def.base_price)
	var scope_multiplier: float = _scope_multiplier(item_id, town, shop, region_status, world_status, true)
	var mood_factor: float = _mood_factor(shop.mood_value, true)
	var bulk_factor: float = _bulk_diminishing(quantity, true)
	var wanted_bonus: float = _wanted_bonus(item_id, town)
	var final_price: float = base_price * scope_multiplier * mood_factor * wanted_bonus
	final_price *= bulk_factor
	return int(round(final_price))

## Returns the unit price the player receives to SELL one unit of item_id at this shop.
func get_sell_unit_price(item_id: String, quantity: int, town: Town, shop: NPC, region_status: GameEnums.Status, world_status: GameEnums.Status) -> int:
	var base_def: Item = _item_def(item_id)
	if base_def == null:
		return 0
	var base_price: float = float(base_def.base_price)
	var scope_multiplier: float = _scope_multiplier(item_id, town, shop, region_status, world_status, false)
	var mood_factor: float = _mood_factor(shop.mood_value, false)
	var bulk_factor: float = _bulk_diminishing(quantity, false)
	var wanted_bonus: float = _wanted_bonus(item_id, town)
	var final_price: float = base_price * scope_multiplier * mood_factor * wanted_bonus
	final_price *= bulk_factor
	return int(round(final_price))

## Builds the tax line (positive => player pays). Applies to buys and sells.
func build_tax_line(buy_total: int, sell_total: int, town: Town, region_status: GameEnums.Status, world_status: GameEnums.Status) -> int:
	var tax_rate: float = _tax_rate(town, region_status, world_status)
	var taxable: float = float(max(0, buy_total) + max(0, sell_total))
	return int(round(taxable * tax_rate))

# --- Internal modular pieces -----------------------------------------------

func _scope_multiplier(item_id: String, town: Town, shop: NPC, region_status: GameEnums.Status, world_status: GameEnums.Status, is_buy: bool) -> float:
	var town_factor: float = _status_to_factor(town.status)
	var region_factor: float = _status_to_factor(region_status)
	var world_factor: float = _status_to_factor(world_status)
	var shop_factor: float = _status_to_factor(shop.status)
	var econ_power: float = town.economic_power * shop.economic_power
	var rep_factor: float = 1.0 + (float(shop.reputation) + float(town.reputation)) / 500.0	# rep -100..100 -> ~0.6..1.4
	var direction_bias: float = 1.0
	if is_buy:
		direction_bias = 1.02
	else:
		direction_bias = 0.98
	return town_factor * region_factor * world_factor * shop_factor * econ_power * rep_factor * direction_bias

func _status_to_factor(status: GameEnums.Status) -> float:
	match status:
		GameEnums.Status.PROSPEROUS:
			return 0.9
		GameEnums.Status.STABLE:
			return 1.0
		GameEnums.Status.STRUGGLING:
			return 1.1
		GameEnums.Status.FAMINE:
			return 1.25
		GameEnums.Status.WARFRONT:
			return 1.35
		_:
			return 1.0

func _mood_factor(mood_value: float, is_buy: bool) -> float:
	# Friendly mood gives slight discount when buying, bonus when selling.
	var t: float = clamp(mood_value, 0.0, 100.0) / 100.0
	if is_buy:
		return lerp(1.05, 0.95, t)	# bad mood -> +5%, good mood -> -5%
	else:
		return lerp(0.95, 1.05, t)	# selling: bad mood buys cheaper, good mood buys higher

func _bulk_diminishing(quantity: int, is_buy: bool) -> float:
	# Diminishing returns for bulk sales; small bias difference for buy vs sell.
	var q: int = max(1, quantity)
	var t: float = clamp(float(q - 1) / 20.0, 0.0, 1.0)
	if is_buy:
		return lerp(1.0, 0.985, t)
	else:
		return lerp(1.0, 0.98, t)

func _wanted_bonus(item_id: String, town: Town) -> float:
	var bonus: float = 1.0
	for entry in town.wanted_dynamic:
		if entry.item_id == item_id:
			bonus += abs(entry.intensity)
	for entry in town.unwanted_dynamic:
		if entry.item_id == item_id:
			bonus -= abs(entry.intensity)
	return max(0.25, bonus)	# clamp so it never hits zero or negative

func _tax_rate(town: Town, region_status: GameEnums.Status, world_status: GameEnums.Status) -> float:
	var rate: float = town.tax_rate
	rate *= _status_tax_adjust(region_status)
	rate *= _status_tax_adjust(world_status)
	return rate

func _status_tax_adjust(status: GameEnums.Status) -> float:
	match status:
		GameEnums.Status.PROSPEROUS:
			return 0.9
		GameEnums.Status.STABLE:
			return 1.0
		GameEnums.Status.STRUGGLING:
			return 1.05
		GameEnums.Status.FAMINE:
			return 1.1
		GameEnums.Status.WARFRONT:
			return 1.15
		_:
			return 1.0

func _item_def(id: String) -> Item:
	# TODO: Replace with your item DB lookup (preload cache, dictionary, ResourceLoader, etc.).
	return null
