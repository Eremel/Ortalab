SMODS.Joker({
	key = "caffeyne",
	atlas = "jokers",
	pos = {x = 6, y = 11},
    soul_pos = {x = 7, y = 11},
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 1, xmult_gain = 1, triggers = 25, triggered_cards = 0}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'crimson'} end
        return {vars = {card.ability.extra.xmult_gain, card.ability.extra.triggers, card.ability.extra.xmult, card.ability.extra.triggered_cards}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and not context.blueprint then
            card.ability.extra.triggered_cards = card.ability.extra.triggered_cards + 1
            if card.ability.extra.triggered_cards == card.ability.extra.triggers then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                card.ability.extra.triggered_cards = 0
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult_gain}}, colour = G.C.RED})
            end
        end
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult,
                colour = G.C.RED
            }
        end
    end
})
