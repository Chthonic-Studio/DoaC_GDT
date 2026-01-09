# Diary of a Caravaneer - Game Design Document

## Engine: Godot 4.x

## Platform: PC

## Genre: Narrative Trading Simulation / Survival RPG

## Visual Style: 2D Pixel Art

Target Duration: 15-20 Hours

1. High-Level Concept

Diary of a Caravaneer is a management simulation where players guide a merchant family (a father, son, and daughter) through a world on the brink of war. Unlike traditional trading games where profit is the only goal, here money is a means of survival. The ultimate objective is to earn enough to buy passage to Vaelris, a safe haven, before the "Balenvhenian Scramble" war zone overtakes them.

Core Pillars

Strategic Macro-Trading: Managing a caravan's inventory, weight limits, and route efficiency across a volatile market affected by war.

Alchemy & Survival: A crafting system that replaces the "food cart." Players brew potions and cook meals to manage the family's stats and solve NPC narrative puzzles.

Emergent Narrative: A "Hidden Needs" system where NPCs require specific crafted items rather than generic "fetch quests," tying the crafting economy directly to story progression.

2. Core Gameplay Loop

The game functions on a cycle of Preparation, Travel, and Transaction.

Town Phase:

Trade: Buy low/sell high based on local rumors (e.g., "Soldiers coming" = high demand for food).

Gather Intel: Speak to NPCs to learn their "Hidden Needs" (e.g., an aching joint requires a Warming Balm).

Craft: Use the Alchemy Lab to turn raw ingredients into high-value potions or essential family supplies.

Travel Phase (Overworld):

Navigation: Point-and-click movement on a grid-based map.

Resource Drain: Food/Water consumes tick down per tile moved.

Threat Avoidance: Players spot "Threat Bubbles" (Bandits/Patrols) and must choose to sneak (slow, high food cost) or rush (fast, high detection risk).

Encounter Phase:

When intercepted, a Skill Check occurs (not pure combat). Players manage a "Dice Pool" based on their RPG stats to resolve the threat or pay a narrative cost (Health/Goods).

3. Detailed System Specifications

A. Map & Movement System (Godot Implementation)

Architecture: TileMap based world with NavigationAgent2D for caravan pathfinding.

The "Scout" Mechanic:

Active Mode: Player moves at 50% speed but doubles the "Detection Radius" for spotting bandits early.

Passive Mode: Normal speed, but threats appear suddenly.

Fog of War: The "War Front" is a dynamic texture that creeps from the left side of the map over time. If it touches a town, that market closes forever.

B. The Economy & Inventory

Resource-Based Item Data: All items are Godot Resources with properties: BasePrice, Weight, Type (Ingredient/Trade/Consumable), and Tags (e.g., "Spice", "Luxury").

Inventory Conflict: There is a single "Wagon Capacity." Players must make the hard choice: "Do I carry 50kg of high-profit Silk, or 10kg of Ingredients to heal my sick daughter?"

Supply/Demand: Towns have "Market Modifiers." Selling Potions changes a town's demand for Herbs.

C. Alchemy & Crafting (The "Hearth")

Replaces: Food Cart Minigame.

Mechanic: Drag-and-drop ingredients into a cauldron.

Recipe Logic: Logic is Tag-based, not Item-based.

Example: Recipe: Healing Soup requires [Protein] + [Herb] + [Liquid]. It doesn't matter if you use "Wolf Meat" or "Chicken."

Usage:

Self: Heal family fatigue/hunger.

Trade: Sell unique potions for high margins.

Gift: Solve NPC problems (e.g., give "Focus Potion" to the Scholar).

D. RPG Progression & Encounter System

The Family:

Dad: Combat/Defense stats (Weapon usage).

Daughter: Arcana/Stealth stats (Mana usage).

Son: Barter/Charisma stats.

The Dice Pool System:

Defense is not a d20 roll. It is a resource management puzzle.

Scenario: Bandits attack. Difficulty = 5.

Player Base Defense: 2 Dice.

Action: Player spends 2 Ammo Resources -> Adds 2 Dice. Total 4 Dice.

Action: Player has Daughter cast "Illusion" (Spends Mana) -> Lowers Difficulty to 3.

Fail States:

Failed Defense: Robbery (Loss of random inventory).

Starvation: Narrative rescue (Reset to nearest town, loss of gold/days).

Game Over: Reaching 0 Gold with no items, or the "War Front" overtaking the player.

4. UI & UX Architecture

A. The HUD (Always Visible)

Top Bar: Gold, Date, Distance to Vaelris (Progress Bar).

Side Panel (Family): Portraits of the 3 family members.

Visual Feedback: Portraits visually degrade as Hunger/Fatigue rises (bags under eyes, pale skin).

Bottom Bar: Current Wagon Weight / Max Capacity.

B. The Overworld View

Threat Indicators: Pulsing red circles indicating bandit vision ranges.

Path Line: Drawn line showing the intended route, color-coded by food cost (Green = Safe, Red = Will run out of food).

C. The Alchemy Overlay

Layout: Central Cauldron. Left side Inventory (Filtered to Ingredients). Right side Recipe Book (Auto-fills discovered recipes).

Feedback: The liquid in the pot changes color dynamically based on the dominant "Tag" in the mix.

D. The Market Screen (Split View)

Left: Town Shop. Right: Player Inventory.

The "Haggle" Meter: A visual bar representing the Son's "Barter Level." High level = larger green zone to hit for a discount.

5. Narrative Structure & "The Gift"

Contextual Needs: NPCs do not have "Exclamation Marks." They have dialogue that implies a problem.

NPC: "I haven't slept in weeks... the nightmares of the front line keep me up."

Player Action: Craft "Dreamless Sleep Draft" (Alchemy).

Interaction: Open "Gift" menu -> Select Potion.

Reward: The NPC becomes a contact. They might reveal a shortcut on the map, lower market taxes, or give a rare heirloom.

6. Technical Stack Notes

Language: GDScript.

State Management: Autoloads for GameManager (Global State), TimeSystem, and InventoryManager.

Data Storage: Custom .tres (Resource) files for Items, Recipes, and Town Data to allow easy balancing without code changes.
