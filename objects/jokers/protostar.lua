SMODS.Joker({
	key = "protostar",
	atlas = "jokers",
	pos = {x=7,y=10},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {chips = 100, change = 2, poker_hand = ''}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.chips, card.ability.extra.change}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            card.ability.extra.poker_hand = context.scoring_name
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.after and not context.repetition and not context.individual and not context.blueprint then
            local change = (G.GAME.hands[card.ability.extra.poker_hand] and G.GAME.hands[card.ability.extra.poker_hand].played or 0) * card.ability.extra.change
            if change >= card.ability.extra.chips then
                card_eval_status_text(card,'extra', nil, nil, nil, {message = localize('ortalab_protostar')})
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function() 
                        local edition = card.edition and card.edition.key or nil
                        local stickers = {}
                        for k, v in pairs(SMODS.Stickers) do
                            if card.ability[k] then
                                table.insert(stickers, k)
                            end
                        end

                        card:start_dissolve()
                        local new_joker = SMODS.create_card({area = G.jokers, set = 'Joker', rarity = 0.8, edition = edition, stickers = stickers})
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        new_joker:start_materialize()
                        return true
                end}))  
            else
                card.ability.extra.chips = card.ability.extra.chips - change
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = '-'..change, colour = G.C.BLUE})
                return nil, true
            end
        end
    end
})
