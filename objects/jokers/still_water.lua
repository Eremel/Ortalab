SMODS.Joker({
	key = "still_water",
	atlas = "jokers",
	pos = {x=8,y=9},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {mult = 2, total_mult = 0}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.mult, card.ability.extra.total_mult}}
	end,
	calculate = function(self, card, context)
        -- Woops I misread the joker and did unscored cards give +2 mult T_T
        -- if context.cardarea == G.play and context.unscored then
        --     print('check')
        --     return {
        --         message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
        --         mult = card.ability.extra.mult,
        --         card = card
        --     }
        -- end
        if context.before then
            if #context.scoring_hand < #context.full_hand then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult}}, colour = G.C.RED})
                card.ability.extra.total_mult = card.ability.extra.total_mult + card.ability.extra.mult
            end
        end
        -- This effect is stupidly strong and has been removed
        -- if context.cardarea == G.play and context.unscored then
        --     G.E_MANAGER:add_event(Event({func = function() context.other_card:juice_up(); return true; end}))
        --     card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult}}, colour = G.C.RED})
        --     card.ability.extra.total_mult = card.ability.extra.total_mult + card.ability.extra.mult
        -- end
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_mult', vars={card.ability.extra.total_mult}},
                mult_mod = card.ability.extra.total_mult,
                colour = G.C.RED,
                card = card
            }
        end
        
    end
})