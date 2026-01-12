extends Node

var item_db_path: String = "res://Resources/item_db.tres"

var _db: ItemDB = null

func _ready() -> void:
	_load_db()

func _load_db() -> void:
	if ResourceLoader.exists(item_db_path):
		_db = load(item_db_path)
		if _db == null:
			push_warning("ItemDatabase: failed to load ItemDB at %s" % item_db_path)
	else:
		push_warning("ItemDatabase: ItemDB resource not found at %s" % item_db_path)

func get_item(id: String) -> Item:
	if _db == null:
		push_warning("ItemDatabase: DB not loaded; returning null for %s" % id)
		return null
	return _db.get_item(id)

func reload() -> void:
	_load_db()

func set_db(db: ItemDB) -> void:
	_db = db

# Convenience for runtime-only registration.
func register_item(id: String, res: Item) -> void:
	if _db == null:
		_db = ItemDB.new()
	_db.register_item(id, res)
