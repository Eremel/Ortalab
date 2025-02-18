SMODS.Joker({
	key = "afterburner",
	atlas = "jokers",
	pos = {x = 8, y = 4},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
    config = {extra = {money = 8, money_loss = 2}},
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.money
	end,
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'salad'} end
        return {vars = {card.ability.extra.money, card.ability.extra.money_loss}}
    end,
    calculate = function(self, card, context) --Fuel Tank Logic
        if not context.blueprint then
            if context.end_of_round and not context.individual and not context.repetition then
                if G.GAME.blind.boss then
                    if card.ability.extra.money - card.ability.extra.money_loss <= 0 then
                        Ortalab.remove_joker(card)
                        return {
                            message = localize('ortalab_empty'),
                            colour = G.C.RED
                        }
                    else
                        card.ability.extra.money = card.ability.extra.money - card.ability.extra.money_loss
                        return {
                            message = localize('ortalab_leak'),
                            colour = G.C.MONEY
                        }
                    end
                end
            end
        end
    end
})
