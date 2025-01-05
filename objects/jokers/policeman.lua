SMODS.Joker({
	key = "policeman",
	atlas = "jokers",
	pos = {x = 8, y = 10},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {hands = 1, discards = 4}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.hands, card.ability.extra.discards}}
    end,
	calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            ease_discard(card.ability.extra.discards)
            if not context.blueprint then ease_hands_played(-1 * (G.GAME.round_resets.hands - card.ability.extra.hands)) end
        end
    end
})