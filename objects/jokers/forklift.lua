SMODS.Joker({
	key = "forklift",
	atlas = "jokers",
	pos = {x = 6, y = 8},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {slots = 2, target = 18}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'alex'} end
        if G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.all >= card.ability.extra.target then
            return {key = 'j_ortalab_forklift_granted', vars = {card.ability.extra.slots, card.ability.extra.target}}
        else
            return {vars = {card.ability.extra.slots, card.ability.extra.target, G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.all or 0}}
        end
    end,
	calculate = function (self, card, context)
        if context.using_consumeable and G.GAME.consumeable_usage_total.all >= card.ability.extra.target then
            if not card.ability.extra.triggered then
                G.consumeables:change_size(card.ability.extra.slots)
                card:juice_up()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_forklift')})
                card.ability.extra.triggered = true
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.triggered then
            G.consumeables:change_size(-1 * card.ability.extra.slots)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_forklift_loss')})
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.all >= card.ability.extra.target and not card.ability.extra.triggered then
            G.consumeables:change_size(card.ability.extra.slots)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_forklift')})
            card.ability.extra.triggered = true    
        end
    end
})