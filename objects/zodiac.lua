SMODS.Atlas({ -- zodiac card atlas
    key = 'zodiac_cards',
    path = 'zodiac.png',
    px = '71',
    py = '95'
})

SMODS.Atlas{ -- zodiac indicators atlas
    key = 'zodiac_tags',
    path = 'zodiac_tags.png',
    px = 34,
    py = 34
}

SMODS.Atlas{
    key = 'zodiac_constellations',
    path = 'zodiac_constellations.png',
    px = 150,
    py = 150
}

SMODS.load_file('objects/zodiac_boosters.lua')() -- load boosters

SMODS.UndiscoveredSprite({ -- undiscovered sprite
    key = "Zodiac",
    atlas = "zodiac_cards",
    pos = { x = 0, y = 3 },
    no_overlay = true
})

G.ARGS.LOC_COLOURS['Zodiac'] = HEX("a84040")

SMODS.ConsumableType({ -- Zodiac Card ConsumableType creation
    key = "Zodiac",
    primary_colour = HEX("a84040"),
    secondary_colour = HEX("a84040"),
    loc_txt = { -- move to localization
        name = "Zodiac Card",
        collection = "Zodiac Cards",
        undiscovered = {
            name = 'Unknown Zodiac Card',
            text = {
                'Find this card in an unseeded',
                'run to find out what it does'
            }
        }
    },
    collection_rows = {6, 6},
    shop_rate = 0.6,
    default = 'c_ortalab_zod_scorpio' -- High Card zodiac
})

G.ZODIACS = {} -- stores zodiacs
Ortalab.Zodiac = SMODS.Tag:extend { -- Zodiac Indicator Definition
    atlas = 'ortalab_zodiac_tags',
    class_prefix = 'zodiac',
    in_pool = function() return false end,
    inject = function(self)
        G.ZODIACS[self.key] = self
    end,
    triggered = function(self, card)
        if card.triggered then
            self:remove_zodiac(card)
        end
    end
}
Ortalab.zodiac_reduction = 2

-- remove triggered zodiacs
local evaluate_play = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
    evaluate_play(e)
    if zodiac_current and zodiac_current.triggered then
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.2, func = function()
                zodiac_current:remove_zodiac('')
                return true
            end}))
    elseif zodiac_current then
        G.E_MANAGER:add_event(Event({
            delay = 0.4,
            trigger = 'after',
            func = (function()
                attention_text({
                    text = '-'..G.GAME.Ortalab_Zodiac_Reduction,
                    colour = G.C.WHITE,
                    scale = 1, 
                    hold = 1/G.SETTINGS.GAMESPEED,
                    cover = zodiac_current.HUD_zodiac,
                    cover_colour = G.ARGS.LOC_COLOURS.Zodiac,
                    align = 'cm',
                    })
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                return true
            end)
        }))
    end
end


function add_zodiac(_tag, silent, from_load) -- Add a zodiac to the indicator area
    if G.GAME.Ortalab_zodiac_temp_level_mod and not from_load then
        _tag.config.extra.temp_level = _tag.config.extra.temp_level * G.GAME.Ortalab_zodiac_temp_level_mod
    end
    if G.GAME.Ortalab_zodiac_voucher and not from_load then
        _tag.config.extra.temp_level = _tag.config.extra.temp_level + G.GAME.Ortalab_zodiac_voucher
    end
    _tag.voucher_check = true
    G.HUD_zodiac = G.HUD_zodiac or {}
    G.zodiacs = G.zodiacs or {}
    local tag_sprite_ui = _tag:generate_UI()
    G.HUD_zodiac[#G.HUD_zodiac+1] = UIBox{
        definition = {n=G.UIT.ROOT, config={align = "cm",padding = 0.05, colour = G.C.CLEAR}, nodes={
          tag_sprite_ui
        }},
        config = {
          align = G.HUD_zodiac[1] and 'cm' or 'cr',
          offset = G.HUD_zodiac[1] and {x=0,y=math.min(0.5, 2.5/#G.HUD_zodiac)} or {x=0,y=-1},
          major = G.HUD_zodiac[1] and G.HUD_zodiac[#G.HUD_zodiac] or G.consumeables},
          ref_table = _tag
    }

    for i, v in ipairs(G.HUD_zodiac) do
        if i > 1 then G.HUD_zodiac[i].Mid.alignment.offset = {x=0,y=math.min(0.5, 2.5/#G.HUD_zodiac)}; G.HUD_zodiac[i]:recalculate() end
    end
    G.zodiacs[_tag.key] = _tag

    _tag.HUD_zodiac = G.HUD_zodiac[#G.HUD_zodiac]
    if not silent then zodiac_text(localize({set='Tag', key=_tag.key, type='name_text'})..localize('ortalab_zodiac_added'), _tag.key) end
    delay(0.7)
end
Zodiac = Object:extend()

function Zodiac:init(_tag, for_collection, _blind_type)
    self.key = _tag
    local proto = G.ZODIACS[_tag]
    self.config = copy_table(proto.config)
    self.pos = proto.pos
    self.soul_pos = proto.soul_pos
    self.name = proto.name
    self.tally = G.GAME.zodiac_tally or 0
    self.triggered = false
    G.zodiacid = G.zodiacid or 0
    self.ID = G.zodiacid
    G.zodiacid = G.zodiacid + 1
    self.ability = {}
    G.GAME.zodiac_tally = G.GAME.zodiac_tally and (G.GAME.zodiac_tally + 1) or 1
end

function Zodiac:generate_UI(_size)
    _size = _size or 0.8

    local tag_sprite_tab = nil
    local tag_sprite = Sprite(0,0,_size*1,_size*1,G.ASSET_ATLAS[(not self.hide_ability) and G.ZODIACS[self.key].atlas or "tags"], (self.hide_ability) and G.tag_undiscovered.pos or self.pos)

    tag_sprite.T.scale = 1
    tag_sprite_tab = {n= G.UIT.C, config={align = "cm", ref_table = self, group = self.tally}, nodes={
        {n=G.UIT.O, config={w=_size*1,h=_size*1, colour = G.C.BLUE, object = tag_sprite, focus_with_object = true}},
    }}
    tag_sprite:define_draw_steps({
        {shader = 'dissolve', shadow_height = 0.05},
        {shader = 'dissolve'},
    })
    tag_sprite.float = true
    tag_sprite.states.hover.can = true
    tag_sprite.states.drag.can = false
    tag_sprite.states.collide.can = true
    tag_sprite.config = {tag = self, force_focus = true}

    tag_sprite.hover = function(_self)
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
            if not _self.hovering and _self.states.visible then
                _self.hovering = true
                if _self == tag_sprite then
                    _self.hover_tilt = 3
                    _self:juice_up(0.05, 0.02)
                    play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
                    play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)
                end

                self:get_uibox_table(tag_sprite)
                _self.config.h_popup =  G.UIDEF.card_h_popup(_self)
                _self.config.h_popup_config = (_self.T.x > G.ROOM.T.w*0.4) and
                    {align =  'bl', offset = {x=-0.1,y=-_self.T.h},parent = _self} or
                    {align =  'cr', offset = {x=0.1,y=0},parent = _self}
                Node.hover(_self)
                if _self.children.alert then 
                    _self.children.alert:remove()
                    _self.children.alert = nil
                    if self.key and G.ZODIACS[self.key] then G.ZODIACS[self.key].alerted = true end
                    G:save_progress()
                end
            end
        end
    end
    tag_sprite.stop_hover = function(_self) _self.hovering = false; Node.stop_hover(_self); _self.hover_tilt = 0 end

    tag_sprite:juice_up()
    self.tag_sprite = tag_sprite

    return tag_sprite_tab, tag_sprite
end

function Zodiac:juice_up(_scale, _rot)
    if self.tag_sprite then self.tag_sprite:juice_up(_scale, _rot) end
end

function Zodiac:get_uibox_table(tag_sprite)
    tag_sprite = tag_sprite or self.tag_sprite
    local name_to_check, loc_vars = self.name, G.ZODIACS[self.key]:loc_vars(nil, G.zodiacs[self.key]).vars
    tag_sprite.ability_UIBox_table = generate_card_ui(G.ZODIACS[self.key], nil, loc_vars, (self.hide_ability) and 'Undiscovered' or 'Tag', nil, (self.hide_ability), nil, nil, self)
    return tag_sprite
end

function Zodiac:remove_from_game()
    local tag_key = nil
    for k, v in pairs(G.zodiacs) do
        if v == self then tag_key = k end
    end
    table.remove(G.zodiacs, tag_key)
end

function Zodiac:remove_zodiac(message, _colour, func) -- Remove a zodiac from the indicator area
    if message then 
        G.E_MANAGER:add_event(Event({
            delay = 0.4,
            trigger = 'after',
            func = (function()
                attention_text({
                    text = message,
                    colour = G.C.WHITE,
                    scale = 1, 
                    hold = 0.6/G.SETTINGS.GAMESPEED,
                    cover = self.HUD_zodiac,
                    cover_colour = G.ARGS.LOC_COLOURS.Zodiac,
                    align = 'cm',
                    })
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                return true
            end)
        }))
        G.E_MANAGER:add_event(Event({
            func = (function()
                self.HUD_zodiac.states.visible = false
                return true
            end)
        }))
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.7,
        func = (function()
            self:remove_from_game()
            local HUD_tag_key = nil
            for k, v in pairs(G.HUD_zodiac) do
                if v == self.HUD_zodiac then HUD_tag_key = k end
            end

            if HUD_tag_key then 
                if G.HUD_zodiac and G.HUD_zodiac[HUD_tag_key+1] then
                    if HUD_tag_key == 1 then
                        G.HUD_zodiac[HUD_tag_key+1]:set_alignment({type = 'cr',
                        offset = {x=0,y=-1},
                        xy_bond = 'Weak',
                        major = G.consumeables})
                    else
                        G.HUD_zodiac[HUD_tag_key+1]:set_role({
                        xy_bond = 'Weak',
                        major = G.HUD_zodiac[HUD_tag_key-1]})
                    end
                end
                table.remove(G.HUD_zodiac, HUD_tag_key)
            end

            self.HUD_zodiac:remove()
            return true
        end)
    }))
    if G.zodiacs[self.key] then
        G.zodiacs[self.key] = nil
    end
end

function Zodiac:save()
    return {
        key = self.key,
        tally = self.tally, 
        ability = self.ability,
        config = self.config
    }
end

function Zodiac:load(tag_savetable)
    self.key = tag_savetable.key
    local proto = G.ZODIACS[self.key] or G.tag_undiscovered
    self.config = tag_savetable.config or copy_table(proto.config)
    self.pos = proto.pos
    self.name = proto.name
    self.tally = tag_savetable.tally
    self.ability = tag_savetable.ability
end

function zodiac_tooltip(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    desc_nodes.tag = true
    desc_nodes.title = localize({type = 'name_text', set = 'Tag', key = _c.key})
    localize{type = 'descriptions', set = 'Tag', key = _c.key, nodes = desc_nodes, vars = specific_vars or G.ZODIACS[_c.key]:loc_vars(info_queue).vars}
end

local start = Game.start_run
function Game:start_run(args)
    if self.HUD_zodiacs then
        for k, v in pairs(self.HUD_zodiacs) do
            v:remove()
        end
        self.HUD_zodiacs = nil
    end
    if self.zodiacs then
        for k, v in pairs(self.zodiacs) do
            if (type(v) == "table") and v.is and v:is(Zodiac) then 
                v:remove_zodiac()
            end
        end
    end
    start(self, args)
    self.GAME.zodiacs_activated = {}
    self.GAME.Ortalab_Zodiac_Reduction = 2
    self.GAME.Ortalab_zodiac_voucher = 0
    self.GAME.Ortalab_zodiac_temp_level_mod = 1
end
-- ZODIAC CODE BELOW

SMODS.Consumable({
    key = 'zod_aries',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=0, y=0},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_aries'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'aries',
    pos = {x=2, y=0},
    colour = HEX('b64646'),
    config = {extra = {temp_level = 4, hand_type = 'Four of a Kind'}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands')}}
    end,
    destroy = function(self, zodiac, context)
        if context.other_card.base.value == context.scoring_hand[1].base.value then
            return false
        end
        return true
    end
}

SMODS.Consumable({
    key = 'zod_taurus',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=1, y=0},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_taurus'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'taurus',
    pos = {x=3, y=0},
    colour = HEX('cb703d'),
    config = {extra = {temp_level = 4, hand_type = 'Three of a Kind', amount = 3}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        if not card then info_queue[#info_queue + 1] = G.P_CENTERS['m_ortalab_rusty'] end
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands'), zodiac.config.extra.amount}}
    end,
    pre_trigger = function(self, zodiac, context)
        for i=1, zodiac.config.extra.amount do
            if G.hand.cards[i] then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before', delay = 0.2, func = function()
                        zodiac:juice_up()
                        G.hand.cards[i]:set_ability(G.P_CENTERS['m_ortalab_rusty'])
                        G.hand.cards[i]:juice_up()
                        return true
                    end}))
            end
        end
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}



SMODS.Consumable({
    key = 'zod_gemini',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=2, y=0},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_gemini'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'gemini',
    pos = {x=4, y=0},
    colour = HEX('d9c270'),
    config = {extra = {temp_level = 4, hand_type = 'Pair'}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands')}}
    end,
    pre_trigger = function(self, zodiac, context)
        local effects = {'m_ortalab_post', 'm_ortalab_bent'}
        for i=1, 2 do
            context.scoring_hand[i]:set_ability(G.P_CENTERS[effects[i]], nil, true)
            local name = context.scoring_hand[i].ability.effect
            context.scoring_hand[i].ability.effect = nil
            G.E_MANAGER:add_event(Event({
                trigger = 'before', delay = 0.2, func = function()
                    zodiac:juice_up()
                    context.scoring_hand[i].ability.effect = name
                    context.scoring_hand[i]:juice_up()
                    return true
                end}))
        end
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}

SMODS.Consumable({
    key = 'zod_cancer',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=3, y=0},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_cancer'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'}; info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'salad'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'cancer',
    pos = {x=5, y=0},
    colour = HEX('878879'),
    config = {extra = {temp_level = 4, hand_type = 'Flush House'}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands')}}
    end,
    pre_trigger = function(self, zodiac, context)
        local suits_in_flush = {}
        local new_suit = context.scoring_hand[1].base.suit
        local ranks_in_flush = {}
        local rank1, rank2
        for _, card in pairs(context.scoring_hand) do
            suits_in_flush[card.base.suit] = suits_in_flush[card.base.suit] and suits_in_flush[card.base.suit] + 1 or 1
            ranks_in_flush[card.base.value] = ranks_in_flush[card.base.value] and ranks_in_flush[card.base.value] + 1 or 1
            if suits_in_flush[card.base.suit] > suits_in_flush[new_suit] then new_suit = card.base.suit end
        end
        for rank, amount in pairs(ranks_in_flush) do
            if amount == 3 then rank1 = rank elseif amount == 2 then rank2 = rank end
        end
        for i, card in ipairs(G.hand.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'before', delay = 0.2, func = function()
                    zodiac:juice_up()
                    SMODS.change_base(card, new_suit, i % 2 == 0 and rank1 or rank2)
                    if card.ability.set ~= 'Enhanced' then card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({guaranteed = true, key = 'zodiac_cancer'})]) end
                    card:juice_up()
                    return true
                end}))
        end
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}

SMODS.Consumable({
    key = 'zod_leo',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=0, y=1},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_leo'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'leo',
    pos = {x=0, y=1},
    colour = HEX('8fb85c'),
    config = {extra = {temp_level = 4, hand_type = 'Flush Five'}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands')}}
    end,
    pre_trigger = function(self, zodiac, context)
        for i=1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    copy_card(context.scoring_hand[3], G.hand.cards[i])
                    G.hand.cards[i]:juice_up()
                    context.scoring_hand[3]:juice_up()
                    return true
                    end
            }))
        end        
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}

SMODS.Consumable({
    key = 'zod_virgo',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=1, y=1},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_virgo'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'virgo',
    pos = {x=1, y=1},
    colour = HEX('299847'),
    config = {extra = {temp_level = 4, hand_type = 'Five of a Kind'}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands')}}
    end,
    pre_trigger = function(self, zodiac, context)
        G.E_MANAGER:add_event(Event({
            func = function()
                local cards = {}
                for i=1, #context.scoring_hand do
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(context.scoring_hand[i], nil, nil, G.playing_card)
                    table.insert(cards, _card)
                end
                for i, _card in ipairs(cards) do
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)
                    context.scoring_hand[i]:juice_up()
                    _card:juice_up()
                end
                playing_card_joker_effects(cards)
                G.deck:shuffle('zodiac_virgo')
                return true
            end
        }))
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}

SMODS.Consumable({
    key = 'zod_libra',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=2, y=1},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_libra'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'libra',
    pos = {x=2, y=1},
    colour = HEX('32a18c'),
    config = {extra = {temp_level = 4, hand_type = 'Full House', convert = 2}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands'), zodiac.config.extra.convert}}
    end,
    pre_trigger = function(self, zodiac, context)
        G.E_MANAGER:add_event(Event({
            func = function()
                local index = {1, #context.scoring_hand}
                for i=1, math.min(zodiac.config.extra.convert, #G.hand.cards) do
                    local _card = copy_card(context.scoring_hand[index[i]], G.hand.cards[i])
                    _card:juice_up()
                    context.scoring_hand[index[i]]:juice_up()
                end
                return true
            end
        }))
        zodiac_reduce_level(zodiac)

        return context.mult, context.chips
    end
}

SMODS.Consumable({
    key = 'zod_scorpio',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=3, y=1},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_scorpio'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'scorpio',
    pos = {x=0, y=0},
    colour = HEX('669ac0'),
    config = {extra = {temp_level = 4, hand_type = 'High Card', amount = 2}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands'), zodiac.config.extra.amount}}
    end,
    pre_trigger = function(self, zodiac, context)
        local amount = 1
        local modifiers = {'m_stone', 'm_ortalab_ore'}
        for _, card in pairs(context.full_hand) do
            if table.contains(context.scoring_hand, card) or amount == zodiac.config.extra.amount + 1 then
                -- do nothing
            else
                card.add_to_scoring = true
                local change = modifiers[amount]
                card:set_ability(G.P_CENTERS[change], nil, true)
                local name = card.ability.effect
                card.ability.effect = nil
                card.becoming_no_rank = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'before', delay = 0.2, func = function()
                        zodiac:juice_up()
                        card.config.center.replace_base_card = true
                        card.becoming_no_rank = nil
                        card.ability.effect = name
                        card:juice_up()
                        return true
                    end}))
                card.config.center.replace_base_card = false
                amount = amount + 1
            end
        end
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips, true
    end
}

-- Hook to allow cards that become no rank to score properly
local chip_bonus = Card.get_chip_bonus
function Card:get_chip_bonus()
    if self.becoming_no_rank then return self.ability.bonus + (self.ability.perma_bonus or 0) end
    return chip_bonus(self)
end

SMODS.Consumable({
    key = 'zod_sag',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=0, y=2},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_sag'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'sag',
    pos = {x=3, y=1},
    colour = HEX('4c3ba2'),
    config = {extra = {temp_level = 4, hand_type = 'Flush'}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands')}}
    end,
    pre_trigger = function(self, zodiac, context)
        local suits_in_flush = {}
        local new_suit = context.scoring_hand[1].base.suit
        for _, card in pairs(context.scoring_hand) do
            suits_in_flush[card.base.suit] = suits_in_flush[card.base.suit] and suits_in_flush[card.base.suit] + 1 or 1
            if suits_in_flush[card.base.suit] > suits_in_flush[new_suit] then new_suit = card.base.suit end
        end
        for _, card in pairs(G.hand.cards) do
            if not card.base.suit ~= new_suit then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before', delay = 0.2, func = function()
                        zodiac:juice_up()
                        SMODS.change_base(card, new_suit)
                        card:juice_up()
                        return true
                    end}))
            end
        end
        zodiac_reduce_level(zodiac)
        
        return context.mult, context.chips
    end
}

SMODS.Consumable({
    key = 'zod_capr',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=1, y=2},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_capr'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'capr',
    pos = {x=4, y=1},
    colour = HEX('8058b6'),
    config = {extra = {temp_level = 4, hand_type = 'Straight', amount = 2}},
    loc_vars = function(self, info_queue, card)
        if not card then info_queue[#info_queue + 1] = G.P_CENTERS['m_ortalab_index'] end
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands'), zodiac.config.extra.amount}}
    end,
    pre_trigger = function(self, zodiac, context)
        for i=1, zodiac.config.extra.amount do
            if G.hand.cards[i] then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before', delay = 0.2, func = function()
                        zodiac:juice_up()
                        G.hand.cards[i]:set_ability(G.P_CENTERS['m_ortalab_index'])
                        G.hand.cards[i]:juice_up()
                        return true
                    end}))
            end
        end
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}

SMODS.Consumable({
    key = 'zod_aquarius',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=2, y=2},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_aquarius'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'aquarius',
    pos = {x=1, y=0},
    config = {extra = {temp_level = 4, hand_type = 'Two Pair'}},
    colour = HEX('b05ab4'),
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands')}}
    end,
    pre_trigger = function(self, zodiac, context)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(context.scoring_hand[1], nil, nil, G.playing_card)
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card2 = copy_card(context.scoring_hand[#context.scoring_hand], nil, nil, G.playing_card)
                _card:add_to_deck()
                _card2:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 2
                table.insert(G.playing_cards, _card)
                table.insert(G.playing_cards, _card2)
                G.deck:emplace(_card)
                G.deck:emplace(_card2)
                G.deck:shuffle('zodiac_aquarius')
                context.scoring_hand[1]:juice_up()
                context.scoring_hand[#context.scoring_hand]:juice_up()
                _card:juice_up()

                playing_card_joker_effects({_card, _card2})
                return true
            end
        }))
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}

SMODS.Consumable({
    key = 'zod_pisces',
    set = 'Zodiac',
    atlas = 'zodiac_cards',
    pos = {x=3, y=2},
    discovered = false,
    config = {extra = {zodiac = 'zodiac_ortalab_pisces'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'parchment'} end
        info_queue[#info_queue + 1] = {generate_ui = zodiac_tooltip, key = self.config.extra.zodiac}
        return {vars = {localize(G.ZODIACS[self.config.extra.zodiac].config.extra.hand_type, 'poker_hands')}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end
})

Ortalab.Zodiac{
    key = 'pisces',
    pos = {x=5, y=1},
    colour = HEX('ae347f'),
    config = {extra = {temp_level = 4, hand_type = 'Straight Flush'}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_temp_level_mod or 1) * zodiac.config.extra.temp_level + (not zodiac.voucher_check and G.GAME.Ortalab_zodiac_voucher or 0)
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands')}}
    end,
    pre_trigger = function(self, zodiac, context)
        local suits_in_flush = {}
        local new_suit = context.scoring_hand[1].base.suit
        for _, card in pairs(context.scoring_hand) do
            suits_in_flush[card.base.suit] = suits_in_flush[card.base.suit] and suits_in_flush[card.base.suit] + 1 or 1
            if suits_in_flush[card.base.suit] > suits_in_flush[new_suit] then new_suit = card.base.suit end
        end
        for _, card in pairs(G.hand.cards) do
            if not card.base.suit ~= new_suit then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before', delay = 0.2, func = function()
                        zodiac:juice_up()
                        SMODS.change_base(card, new_suit)
                        if not card.edition then
                            local new_edition = poll_edition('zodiac_pisces', nil, false, true)
                            card:set_edition(new_edition, true, true)
                        end
                        card:juice_up()
                        return true
                    end}))
            end
        end
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}

function zodiac_reduce_level(zodiac)
    local zodiac_joker = SMODS.find_card('j_ortalab_prediction_dice')
    for _, joker_card in pairs(zodiac_joker) do        
        if pseudorandom(pseudoseed('loteria_check_keep')) > (joker_card.ability.extra.num*G.GAME.probabilities.normal) / joker_card.ability.extra.chance then
            -- joker_card:juice_up()
            card_eval_status_text(joker_card, 'extra', nil, nil, nil, {message = localize('ortalab_zodiac_no_decay')})
            return
        end
    end
    zodiac.config.extra.temp_level = math.max(0, zodiac.config.extra.temp_level - G.GAME.Ortalab_Zodiac_Reduction)
    if zodiac.config.extra.temp_level == 0 then
        zodiac.triggered = true
    end
end

function use_zodiac(card)
    track_usage(card.config.center.set, card.config.center_key)
    if G.zodiacs and G.zodiacs[card.ability.extra.zodiac] then
        G.zodiacs[card.ability.extra.zodiac].config.extra.temp_level = G.zodiacs[card.ability.extra.zodiac].config.extra.temp_level + (G.ZODIACS[card.ability.extra.zodiac].config.extra.temp_level * G.GAME.Ortalab_zodiac_temp_level_mod) + G.GAME.Ortalab_zodiac_voucher
        zodiac_text(zodiac_upgrade_text(card.ability.extra.zodiac), card.ability.extra.zodiac)
        G.zodiacs[card.ability.extra.zodiac]:juice_up(1, 1)
        delay(0.7)
    else
        add_zodiac(Zodiac(card.ability.extra.zodiac))
    end
end

function zodiac_upgrade_text(key)
    local zodiac_name = localize({set = 'Tag', key = key, type = 'name_text'})
    return zodiac_name .. localize('ortalab_zodiac_upgraded')
end

function zodiac_text(message, key)
    if Ortalab.config.zodiac_skip then return end
    local old_colours = {
        special_colour = copy_table(G.C.BACKGROUND.C),
        tertiary_colour = copy_table(G.C.BACKGROUND.D),
        new_colour = copy_table(G.C.BACKGROUND.L),
    }
    ease_background_colour{special_colour = darken(G.ARGS.LOC_COLOURS['Zodiac'], 0.5), new_colour = G.ZODIACS[key].colour, tertiary_colour = G.ARGS.LOC_COLOURS.Zodiac, contrast = 1}
    -- Adds the constellation sprite in the background
    local zodiac_sprite = Sprite(0, 0, 150, 150, G.ASSET_ATLAS['ortalab_zodiac_constellations'], G.ZODIACS[key].pos)
    local zodiac_UI = UIBox{
        definition = {n=G.UIT.ROOT, config = {align='cm', colour = G.C.CLEAR, minw = 6, minh = 6}, nodes = {
            {n=G.UIT.R, nodes = {
                {n=G.UIT.O, config = {object = zodiac_sprite, w = 6, h = 6}}
            }}
        }},
        config = {instance_type = 'CARDAREA', major = G.play, align = 'cm', offset = {x=0, y=-2.7}}
    }
    table.insert(G.I.MOVEABLE, zodiac_UI)

    attention_text({scale = 1, text = message, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play})
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1.5,
        func = function()
            ease_background_colour({special_colour = old_colours.special_colour, tertiary_colour = old_colours.tertiary_colour, new_colour = old_colours.new_colour})
            zodiac_sprite:remove()
            zodiac_UI:remove()
            return true
    end}))
end

local align_ref = CardArea.align_cards
function CardArea:align_cards()
    if self.config.type == 'joker' and not self.cards then self.cards = {} end
    if not self.children then self.children = {} end
    align_ref(self)
end