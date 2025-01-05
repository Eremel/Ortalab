SMODS.Atlas({
    key = "ortalab_enhanced",
    path = "Enhancements.png",
    px = 71,
    py = 95
})

SMODS.Enhancement({
    key = "post",
    atlas = "ortalab_enhanced",
    pos = {x = 0, y = 0},
    discovered = false,
    config = {extra = {hand_chips = 10}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'notmario'} end
        return {
            vars = { card and card.ability.extra.hand_chips or self.config.extra.hand_chips }
        }
    end,
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition then
            local chip_return = 0
            for i, held_card in pairs(G.hand.cards) do
                if not Ortalab.config.enhancement_skip then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            held_card:juice_up()
                            play_sound('chips1', 0.8+ (0.9 + 0.2*math.random())*0.2, 1)
                            card:juice_up(0.6, 0.1)
                            G.ROOM.jiggle = G.ROOM.jiggle + 0.7    
                            return true
                        end
                    }))
                end
                chip_return = chip_return + card.ability.extra.hand_chips
                if i ~= # G.hand.cards and not Ortalab.config.enhancement_skip then card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_chips',vars={chip_return}}, colour = G.C.BLUE, delay = 0, chip_mod = true}) end
            end
            SMODS.eval_this(card, {
                chip_mod = chip_return,
                message = localize({type = 'variable', key = 'a_chips', vars = {chip_return}}),
            })
            
        end
    end
})

SMODS.Enhancement({
    key = "bent",
    atlas = "ortalab_enhanced",
    pos = {x = 1, y = 0},
    discovered = false,
    config = {extra = {hand_mult = 2}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {
            vars = { card and card.ability.extra.hand_mult or self.config.extra.hand_mult }
        }
    end,
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition then
            local mult_return = 0
            for i, held_card in pairs(G.hand.cards) do
                if not Ortalab.config.enhancement_skip then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            held_card:juice_up()
                            play_sound('chips1', 0.8+ (0.9 + 0.2*math.random())*0.2, 1)
                            card:juice_up(0.6, 0.1)
                            G.ROOM.jiggle = G.ROOM.jiggle + 0.7    
                            return true
                        end
                    }))
                end
                mult_return = mult_return + card.ability.extra.hand_mult
                if i ~= #G.hand.cards and not Ortalab.config.enhancement_skip then card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={mult_return}}, colour = G.C.RED, delay = 0, mult_mod = true}) end
            end
            SMODS.eval_this(card, {
                mult_mod = mult_return,
                message = localize({type = 'variable', key = 'a_mult', vars = {mult_return}}),
            })
            
        end
    end
})

SMODS.Enhancement({
    key = "index",
    atlas = "ortalab_enhanced",
    pos = {x = 2, y = 0},
    discovered = false,
    config = {extra = {index_state = 'MID'}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'luna'} end
    end,
    set_sprites = function(self, card, front)
        if card.ability and card.ability.extra and type(card.ability.extra) == 'table' and card.ability.extra.index_state then 
            if card.ability.extra.index_state == 'MID' then card.children.center:set_sprite_pos({x = 2, y = 0}) 
            elseif card.ability.extra.index_state == 'UP' then card.children.center:set_sprite_pos({x = 1, y = 2}) 
            elseif card.ability.extra.index_state == 'DOWN' then card.children.center:set_sprite_pos({x = 0, y = 2}) end
        end
    end,
})

SMODS.Enhancement({
    key = "sand",
    atlas = "ortalab_enhanced",
    pos = {x = 3, y = 0},
    config = {extra = {x_mult = 2.5, change=0.25}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {
            vars = { card and card.ability.extra.x_mult or self.config.extra.x_mult, card and card.ability.extra.change or self.config.extra.change }
        }
    end,
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition then
            effect.x_mult = card.ability.extra.x_mult
        end
    end
})

SMODS.Sound({
    key = 'metal1',
    path = 'metal1.ogg'
})

SMODS.Enhancement({
    key = "rusty",
    atlas = "ortalab_enhanced",
    pos = {x = 0, y = 1},
    discovered = false,
    config = {extra = {base_x = 0.5, x_gain = 0.75}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        local card_ability = card and card.ability or self.config
        return {
            vars = { card_ability.extra.base_x, card_ability.extra.x_gain }
        }
    end,
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition then
            local rusty_in_hand = 0
            for i, held_card in pairs(G.hand.cards) do
                if held_card.config.center_key == 'm_ortalab_rusty' then
                    if not Ortalab.config.enhancement_skip then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            func = function()
                                held_card:juice_up()
                                play_sound('ortalab_metal1', 0.8+ (0.9 + 0.2*math.random())*0.2, 0.5)
                                card:juice_up()
                                G.ROOM.jiggle = G.ROOM.jiggle + 0.7    
                                return true
                            end
                        }))
                    end
                    rusty_in_hand = rusty_in_hand + 1
                    if i ~= #G.hand.cards and not Ortalab.config.enhancement_skip then card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.extra.base_x + (rusty_in_hand * card.ability.extra.x_gain)}}, colour = G.C.RED, delay = 0, Xmult_mod = true}) end
                end
            end
            effect.x_mult = card.ability.extra.base_x + (rusty_in_hand * card.ability.extra.x_gain)
        end
    end
})

SMODS.Enhancement({
    key = "ore",
    atlas = "ortalab_enhanced",
    pos = {x = 1, y = 1},
    discovered = false,
    no_rank = true,
    no_suit = true,
    replace_base_card = true,
    always_scores = true,
    config = {mult = 10},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel'} end
        return {
            vars = { card and card.ability.mult or self.config.mult }
        }
    end,
    calculate = function(self, card, context, effect)
        
    end
})

SMODS.Enhancement({
    key = "iou",
    atlas = "ortalab_enhanced",
    pos = {x = 2, y = 1},
    discovered = false,
    config = {extra = {level_up = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {
            vars = { card and card.ability.extra.level_up or self.config.extra.level_up }
        }
    end
})

SMODS.Enhancement({
    key = "recycled",
    atlas = "ortalab_enhanced",
    pos = {x = 3, y = 1},
    discovered = false,
    config = {extra = {discard_chance = 5, tag_chance = 15, discards = 1, tags = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        local card_ability = card and card.ability or self.config
        return {
            vars = { math.max(G.GAME.probabilities.normal, 1) * (card_ability.extra.discard_chance - 1), card_ability.extra.discard_chance / math.min(G.GAME.probabilities.normal, 1), card_ability.extra.discards, math.max(1, G.GAME.probabilities.normal) * (card_ability.extra.tag_chance - 1), card_ability.extra.tag_chance / math.min(G.GAME.probabilities.normal, 1), card_ability.extra.tags }
        }
    end,
    calculate = function(self, card, context, effect)
        if context.cardarea == G.play and not context.repetition then
            if pseudorandom('moldy_discards') > G.GAME.probabilities.normal * (card.ability.extra.discard_chance - 1) / card.ability.extra.discard_chance then
                ease_discard(card.ability.extra.discards)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_moldy_discard'), colour = G.C.RED})
            end
            if pseudorandom('moldy_hands') > G.GAME.probabilities.normal * (card.ability.extra.tag_chance - 1) / card.ability.extra.tag_chance then
                local tag_pool = get_current_pool('Tag')
                local selected_tag = pseudorandom_element(tag_pool, pseudoseed('ortalab_hoarder'))
                local it = 1
                while selected_tag == 'UNAVAILABLE' do
                    it = it + 1
                    selected_tag = pseudorandom_element(tag_pool, pseudoseed('ortalab_hoarder_resample'..it))
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.4,
                    func = (function()
                        add_tag(Tag(selected_tag))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_moldy_tag'), colour = G.C.BLUE})
            end
        end
    end
})

local card_highlight = Card.highlight
function Card:highlight(highlighted)
    card_highlight(self, highlighted)
    if highlighted and self.config.center_key == 'm_ortalab_index' and self.area == G.hand and #G.hand.highlighted == 1 and not G.booster_pack then
        self.children.use_button = UIBox{
            definition = G.UIDEF.use_index_buttons(self), 
            config = {align = 'cl', offset = {x=0.5, y=0}, parent = self, id = 'ortalab_index'}
        }
    elseif self.area and #self.area.highlighted > 0 and not G.booster_pack then
        for _, card in ipairs(self.area.highlighted) do
            if card.config.center_key == 'm_ortalab_index' then
                card.children.use_button = #self.area.highlighted == 1 and UIBox{
                    definition = G.UIDEF.use_index_buttons(card), 
                    config = {align = 'cl', offset = {x=0.5, y=0}, parent = card}
                } or nil
            end
        end
        -- self.children.use_button = nil
    end
    if highlighted and self.children.use_button and self.children.use_button.config.id == 'ortalab_index' and self.config.center_key ~= 'm_ortalab_index' then
        self.children.use_button:remove()
    end
end

function G.UIDEF.use_index_buttons(card)
    local up = nil
    local mid = nil
    local down = nil

    up = {n=G.UIT.C, config={align = "cl"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 0.9, minh = 0.6, hover = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'increase_index', func = 'index_card_increase'}, nodes={
                {n=G.UIT.T, config={text = '+1', colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true}}
            }}
        }}

    mid = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 0.9, minh = 0.6, hover = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'mid_index', func = 'index_card_mid'}, nodes={
            {n=G.UIT.T, config={text = ' 0', colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true}}
        }}
    }}

    down = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 0.9, minh = 0.6, hover = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'decrease_index', func = 'index_card_decrease'}, nodes={
            {n=G.UIT.T, config={text = '-1', colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true}}
        }}
    }}

    local t = {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
        {n=G.UIT.R, config={align = 'cl'}, nodes={
            up
        }},
        {n=G.UIT.R, config={align = 'cl'}, nodes={
            mid
        }},
        {n=G.UIT.R, config={align = 'cl'}, nodes={
            down
        }},
        }},
    }}
    return t
  end

G.FUNCS.index_card_increase = function(e)
    if e.config.ref_table.ability.extra and type(e.config.ref_table.ability.extra) == 'table' and e.config.ref_table.ability.extra.index_state ~= 'UP' then 
        e.config.colour = G.C.RED
        e.config.button = 'increase_index'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.increase_index = function(e, mute, nosave)
    e.config.button = nil
    local card = e.config.ref_table
    local area = card.area
    local change = 1
    if card.ability.extra.index_state == 'DOWN' then change = 2 end
    card.ability.extra.index_state = 'UP'
    card.children.center:set_sprite_pos({x = 1, y = 2})
    card.base.id = card.base.id + change
    SMODS.change_base(card, nil, get_rank_suffix(card)) 
end

G.FUNCS.index_card_mid = function(e)
    if e.config.ref_table.ability.extra and type(e.config.ref_table.ability.extra) == 'table' and e.config.ref_table.ability.extra.index_state ~= 'MID' then 
        e.config.colour = G.C.RED
        e.config.button = 'mid_index'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.mid_index = function(e, mute, nosave)
    e.config.button = nil
    local card = e.config.ref_table
    local area = card.area
    local change = 1
    if card.ability.extra.index_state == 'UP' then change = -1 end
    card.ability.extra.index_state = 'MID'
    card.children.center:set_sprite_pos({x = 2, y = 0})
    card.base.id = card.base.id + change
    SMODS.change_base(card, nil, get_rank_suffix(card)) 
end

G.FUNCS.index_card_decrease = function(e)
    if e.config.ref_table.ability.extra and type(e.config.ref_table.ability.extra) == 'table' and e.config.ref_table.ability.extra.index_state ~= 'DOWN' then 
        e.config.colour = G.C.RED
        e.config.button = 'decrease_index'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.decrease_index = function(e, mute, nosave)
    e.config.button = nil
    local card = e.config.ref_table
    local area = card.area
    local change = 1
    if card.ability.extra.index_state == 'UP' then change = 2 end
    card.ability.extra.index_state = 'DOWN'
    card.children.center:set_sprite_pos({x = 0, y = 2}) 
    card.base.id = card.base.id - change
    SMODS.change_base(card, nil, get_rank_suffix(card))
end