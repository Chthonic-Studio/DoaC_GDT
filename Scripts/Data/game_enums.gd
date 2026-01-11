class_name GameEnums

enum ItemCategory { RAW_MATERIALS, CRAFTED_GOODS, FOODSTUFFS, TOOLS_EQUIPMENT, POTIONS, MISC }

enum Personality { GENEROUS, STERN, GREEDY, FAIR, OPPORTUNIST }

enum Status { PROSPEROUS, STABLE, STRUGGLING, FAMINE, WARFRONT }

static func mood_to_label(mood_value: float) -> String:
	# 0-20 Angry, 21-40 Sour, 41-60 Neutral, 61-80 Amused, 81-100 Friendly
	if mood_value <= 20.0:
		return "Angry"
	elif mood_value <= 40.0:
		return "Sour"
	elif mood_value <= 60.0:
		return "Neutral"
	elif mood_value <= 80.0:
		return "Amused"
	return "Friendly"
