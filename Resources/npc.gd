class_name NPC extends Resource

@export var id: String
@export var name: String
@export var town_id: String
@export var economic_power: float = 1.0	# shop-level wealth scalar
@export var status: GameEnums.Status = GameEnums.Status.STABLE
@export var reputation: int = 0			# -100..100 (player-specific rep)
@export var stock_speed: float = 1.0		# ticks to restock
@export var mood_value: float = 60.0		# 0..100 for UI + price
@export var personality: GameEnums.Personality = GameEnums.Personality.FAIR
@export var portrait: Texture2D = null

@export var base_gold: int = 100

# Items the NPC sells: item_id + max_stock + optional price_modifier.
# price_modifier is multiplicative (1 + modifier), null/missing = 0.
@export var sells: Array[Dictionary] = []	# each { "item_id": String, "max_stock": int, "price_modifier": float = 0.0 }

# Items the NPC buys: item_id + optional price_modifier.
@export var buys: Array[Dictionary] = []	# each { "item_id": String, "price_modifier": float = 0.0 }
