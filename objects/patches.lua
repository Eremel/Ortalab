SMODS.Atlas({
    key = 'patches',
    path = 'patches.png',
    px = '34',
    py = '34'
})

SMODS.Tag({
    key = 'common',
    atlas = 'patches',
    pos = {x = 2, y = 2},
    discovered = false,
    config = {type = 'store_joker_create', dollars = 3},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = '5381'} end
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {self.config.dollars, (G.GAME.blinds_defeated or 0)*self.config.dollars}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            local card = create_card('Joker', context.area, nil, 0, nil, nil, nil, 'uta')
            if not card.edition then
                card:set_edition(poll_edition('ortalab_common_patch', nil, false, true))
            end
            create_shop_card_ui(card, 'Joker', context.area)
            card.states.visible = false
            tag:yep('+', G.C.GREEN,function() 
                card:start_materialize()
                card.ability.couponed = true
                card:set_cost()
                return true
            end)
            tag.triggered = true
            return card
        end
    end
})

SMODS.Tag({
    key = 'anaglyphic',
    atlas = 'patches',
    pos = {x = 4, y = 2},
    discovered = false,
    config = {type = 'store_joker_modify', edition = 'e_ortalab_anaglyphic'},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.edition]
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    context.card:set_edition(tag.config.edition, true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_edition = nil
                    return true
                end)
                tag.triggered = true
            end
        end
    end
})

SMODS.Tag({
    key = 'fluorescent',
    atlas = 'patches',
    pos = {x = 0, y = 3},
    discovered = false,
    config = {type = 'store_joker_modify', edition = 'e_ortalab_fluorescent'},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.edition]
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    context.card:set_edition(tag.config.edition, true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_edition = nil
                    return true
                end)
                tag.triggered = true
            end
        end
    end
})

SMODS.Tag({
    key = 'greyscale',
    atlas = 'patches',
    pos = {x = 1, y = 3},
    discovered = false,
    config = {type = 'store_joker_modify', edition = 'e_ortalab_greyscale'},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'coro'} end
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.edition]
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    context.card:set_edition(tag.config.edition, true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_edition = nil
                    return true
                end)
                tag.triggered = true
            end
        end
    end
})

SMODS.Tag({
    key = 'overexposed',
    atlas = 'patches',
    pos = {x = 3, y = 2},
    discovered = false,
    config = {type = 'store_joker_modify', edition = 'e_ortalab_overexposed'},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    context.card:set_edition(tag.config.edition, true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_edition = nil
                    return true
                end)
                tag.triggered = true
            end
        end
    end
})

SMODS.Tag({
    key = 'rewind',
    atlas = 'patches',
    pos = {x = 0, y = 0},
    discovered = false,
    in_pool = function(self)
        if G.GAME.last_selected_tag and G.GAME.last_selected_tag.key ~= 'tag_ortalab_rewind' then
            return true
        end
        return false
    end,
    config = {type = 'immediate'},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {G.GAME.last_selected_tag and localize({type = 'name_text', set = 'Tag', key = G.GAME.last_selected_tag.key}) or localize('ortalab_no_tag')}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if G.GAME.last_selected_tag and G.GAME.last_selected_tag.key then
                tag:yep('+', G.C.GREEN,function() 
                    return true
                end)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        local tag = Tag(G.GAME.last_selected_tag.key, false, G.GAME.last_selected_tag.ability.blind_type)
                        if G.GAME.last_selected_tag.key == 'tag_orbital' then
                            local _poker_hands = {}
                            for k, v in pairs(G.GAME.hands) do
                                if v.visible then _poker_hands[#_poker_hands+1] = k end
                            end
                            tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed('rewind_orbital'))
                        end
                        add_tag(tag)
                        return true
                end}))
                tag.triggered = true
                return true
            end
            tag:nope()
            return true
        end
    end
})

-- SMODS.Tag({
--     key = 'recycle',
--     atlas = 'patches',
--     pos = {x = 1, y = 0},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'dfour',
--     atlas = 'patches',
--     pos = {x = 2, y = 0},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'bargain',
--     atlas = 'patches',
--     pos = {x = 3, y = 0},
--     discovered = false,
-- })

SMODS.Tag({
    key = 'minion',
    atlas = 'patches',
    pos = {x = 4, y = 0},
    discovered = false,
    config = {type = 'round_start_bonus', modifier = 0.5},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if G.GAME.blind:get_type() == 'Boss' then return end
            tag:yep('+', G.C.GREEN ,function() 
                return true
            end)
            G.E_MANAGER:add_event(Event({
                delay = 0.2,
                trigger = 'after',
                func = function()
            G.GAME.blind.chips = G.GAME.blind.chips * tag.config.modifier
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true
                end}))
            tag.triggered = true
        end
    end
})

SMODS.Tag({
    key = 'slipup',
    atlas = 'patches',
    pos = {x = 0, y = 1},
    discovered = false,
    config = {type = 'round_start_bonus', discards = 2},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {self.config.discards}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.RED ,function() 
                return true
            end)
            ease_discard(tag.config.discards)
            tag.triggered = true
        end
    end
})

-- SMODS.Tag({
--     key = 'extraordinary',
--     atlas = 'patches',
--     pos = {x = 1, y = 1},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'charm',
--     atlas = 'patches',
--     pos = {x = 2, y = 1},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'buffoon',
--     atlas = 'patches',
--     pos = {x = 3, y = 1},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'jackpot',
--     atlas = 'patches',
--     pos = {x = 4, y = 1},
--     discovered = false,
-- })

SMODS.Tag({
    key = 'soul',
    atlas = 'patches',
    pos = {x = 0, y = 2},
    soul_pos = {x = 1, y = 2},
    discovered = false,
    min_ante = 3,
    config = {type = 'store_joker_create'},
    in_pool = function(self)
        local chance = pseudoseed('ortalab_soul_patch')
        if chance < 0.25 then
            return true
        end
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {self.config.cost}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            local card = create_card('Joker', context.area, true, 1, nil, nil, nil, 'uta')
            create_shop_card_ui(card, 'Joker', context.area)
            card.states.visible = false
            tag:yep('+', G.C.GREEN,function() 
                card:start_materialize()
                card.ability.couponed = true
                card:set_cost()
                return true
            end)
            tag.triggered = true
            return card
        end
    end
})

SMODS.Tag({
    key = 'slayer',
    atlas = 'patches',
    pos = {x = 0, y = 4},
    discovered = false,
    min_ante = 2,
    config = {type = 'immediate', dollars = 3},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {self.config.dollars, (G.GAME.blinds_defeated or 0)*self.config.dollars}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.MONEY,function() 
                G.CONTROLLER.locks[tag.ID] = nil
                return true
            end)
            ease_dollars((G.GAME.blinds_defeated or 0)*tag.config.dollars)
            tag.triggered = true
            return true
        end
    end
})

SMODS.Tag({
    key = 'dandy',
    atlas = 'patches',
    pos = {x = 3, y = 3},
    discovered = false,
    min_ante = 2,
    config = {type = 'immediate', dollars = 1},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {self.config.dollars, (G.GAME.unused_hands or 0)*self.config.dollars}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.MONEY,function() 
                return true
            end)
            ease_dollars((G.GAME.unused_hands or 0)*tag.config.dollars)
            tag.triggered = true
            return true
        end
    end
})

SMODS.Tag({
    key = 'loteria',
    atlas = 'patches',
    pos = {x = 2, y = 4},
    discovered = false,
    config = {type = 'shop_final_pass', packs = 2},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue + 1] = G.P_CENTERS['p_ortalab_big_loteria_1']
        return {vars = {self.config.packs}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.GREEN,function()
                for i=1, tag.config.packs do
                    local pack = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS['p_ortalab_big_loteria_'..i], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(pack, 'Booster', G.shop_booster)
                    pack.ability.booster_pos = #G.shop_booster.cards + 1
                    pack.ability.couponed = true
                    pack:start_materialize()
                    G.shop_booster:emplace(pack)
                    pack:set_cost()
                end
                return true
            end)
        end
    end
})

SMODS.Tag({
    key = 'crater',
    atlas = 'patches',
    pos = {x = 2, y = 3},
    discovered = false,
    config = {type = 'shop_final_pass', packs = 2},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue + 1] = G.P_CENTERS['p_ortalab_big_zodiac_1']
        return {vars = {self.config.packs}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.GREEN,function()
                for i=1, tag.config.packs do
                    local pack = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS['p_ortalab_big_zodiac_'..i], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(pack, 'Booster', G.shop_booster)
                    pack.ability.booster_pos = #G.shop_booster.cards + 1
                    pack.ability.couponed = true
                    pack:start_materialize()
                    G.shop_booster:emplace(pack)
                    pack:set_cost()
                end
                return true
            end)
        end
        
    end
})

local skip_blind = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function(e)
    local _tag = e.UIBox:get_UIE_by_ID('tag_container').config.ref_table
    skip_blind(e)
    if _tag.key == 'tag_ortalab_rewind' then return end
    G.GAME.last_selected_tag = _tag or G.GAME.last_selected_tag
end

-- SMODS.Tag({
--     key = 'constellation',
--     atlas = 'patches',
--     pos = {x = 1, y = 4},
--     discovered = false,
--     config = {type = 'round_start_bonus', zodiacs = 2},
--     loc_vars = function(self, info_queue, card)
--         if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
--         if card.ability.zodiac_hands and G.ZODIACS[card.ability.zodiac_hands[1]] then
--             return {vars = {
--                 localize(G.ZODIACS[card.ability.zodiac_hands[1]].config.extra.hand_type, 'poker_hands'),
--                 localize(G.ZODIACS[card.ability.zodiac_hands[2]].config.extra.hand_type, 'poker_hands'),
--             }}
--         else
--             return {vars = {'['..localize('k_poker_hand')..']', '['..localize('k_poker_hand')..']'}}
--         end
--     end,
--     apply = function(self, tag, context)
--         if context.type == self.config.type then
--             tag:yep('+', G.C.GREEN,function()
--                 tag.triggered = true
--                 return true
--             end)
--             for _, key in ipairs(tag.ability.zodiac_hands) do
--                 G.E_MANAGER:add_event(Event({
--                     trigger = 'before',
--                     delay = 4.2,
--                     func = function()
--                         if G.zodiacs and G.zodiacs[key] then
--                             G.zodiacs[key].config.extra.temp_level = G.zodiacs[key].config.extra.temp_level + G.ZODIACS[key].config.extra.temp_level
--                             zodiac_text(zodiac_upgrade_text(key), key)
--                             G.zodiacs[key]:juice_up(1, 1)
--                             delay(0.7)
--                         else
--                             add_zodiac(Zodiac(key))
--                         end
--                         return true
--                     end
--                 }))
--             end
--         end
--     end,
--     set_ability = function(self, tag)
--         if G.zodiac_choices then
--             tag.ability.zodiac_hands = G.zodiac_choices
--         elseif tag.ability.blind_type then
--             if G.GAME.zodiac_choices and G.GAME.zodiac_choices[G.GAME.round_resets.ante][tag.ability.blind_type] then
--                 tag.ability.zodiac_hands = G.GAME.zodiac_choices[G.GAME.round_resets.ante][tag.ability.blind_type]
--             end
--         end
--     end
-- })
