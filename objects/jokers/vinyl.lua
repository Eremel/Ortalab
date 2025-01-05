SMODS.Joker({
	key = "vinyl",
	atlas = "jokers",
	pos = {x = 5, y = 10},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 15}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.chips}}
    end,
	calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card:is_face() then
            local prior_cards = 0
            local chip_mod = 0
            for i=1, #context.scoring_hand do
                if context.scoring_hand[i] == context.other_card then
                    chip_mod = prior_cards
                else
                    if not context.scoring_hand[i]:is_face() then prior_cards = prior_cards + 1 end
                end
            end
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips * chip_mod}},
                chips = card.ability.extra.chips * chip_mod,
                card = card
            }
        end
    end
})