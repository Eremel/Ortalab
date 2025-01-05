SMODS.Atlas({
    key = 'ortalab_blinds',
    path = 'blinds.png',
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34
})

SMODS.Blind({
    key = 'fold',
    atlas = 'ortalab_blinds',
    pos = {x=0, y=33},
    boss_colour = HEX('00b99f'),
    -- boss = {min = 1, max = 10},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'coro'} end
    end,
    mult = 0.5,
    dollars = 2,
})

SMODS.Blind({
    key = 'check',
    atlas = 'ortalab_blinds',
    pos = {x=0, y=28},
    boss_colour = HEX('27b955'),
    -- boss = {min = 1, max = 10},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'coro'} end
    end,
    mult = 1.25,
    dollars = 4,
})

SMODS.Blind({
    key = 'bet',
    atlas = 'ortalab_blinds',
    pos = {x=0, y=30},
    boss_colour = HEX('71ba27'),
    -- boss = {min = 1, max = 10},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel'} end
    end,
    mult = 1.4,
    dollars = 4,
})

SMODS.Blind({
    key = 'call',
    atlas = 'ortalab_blinds',
    pos = {x=0, y=31},
    boss_colour = HEX('b94a00'),
    -- boss = {min = 1, max = 10},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel'} end
    end,
    mult = 1.4,
    dollars = 4,
})

SMODS.Blind({
    key = 'raise',
    atlas = 'ortalab_blinds',
    pos = {x=0, y=29},
    boss_colour = HEX('c73a38'),
    -- boss = {min = 1, max = 10},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'coro'} end
    end,
    mult = 1.65,
    dollars = 5,
})

SMODS.Blind({
    key = 'all_in',
    atlas = 'ortalab_blinds',
    pos = {x=0, y=32},
    boss_colour = HEX('b92aff'),
    -- boss = {min = 1, max = 10},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel'} end
    end,
    mult = 1.8,
    dollars = 5,
})

Ortalab_blinds = {
    Small = {
        bl_ortalab_check = 'bl_ortalab_check',
        bl_ortalab_fold = 'bl_ortalab_fold',
        bl_ortalab_bet = 'bl_ortalab_bet'
    },
    Big = {
        bl_ortalab_raise = 'bl_ortalab_raise',
        bl_ortalab_call = 'bl_ortalab_call',
        bl_ortalab_all_in = 'bl_ortalab_all_in'
    }
}

local blind_get_type = Blind.get_type
function Blind:get_type()
    if Ortalab_blinds.Small[self.config.blind.key] then
        return 'Small'
    elseif Ortalab_blinds.Big[self.config.blind.key] then 
        return 'Big'
    else
        return blind_get_type(self)
    end
end

SMODS.Blind({
    key = 'sinker',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('5186A8'),
    config = {extra = {hand_size = 1, hands_removed = 0}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.hand_size}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.hand_size}}
    end,
    set_blind = function(self)
        self.config.extra.hands_removed = 0
    end,
    after_scoring = function(self)
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.7, func = function()
            attention_text({
                text = localize('ortalab_sinker_message'),
                hold = 1.4,
                backdrop_colour = self.boss_colour,
                major = G.play,
                offset = {x = 0, y = -2},
                align = 'cm',
                silent = true
            })
            G.hand:change_size(-1 * self.config.extra.hand_size)
            self.config.extra.hands_removed = self.config.extra.hands_removed + self.config.extra.hand_size
            return true
        end })) 
        delay(0.7)
    end,
    defeat = function(self)
        if not G.GAME.blind.disabled then G.hand:change_size(self.config.extra.hands_removed) end
    end,
    disable = function(self)
        G.hand:change_size(self.config.extra.hands_removed)
        G.FUNCS.draw_from_deck_to_hand(self.config.extra.hands_removed)
    end
})

SMODS.Blind({
    key = 'fork',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 1},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('AE718E'),
    config = {extra = {cap = 0.5}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.cap*100}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.cap*100}}
    end,
    get_loc_debuff_text = function(self)
        return ""
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if check then return true end
    end,
})

SMODS.Blind({
    key = 'top',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 2},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('A9A295'),
    config = {extra = {frequency = 5}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {math.max(G.GAME.probabilities.normal, 1), self.config.extra.frequency / math.min(G.GAME.probabilities.normal, 1)}}
    end,
    collection_loc_vars = function(self)
        return {vars = {G.GAME.probabilities.normal, self.config.extra.frequency}}
    end,
    drawn_to_hand = function(self)
        for _, card in pairs(G.hand.cards) do
            if not card.top_check then
                if pseudorandom('top_blind') < G.GAME.probabilities.normal / self.config.extra.frequency then
                    card:set_debuff(true)
                    if card.debuff then card.debuffed_by_blind = true end
                end
                card.top_check = true
            end
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff
    end,
    disable = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.top_check then card:set_debuff(); card.top_check = nil end
        end
    end,
    defeat = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.top_check then card:set_debuff(); card.top_check = nil end
        end
    end
})

SMODS.Blind({
    key = 'hammer',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 3},
    dollars = 5,
    mult = 2,
    boss = {min = 3, max = 10},
    boss_colour = HEX('6a3847'),
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    after_scoring = function(self)
        for k, v in ipairs(G.play.cards) do
            if v.ability.set == 'Enhanced' then 
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.7, func = function()
                    v:set_ability(G.P_CENTERS.c_base)
                    return true
                end}))
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('ortalab_hammer')})
            end
        end
    end
})

SMODS.Blind({
    key = 'parasol',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 4},
    dollars = 6,
    mult = 1.75,
    boss = {min = 3, max = 10},
    boss_colour = HEX('A84024'),
    config = {extra = {suit = 'Clubs'}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.suit}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.suit}}
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        for _, card in pairs(cards) do
            if card:is_suit(self.config.extra.suit) then return false end
        end
        return true
    end,
    in_pool = function(self)
        for _, card in pairs(G.playing_cards or {}) do
            if card:is_suit(self.config.extra.suit) then return true end
        end
        return false
    end
})

SMODS.Blind({
    key = 'glass',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 5},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('3e85bd'),
    config = {extra = {discard_amount = 0}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    set_blind = function(self)
        self.config.extra.discard_amount = G.GAME.round_scores.cards_discarded.amt
    end,
    stay_flipped = function(self, area, card)
        if area == G.hand and self.config.extra.discard_amount < G.GAME.round_scores.cards_discarded.amt then
            self.config.extra.discard_amount = self.config.extra.discard_amount + 1
            return true
        end
    end,
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for k, v in pairs(G.playing_cards) do
            v.ability.wheel_flipped = nil
        end
    end
})

SMODS.Blind({
    key = 'tarot',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 6},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('50bf7c'),
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        local _,_,_,scoring_hand,_ = G.FUNCS.get_poker_hand_info(cards)
        local always_scores_count = 0
        for _, card in pairs(cards) do
            if card.config.center.always_scores then always_scores_count = always_scores_count + 1 end
        end
        if #scoring_hand + always_scores_count ~= #cards then return true end
    end,
})

SMODS.Blind({
    key = 'buckler',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 7},
    dollars = 6,
    mult = 1.75,
    boss = {min = 3, max = 10},
    boss_colour = HEX('efc03c'),
    config = {extra = {suit = 'Spades'}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.suit}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.suit}}
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        for _, card in pairs(cards) do
            if card:is_suit(self.config.extra.suit) then return false end
        end
        return true
    end,
    in_pool = function(self)
        for _, card in pairs(G.playing_cards or {}) do
            if card:is_suit(self.config.extra.suit) then return true end
        end
        return false
    end
})

SMODS.Blind({
    key = 'oil',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 8},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('5c6e31'),
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
})

SMODS.Blind({
    key = 'room',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 9},
    dollars = 6,
    mult = 1.75,
    boss = {min = 3, max = 10},
    boss_colour = HEX('b9cb92'),
    config = {extra = {suit = 'Diamonds'}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.suit}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.suit}}
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        for _, card in pairs(cards) do
            if card:is_suit(self.config.extra.suit) then return false end
        end
        return true
    end,
    in_pool = function(self)
        for _, card in pairs(G.playing_cards or {}) do
            if card:is_suit(self.config.extra.suit) then return true end
        end
        return false
    end
})

SMODS.Blind({
    key = 'bellows',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 10},
    dollars = 5,
    mult = 4,
    boss = {min = 3, max = 10},
    boss_colour = HEX('e56a2f'),
    config = {extra = {hand_size = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.hand_size}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.hand_size}}
    end,
    set_blind = function(self)
        G.hand:change_size(self.config.extra.hand_size)
    end,
    defeat = function(self)
        if not G.GAME.blind.disabled then G.hand:change_size(-self.config.extra.hand_size) end
    end,
    disable = function(self)
        G.hand:change_size(-self.config.extra.hand_size)
    end
})

SMODS.Blind({
    key = 'spike',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 11},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('4b71e4'),
    config = {extra = {triggered = false}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        if self.triggered then
            return {vars = {localize(self.config.extra.hand_type, 'poker_hands')}}
        else
            return {key = 'bl_ortalab_spike_collection'}
        end
    end,
    collection_loc_vars = function(self)
        return {key = 'bl_ortalab_spike_collection'}
    end,
    set_blind = function(self)
        local _handname, _played, _order = 'High Card', -1, 100
        for k, v in pairs(G.GAME.hands) do
            if v.played > _played or (v.played == _played and _order > v.order) then 
                _played = v.played
                _handname = k
            end
        end
        G.GAME.current_round.most_played_poker_hand = _handname
        self.config.extra.hand_type = G.GAME.current_round.most_played_poker_hand
        self.triggered = true
        G.GAME.blind:set_text()
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if handname == self.config.extra.hand_type and check and not self.config.extra.triggered then return true end
    end,
    modify_hand = function(self, cards, poker_hands, handname, mult, hand_chips)
        if not self.config.extra.triggered then 
            if handname == self.config.extra.hand_type then
                local _,_,_,scoring_hand,_ = G.FUNCS.get_poker_hand_info(cards)
                for _, card in pairs(scoring_hand) do
                    card:set_debuff(true)
                end
            end
            self.config.extra.triggered = true
        end
        return mult, hand_chips
    end,
    disable = function(self)
        self.triggered = nil
        for _, card in pairs(G.playing_cards) do
            if card.debuff then card:set_debuff() end
        end
    end,
    defeat = function(self)
        self.triggered = nil
        for _, card in pairs(G.playing_cards) do
            if card.debuff then card:set_debuff() end
        end
    end
})

SMODS.Blind({
    key = 'glyph',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 14},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('7e6752'),
    config = {extra = {ranks = {}}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    modify_hand = function(self, cards, poker_hands, handname, mult, hand_chips)
        local _,_,_,scoring_hand,_ = G.FUNCS.get_poker_hand_info(cards)
        for _, card in pairs(scoring_hand) do
            self.config.extra.ranks[card.base.value] = true
        end
        return mult, hand_chips
    end,
    drawn_to_hand = function(self)
        for _, card in pairs(G.playing_cards) do
            if self.config.extra.ranks[card.base.value] then card:set_debuff(true); card.debuffed_by_glyph = true end
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        if self.config.extra.ranks[card.base.value] then
            card.debuffed_by_glyph = true
            return true
        else
            card.debuffed_by_glyph = nil
            return false
        end
    end,
    disable = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.debuffed_by_glyph then card:set_debuff(); card.debuffed_by_glyph = nil end
        end
    end,
    defeat = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.debuffed_by_glyph then card:set_debuff(); card.debuffed_by_glyph = nil end
        end
    end
})

SMODS.Blind({
    key = 'reed',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 12},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('6865f3'),
    config = {extra = {ranks = {}, debuff_count = 4}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        if self.triggered then
            local ranks = {}
            for k, v in pairs(self.config.extra.ranks) do
                table.insert(ranks, k)
            end
            table.sort(ranks, function(a, b) return a < b end)
            return {vars = {ranks[1] or localize('ortalab_blind_no_rank_caps'), ranks[2] or localize('ortalab_blind_no_rank'), ranks[3] or localize('ortalab_blind_no_rank'), ranks[4] or localize('ortalab_blind_no_rank')}}
        else
            return {key = 'bl_ortalab_reed_collection', vars = {self.config.extra.debuff_count}}
        end
    end,
    collection_loc_vars = function(self)
        return {key = 'bl_ortalab_reed_collection', vars = {self.config.extra.debuff_count}}
    end,
    set_blind = function(self)
        local possible_ranks = {}
        for _, card in pairs(G.playing_cards) do
            if not (card.ability.effect == 'Stone Card' or card.config.center.no_rank) and not SMODS.Ranks[card.base.value].face then possible_ranks[card.base.value] = card.base.value end
        end
        if table.size(possible_ranks) > 0 then
            for i=1, math.min(self.config.extra.debuff_count, table.size(possible_ranks)) do
                local rank = pseudorandom_element(possible_ranks, pseudoseed('ortalab_reed'))
                self.config.extra.ranks[rank] = true
                possible_ranks[rank] = nil
            end
        end
        self.triggered = true
        G.GAME.blind:set_text()
    end,
    drawn_to_hand = function(self)
        for _, card in pairs(G.playing_cards) do
            if self.config.extra.ranks[card.base.value] then card:set_debuff(true); card.debuffed_by_reed = true end
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        if self.config.extra.ranks[card.base.value] then
            card.debuffed_by_reed = true
            return true
        else
            card.debuffed_by_reed = nil
            return false
        end
    end,
    disable = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.debuffed_by_reed then card:set_debuff(); card.debuffed_by_reed = nil end
        end
        self.triggered = false
    end,
    defeat = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.debuffed_by_reed then card:set_debuff(); card.debuffed_by_reed = nil end
        end
        self.triggered = false
    end,
    in_pool = function(self)
        local possible_ranks = {}
        for _, card in pairs(G.playing_cards or {}) do
            if not (card.ability.effect == 'Stone Card' or card.config.center.no_rank) and not SMODS.Ranks[card.base.value].face then possible_ranks[card.base.value] = card.base.value end
        end
        if table.size(possible_ranks) > self.config.extra.debuff_count then return true end
        return false
    end
})

SMODS.Blind({
    key = 'ladder',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 13},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('439a4f'),
    config = {extra = {hand_size = 2, actions = 2, action_count = 2}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.hand_size, self.config.extra.actions}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.hand_size, self.config.extra.actions}}
    end,
    set_blind = function(self)
        G.hand:change_size(self.config.extra.hand_size)
    end,
    defeat = function(self)
        if not G.GAME.blind.disabled then G.hand:change_size(-self.config.extra.hand_size) end
    end,
    disable = function(self)
        G.hand:change_size(-self.config.extra.hand_size)
    end
})

SMODS.Blind({
    key = 'hearth',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 15},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('575757'),
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    stay_flipped = function(self, area, card)
        if not card.ability.played_this_ante and area == G.hand then return true end
    end,
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for k, v in pairs(G.playing_cards) do
            v.ability.wheel_flipped = nil
        end
    end
})

SMODS.Blind({
    key = 'spring',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 16},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('c6e0eb'),
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        local text,_,_,_,_ = G.FUNCS.get_poker_hand_info(cards)
        ease_dollars(-G.GAME.hands[text].level)
        return mult, hand_chips, false
    end
})

SMODS.Blind({
    key = 'face',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 17},
    dollars = 6,
    mult = 1.75,
    boss = {min = 3, max = 10},
    boss_colour = HEX('709284'),
    config = {extra = {suit = 'Hearts'}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.suit}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.suit}}
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        for _, card in pairs(cards) do
            if card:is_suit(self.config.extra.suit) then return false end
        end
        return true
    end,
    in_pool = function(self)
        for _, card in pairs(G.playing_cards or {}) do
            if card:is_suit(self.config.extra.suit) then return true end
        end
        return false
    end
})

SMODS.Blind({
    key = 'tongs',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 18},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('b95c96'),
    config = {extra = {change = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.change}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.change}}
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        for _, card in pairs(cards) do
            G.E_MANAGER:add_event(Event({ trigger = 'after', func = function()
                G.GAME.blind.chips = G.GAME.blind.chips * (1 + self.config.extra.change/100)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                card:juice_up()
                return true
            end })) 
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ortalab_tongs')})
        end
        return mult, hand_chips, false
    end
})

SMODS.Blind({
    key = 'beam',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 19},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('b95b08'),
    config = {extra = {ranks = {}, flipped = 5}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        if self.triggered then
            local ranks = {}
            for k, v in pairs(self.config.extra.ranks) do
                table.insert(ranks, k)
            end
            table.sort(ranks, function(a, b) return a < b end)
            return {vars = {ranks[1] or localize('ortalab_blind_no_rank_caps'), ranks[2] or localize('ortalab_blind_no_rank'), ranks[3] or localize('ortalab_blind_no_rank'), ranks[4] or localize('ortalab_blind_no_rank'), ranks[5] or localize('ortalab_blind_no_rank')}}
        else
            return {key = 'bl_ortalab_beam_collection', vars = {self.config.extra.flipped}}
        end
    end,
    collection_loc_vars = function(self)
        return {key = 'bl_ortalab_beam_collection', vars = {self.config.extra.flipped}}
    end,
    set_blind = function(self)
        local possible_ranks = {}
        for _, card in pairs(G.playing_cards) do
            if not (card.ability.effect == 'Stone Card' or card.config.center.no_rank) and not SMODS.Ranks[card.base.value].face then possible_ranks[card.base.value] = card.base.value end
        end
        if table.size(possible_ranks) > 0 then
            for i=1, math.min(table.size(possible_ranks), self.config.extra.flipped) do
                local rank = pseudorandom_element(possible_ranks, pseudoseed('ortalab_beam'))
                self.config.extra.ranks[rank] = true
                possible_ranks[rank] = nil
            end
        end
        self.triggered = true
        G.GAME.blind:set_text()
    end,
    stay_flipped = function(self, area, card)
        if self.config.extra.ranks[card.base.value] and area == G.hand then card.flipped_by_beam = true; return true end
    end,
    disable = function(self)
        for _, card in pairs(G.hand.cards) do
            if card.flipped_by_beam then card:flip() end
        end
        self.triggered = false
    end,
    defeat = function(self)
        self.triggered = false
    end,
    in_pool = function(self)
        local possible_ranks = {}
        for _, card in pairs(G.playing_cards or {}) do
            if not (card.ability.effect == 'Stone Card' or card.config.center.no_rank) and not SMODS.Ranks[card.base.value].face then possible_ranks[card.base.value] = card.base.value end
        end
        if table.size(possible_ranks) > self.config.extra.flipped then return true end
        return false
    end
})

SMODS.Blind({
    key = 'sheep',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 20},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('ac9db4'),
    config = {extra = {reset = 5, hand_type = nil}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        if self.config.extra.hand_type then
            return {vars = {localize(self.config.extra.hand_type, 'poker_hands'), self.config.extra.reset}}
        else
            return {key = 'bl_ortalab_sheep_collection', vars = {self.config.extra.reset}}

        end
    end,
    collection_loc_vars = function(self)
        return {key = 'bl_ortalab_sheep_collection', vars = {self.config.extra.reset}}
    end,
    set_blind = function(self)
        self.config.extra.hand_type = G.GAME.current_round.most_played_poker_hand
        G.GAME.blind:set_text()
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        if text ~= self.config.extra.hand_type then
            ease_dollars(self.config.extra.reset - G.GAME.dollars)
            play_sound('ortalab_sheep', 0.96+math.random()*0.08)
            G.GAME.blind:wiggle()
        end
        return mult, hand_chips, false
    end
})

SMODS.Sound{key = 'sheep', path = 'sheep.ogg'}

SMODS.Blind({
    key = 'lever',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 21},
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('8a59a5'),
    config = {extra = {triggered = false}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    drawn_to_hand = function(self)
        if not self.config.extra.triggered then
            for _, card in pairs(G.hand.cards) do
                card:set_debuff(true)
                if card.debuff then card.debuffed_by_blind = true end
            end
            self.config.extra.triggered = true
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff
    end,
    disable = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.debuff then card:set_debuff() end
        end
    end,
    defeat = function(self)
        for _, card in pairs(G.playing_cards) do
            if card.debuff then card:set_debuff() end
        end
    end
})

SMODS.Blind({
    key = 'steel',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 22},
    dollars = 6,
    mult = 0.75,
    boss = {min = 3, max = 7},
    boss_colour = HEX('b52d2d'),
    in_pool = function(self)
        if G.GAME.round_resets.ante > 8 or G.GAME.round_resets.ante < 2 then return false end
        return true
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    update_score = function(self, args)
        local min = math.min(args.chips, args.mult)
        args.mult = min
        args.chips = min
        update_hand_text({delay = 0}, {mult = args.mult, chips = args.chips})

        G.E_MANAGER:add_event(Event({
            func = (function()
                local text = localize('ortalab_minimised')
                play_sound('gong', 0.94, 0.3)
                play_sound('gong', 0.94*1.5, 0.2)
                play_sound('tarot1', 1.5)
                ease_colour(G.C.UI_CHIPS, darken(G.C.UI_MULT, 0.5))
                ease_colour(G.C.UI_MULT, darken(G.C.UI_MULT, 0.5))
                attention_text({
                    scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    delay =  4.3,
                    func = (function() 
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                            ease_colour(G.C.UI_MULT, G.C.RED, 2)
                        return true
                    end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    no_delete = true,
                    delay =  6.3,
                    func = (function() 
                        G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                        G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                        return true
                    end)
                }))
                return true
            end)
        }))

        delay(0.6)

        return min
    end
})

SMODS.Blind({
    key = 'celadon_clubs',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 23},
    dollars = 8,
    mult = 2,
    boss = {min = 1, max = 10, showdown = true},
    boss_colour = HEX('22857b'),
    config = {extra = {options = {'Face', 'Even', 'Odd'}, current = 'Face'}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.current}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.current}}
    end,
    disable = function(self)
        for _, card in pairs(G.playing_cards) do
            card.celadon_disabled = false
        end
    end,
    defeat = function(self)
        for _, card in pairs(G.playing_cards) do
            card.celadon_disabled = false
        end
    end,
    drawn_to_hand = function(self)
        if not self.prepped then
            self.config.extra.current = pseudorandom_element(self.config.extra.options, pseudoseed('celadon_shuffle'))
            attention_text({
                scale = 1, text = 'Disabling '..self.config.extra.current..' cards!', hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
            })
        end
        for _, card in pairs(G.hand.cards) do
            celadon_check(self, card)
        end
    end,
    press_play = function(self)
        self.prepped = false
    end,
    recalc_debuff = function(self, card, from_blind)
        celadon_check(self, card)
        return card.debuff
    end
})

SMODS.Shader({key = 'celadon', path = 'applied.fs'})

function celadon_check(self, card)
    card.celadon_disabled = false
    if card:is_face() then
        if self.config.extra.current == 'Face' then
            card.celadon_disabled = true
        end
    elseif card.base.nominal % 2 == 0 then
        if self.config.extra.current == 'Even' then
            card.celadon_disabled = true
        end
    else
        if self.config.extra.current == 'Odd' then
            card.celadon_disabled = true
        end
    end
end

local highlight_card = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
    if card.celadon_disabled then return end
    highlight_card(self, card, silent)
end

SMODS.Blind({
    key = 'caramel_coin',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 24},
    dollars = 8,
    mult = 2,
    boss = {min = 1, max = 10, showdown = true},
    boss_colour = HEX('c77a32'),
    config = {extra = {hand_size = 3}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.hand_size}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.hand_size}}
    end,
    set_blind = function(self)
        G.hand:change_size(-self.config.extra.hand_size)
    end,
    disable = function(self)
        if not G.GAME.blind.disabled then G.hand:change_size(self.config.extra.hand_size) end
    end,
    defeat = function(self)
        G.hand:change_size(self.config.extra.hand_size)
    end
})

SMODS.Blind({
    key = 'saffron_shield',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 25},
    dollars = 8,
    mult = 2,
    boss = {min = 1, max = 10, showdown = true},
    boss_colour = HEX('fdca57'),
    config = {extra = {chance = 2}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {math.max(G.GAME.probabilities.normal, 1), self.config.extra.chance / math.min(G.GAME.probabilities.normal, 1)}}
    end,
    collection_loc_vars = function(self)
        return {vars = {G.GAME.probabilities.normal, self.config.extra.chance}}
    end,
    stay_flipped = function (self, area, card)
        if self.disabled or area ~= G.hand then return false end
        if pseudorandom(pseudoseed('saffron_shield')) < G.GAME.probabilities.normal / self.config.extra.chance then
            return true
        end
    end
})

SMODS.Blind({
    key = 'rouge_rose',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 26},
    dollars = 8,
    mult = 2.5,
    boss = {min = 1, max = 10, showdown = true},
    boss_colour = HEX('a85476'),
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    collection_loc_vars = function(self)
    end,
    set_blind = function(self)
        G.GAME.Ortalab_old_deck = CardArea(
            0, 0,
            G.CARD_W,G.CARD_H,
            {card_limit = 500, type = 'discard'})
        for i=1, #G.deck.cards do
            G.GAME.Ortalab_old_deck:draw_card_from(G.deck)
        end
        G.playing_cards = {}
        local card_protos = {}
        for k, v in pairs(G.P_CARDS) do
            local _ = nil
            local _r, _s = string.sub(k, 3, 3), string.sub(k, 1, 1)
            if table.contains({'S', 'C','D','H'},_s) then
                card_protos[#card_protos+1] = {s=_s,r=_r,e=nil,d=nil,g=nil}
            end
        end

        table.sort(card_protos, function (a, b) return 
            ((a.s or '')..(a.r or '')..(a.e or '')..(a.d or '')..(a.g or '')) < 
            ((b.s or '')..(b.r or '')..(b.e or '')..(b.d or '')..(b.g or '')) end)

        for k, v in ipairs(card_protos) do
            card_from_control(v)
        end
        self.original_deck_size = G.GAME.starting_deck_size
        G.GAME.starting_deck_size = #G.playing_cards
    end,
    disable = function(self)
        remove_all(G.hand.cards)
        self.defeat()
    end,
    defeat = function(self)
        remove_all(G.deck.cards)
        G.playing_cards = {}
        for i=1, #G.GAME.Ortalab_old_deck.cards do
            G.deck:draw_card_from(G.GAME.Ortalab_old_deck)
        end
        for _, card in ipairs(G.deck.cards) do
            table.insert(G.playing_cards, card)
        end
        G.GAME.starting_deck_size = self.original_deck_size
    end
})


SMODS.Blind({
    key = 'silver_sword',
    atlas = 'ortalab_blinds',
    pos = {x = 0, y = 27},
    dollars = 8,
    mult = 3,
    boss = {min = 1, max = 10, showdown = true},
    boss_colour = HEX('9bafcf'),
    config = {extra = {hands = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {self.config.extra.hands}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.hands}}
    end,
    set_blind = function(self)
        self.hands_sub = G.GAME.round_resets.hands - self.config.extra.hands
        ease_hands_played(-self.hands_sub)
    end,
    disable = function(self)
        self.hands_sub = G.GAME.round_resets.hands - self.config.extra.hands
        ease_hands_played(self.hands_sub)
    end
})


local draw_discard = G.FUNCS.draw_from_play_to_discard
G.FUNCS.draw_from_play_to_discard = function(e)
    local obj = G.GAME.blind.config.blind
    if obj.after_scoring and not G.GAME.blind.disabled then
        obj:after_scoring()
    end
    draw_discard(e)
end