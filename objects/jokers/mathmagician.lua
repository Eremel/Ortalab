SMODS.Joker({
	key = "mathmagician",
	atlas = "jokers",
	pos = {x = 7,y = 3},
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    config = {},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    calculate = function(self, card, context) --Mathmagician logic
        if context.discard and context.other_card == context.full_hand[#context.full_hand] then
            local numbered_even = 0
            local numbered_odd = 0
            for _, v in ipairs(context.full_hand) do
                if (not v:is_face()) and v:get_id() % 2 == 1 then 
                    numbered_odd = numbered_odd + 1 
                elseif not v:is_face() then 
                    numbered_even = numbered_even + 1 
                end
            end
            if numbered_even >= 2 and numbered_odd >= 2 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                local card = create_card('Loteria',G.consumeables)
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                                return true
                        end}))   
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ortalab_loteria_add'), colour = G.C.SET.Loteria})
                        return true
                end)}))
            end
        end
    end
})
