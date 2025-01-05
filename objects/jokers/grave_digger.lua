SMODS.Joker({
	key = "grave_digger",
	atlas = "jokers",
	pos = {x=5,y=11},
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {slots = 2, multiplier = 2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.slots, card.ability.extra.multiplier}}
	end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
        G.E_MANAGER:add_event(Event({func = function()
            update_blind_amounts()
            return true
        end}))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
        update_blind_amounts()
    end
})

function update_blind_amounts()
    if G.GAME.blind then 
        G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.blind.mult*G.GAME.starting_params.ante_scaling
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if G.STATE == G.STATES.BLIND_SELECT and G.blind_select then
        G.blind_select:remove()
        G.blind_prompt_box:remove()
        G.blind_select = UIBox{
            definition = create_UIBox_blind_select(),
            config = {align="bmi", offset = {x=0,y=G.ROOM.T.y + 29},major = G.hand, bond = 'Weak'}
        }
        G.blind_select.alignment.offset.y = 0.8-(G.hand.T.y - G.jokers.T.y) + G.blind_select.T.h
    end
end

local get_blind_amount_ref = get_blind_amount
function get_blind_amount(ante)
    local amount = get_blind_amount_ref(ante)
    local grave_diggers = SMODS.find_card('j_ortalab_grave_digger')
    for _, card in ipairs(grave_diggers) do
        amount = amount * card.ability.extra.multiplier
    end
    return amount
end