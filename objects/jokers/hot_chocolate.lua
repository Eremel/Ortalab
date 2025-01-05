SMODS.Joker({
	key = "hot_chocolate",
	atlas = "jokers",
	pos = {x=3,y=3},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	config = {extra = {chips = 0, change = 5, limit = 150}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.chips, card.ability.extra.change, card.ability.extra.limit}}
	end,
	calculate = function(self, card, context)
        if context.before then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.change
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_chips',vars={card.ability.extra.change}}})
        end
		if context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips
            }
        end
        if context.after and not context.blueprint then
            if card.ability.extra.limit == card.ability.extra.chips then
                Ortalab.remove_joker(card)
                return {
                    message = localize('k_eaten_ex'),
                }
            end
            
        end
    end
})