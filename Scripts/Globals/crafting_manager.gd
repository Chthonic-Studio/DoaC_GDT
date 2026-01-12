extends Node

func craft(recipe: Recipe, provided_item_ids: Array[String]) -> String:
	if not recipe:
		return ""
	if not _matches(recipe, provided_item_ids):
		return ""
	var roll := randf()
	if roll < recipe.failure_chance:
		# Failure: consume items, no output.
		_consume(provided_item_ids)
		return ""
	_consume(provided_item_ids)
	# InventoryManager is now scene-based; access through GameManager.
	if GameManager.inventory_manager != null:
		GameManager.inventory_manager.add_item(recipe.result_item_id, 1)
	return recipe.result_item_id

func _matches(recipe: Recipe, provided: Array[String]) -> bool:
	# Match by tags OR by specific items; success if all required tags or items are present.
	var remaining_tags := recipe.required_tags.duplicate()
	var remaining_specific := recipe.required_items.duplicate()
	for id in provided:
		var def := _item_def(id)
		if not def:
			continue
		# Specific item takes priority.
		if remaining_specific.has(id):
			remaining_specific.erase(id)
			continue
		# Otherwise try to satisfy a tag.
		for tag in def.tags:
			if remaining_tags.has(tag):
				remaining_tags.erase(tag)
				break
	return remaining_tags.is_empty() and remaining_specific.is_empty()

func _consume(item_ids: Array[String]) -> void:
	if GameManager.inventory_manager == null:
		return
	for id in item_ids:
		GameManager.inventory_manager.remove_item(id, 1)

func _item_def(id: String) -> Item:
	# Centralized lookup with caching.
	return ItemDatabase.get_item(id)
