class_name ItemDB
extends Resource

@export var items: Array[Item] = []	# Drag Item resources directly here in the inspector.

var _cache: Dictionary = {}			# { item_id: Item } built at runtime

func _ready() -> void:
	_rebuild_cache()

func _rebuild_cache() -> void:
	_cache.clear()
	for it in items:
		if it == null:
			continue
		if it.id.is_empty():
			push_warning("ItemDB: Item without id will be skipped")
			continue
		_cache[it.id] = it

func get_item(id: String) -> Item:
	return _cache.get(id, null)

# Optional: register from code (e.g., mods/tests). Does not write back to the array.
func register_item(id: String, res: Item) -> void:
	if id.is_empty() or res == null:
		return
	_cache[id] = res

# Optional: rebuild after you edit the resource at runtime (e.g., dev console).
func rebuild() -> void:
	_rebuild_cache()
