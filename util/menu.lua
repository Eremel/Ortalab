SMODS.current_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 4, align = "tm", colour = G.C.BLACK}, nodes = {
        {n=G.UIT.R, config = {align = 'cm'}, nodes={
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                EremelUtility.create_toggle({label = localize('ortalab_config_artists'), ref_table = Ortalab.config, ref_value = 'artist_credits', info = localize('ortalab_config_artists_desc'), active_colour = Ortalab.badge_colour, left = true, callback = artist_toggle}),
            }},
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                EremelUtility.create_toggle({label = localize('ortalab_config_full'), ref_table = Ortalab.config, ref_value = 'full_credits', info = localize('ortalab_config_full_desc'), active_colour = Ortalab.badge_colour, left = true, callback = full_toggle}),
            }}
        }},
        {n=G.UIT.R, config = {minh = 0.04, minw = 4, colour = G.C.L_BLACK}},
        {n=G.UIT.R, config = {align = 'cm', padding = 0.2}, nodes = {
            {n=G.UIT.T, config = {scale = 0.5, text = "Skip Animations", colour = G.C.WHITE}}
        }},
        {n=G.UIT.R, config = {align = 'cm'}, nodes={
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                EremelUtility.create_toggle({label = localize('ortalab_config_loteria_skip'), ref_table = Ortalab.config, ref_value = 'loteria_skip', info = localize('ortalab_config_loteria_skip_desc'), active_colour = Ortalab.badge_colour, left = true}),
            }},
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                EremelUtility.create_toggle({label = localize('ortalab_config_enhancement_skip'), ref_table = Ortalab.config, ref_value = 'enhancement_skip', info = localize('ortalab_config_enhancement_skip_desc'), active_colour = Ortalab.badge_colour, left = true}),
            }},
            {n=G.UIT.C, config = {padding = 0.2, align = 'cm'}, nodes = {
                EremelUtility.create_toggle({label = localize('ortalab_config_zodiac_skip'), ref_table = Ortalab.config, ref_value = 'zodiac_skip', info = localize('ortalab_config_zodiac_skip_desc'), active_colour = Ortalab.badge_colour, left = true}),
            }}
        }},
        {n=G.UIT.R, config = {minh = 0.04, minw = 4, colour = G.C.L_BLACK}},
        {n=G.UIT.R, config = {align = 'cm'}, nodes = {
            {n=G.UIT.C, config={padding=0.2, align = 'cm'}, nodes={
                EremelUtility.create_toggle({label = localize('ortalab_config_placeholder'), ref_table = Ortalab.config, ref_value = 'placeholders', info = localize('ortalab_config_placeholder_desc'), active_colour = Ortalab.badge_colour, left = true, callback = purge_collection}),
            }},
    
        }},
        {n=G.UIT.R, config = {minh = 0.04, minw = 4, colour = G.C.L_BLACK}},
        {n=G.UIT.R, config = {align = 'cm'}, nodes = {
            {n=G.UIT.C, config={padding=0.2, align = 'cm'}, nodes={
                EremelUtility.create_toggle({active_colour = G.ARGS.LOC_COLOURS.Zodiac,
                        left = true, label = localize('ortalab_toggle_intro'), ref_table = Ortalab.config, ref_value = 'initial_setup_demo_3'}),
            }},
    
        }}
    }}
end

function artist_toggle()
    if not Ortalab.config.artist_credits and Ortalab.config.full_credits then
        Ortalab.config.full_credits = false
    end
end

function full_toggle()
    if Ortalab.config.full_credits and not Ortalab.config.artist_credits then
        Ortalab.config.artist_credits = true
    end
end

local main_menu = Game.main_menu
function Game:main_menu(context)
    main_menu(self, context)
    if context == 'splash' then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
            if not Ortalab.config.initial_setup_demo_3 then
                G.FUNCS.overlay_menu({
                    definition = create_initial_config()
                })
                
            end
            return true
        end}))
    end
    
end

Ortalab.zodiac_area = nil
function create_initial_config()
    Ortalab.zodiac_area = CardArea(0, 0, 2.1*G.CARD_W ,1.2*G.CARD_H, {card_limit = 3, type = 'title', collection = true})
    Ortalab.joker_area = CardArea(0,0, 1.7*G.CARD_W, 1.2*G.CARD_H, {card_limit=2, type='title', collection=true})
    Ortalab.blind_area = CardArea(0,0, 2*G.CARD_W, 0.7*G.CARD_H, {card_limit=3, type ='title', collection=true})

    local zodiac_keys = {'c_ortalab_zod_gemini','c_ortalab_zod_scorpio','c_ortalab_zod_pisces'}
    for i=1, 3 do
        local card = Card(0, 0, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[zodiac_keys[i]], {bypass_discovery_center = true, bypass_discovery_ui = true, bypass_lock = true})
        card.discovered = true
        Ortalab.zodiac_area:emplace(card)
    end

    local joker_keys = {'j_ortalab_knitted_sweater','j_ortalab_caffeyne'}
    for i=1,2 do
        local card = Card(0,0, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[joker_keys[i]], {bypass_discovery_center = true, bypass_discovery_ui = true, bypass_lock = true})
        card.discovered = true
        Ortalab.joker_area:emplace(card)
    end

    local blind_keys = {'bl_ortalab_check','bl_ortalab_ladder','bl_ortalab_celadon_clubs'}
    for i=1,3 do
        local temp_blind = AnimatedSprite(0, 0, 1.3, 1.3, G.ANIMATION_ATLAS[G.P_BLINDS[blind_keys[i]].atlas],
        G.P_BLINDS[blind_keys[i]].pos)
		temp_blind.states.click.can = false
		temp_blind.states.drag.can = false
		temp_blind.states.hover.can = true
		local card = Card(0,0, 1.3, 1.3, G.P_CARDS.empty, G.P_CENTERS.c_base)
		temp_blind.states.click.can = false
		card.states.drag.can = false
		card.states.hover.can = true
		card.children.center = temp_blind
		temp_blind:set_role({major = card, role_type = 'Glued', draw_major = card})
		card.set_sprites = function(...)
			local args = {...}
			if not args[1].animation then return end -- fix for debug unlock
			local c = card.children.center
			Card.set_sprites(...)
			card.children.center = c
		end
		temp_blind:define_draw_steps({
			{ shader = 'dissolve', shadow_height = 0.05 },
			{ shader = 'dissolve' }
		})
		temp_blind.float = true
		card.states.collide.can = true
		card.config.blind = G.P_BLINDS[blind_keys[i]]
		card.config.force_focus = true
		card.hover = function()
			if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
				if not card.hovering and card.states.visible then
					card.hovering = true
					card.hover_tilt = 3
					card:juice_up(0.05, 0.02)
					play_sound('chips1', math.random() * 0.1 + 0.55, 0.12)
					card.config.h_popup = create_UIBox_blind_popup(G.P_BLINDS[blind_keys[i]], true)
					card.config.h_popup_config = card:align_h_popup()
					Node.hover(card)
				end
			end
			card.stop_hover = function()
				card.hovering = false; Node.stop_hover(card); card.hover_tilt = 0
			end
		end
		Ortalab.blind_area:emplace(card)
    end
    

    local t = create_UIBox_generic_options({ back_func = 'close_initial_config', colour=G.C.BLACK, no_back=true, outline_colour=G.ARGS.LOC_COLOURS.Ortalab, back_label = localize('ortalab_back'), contents = {
        {n = G.UIT.C, config = {r = 0.1, minw = 4, align = "tm", padding = 0.2, colour = G.ARGS.LOC_COLOURS.Ortalab}, nodes = {
            {n=G.UIT.R, config = {align = 'cm', minw = 10, padding = 0.2, r=0.1, colour = G.C.BLACK}, nodes = {
                {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'Welcome to Ortalab Demo 3', colour = G.ARGS.LOC_COLOURS.Ortalab, shadow = true, scale = 0.65}}}}
            }},
            -- {n=G.UIT.R, config = {align='cm',minw=10,padding=0.2,r=0.1,colour=G.C.BLACK}, nodes = {
            --     {n=G.UIT.R, config={align='cm', colour = G.C.WHITE, minw=9}},
            --     {n=G.UIT.R, config={align='cm'}, nodes = {
            --         {n=G.UIT.T, config={text = 'The main features of this demo are a new consumable type, ',colour = G.C.WHITE, scale = 0.35}},
            --         {n=G.UIT.T, config={text = 'Zodiac cards, ',colour = G.ARGS.LOC_COLOURS.zodiac, scale = 0.35}},
            --         {n=G.UIT.T, config={text = 'a new set of blinds, ',colour = G.C.WHITE, scale = 0.35}}
            --     }},
            --     {n=G.UIT.R, config={align='cm'}, nodes = {
            --         {n=G.UIT.T, config={text = 'including new Small and Big Blinds, 4 new Decks, and a range of new Jokers.',colour = G.C.WHITE, scale = 0.35}}
            --     }},
            -- }},
            {n=G.UIT.R, config = {align = 'cm',padding=0.2}, nodes = {
                {n=G.UIT.C, config={align='tm',padding = 0.2, minw=4, minh=5, r=0.1, colour = G.C.BLACK}, nodes = {
                   {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'Zodiac Cards', shadow = true, colour = G.ARGS.LOC_COLOURS.Zodiac, scale = 0.45}}}},
                   {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.O, config={object= Ortalab.zodiac_area}}}},
                   {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'Zodiac cards apply a bonus the', colour = G.C.WHITE, scale = 0.35}}}},
                   {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'next time you play their poker hand.', colour = G.C.WHITE, scale = 0.35}}}},
                   {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'Each time they activate, they reduce', colour = G.C.WHITE, scale = 0.35}}}},
                   {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'in power until they are gone.', colour = G.C.WHITE, scale = 0.35}}}},
                }},
                {n=G.UIT.C, config={align='tm',padding = 0.2, minw=4, minh=5, r=0.1, colour = G.C.BLACK}, nodes = {
                    {n=G.UIT.R, config={align='cm'}, nodes ={{n=G.UIT.T, config={text = 'New Jokers', shadow = true, colour = G.ARGS.LOC_COLOURS.Zodiac, scale = 0.45}}}},
                    {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.O, config={object= Ortalab.joker_area}}}},
                    {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'Play with over 30', colour = G.C.WHITE, scale = 0.35}}}},
                    {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'new jokers and', colour = G.C.WHITE, scale = 0.35}}}},
                    {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'find new combos!', colour = G.C.WHITE, scale = 0.35}}}},
                }},
                {n=G.UIT.C, config = {align='tm', padding = 0.2, colour=G.C.CLEAR}, nodes ={
                    {n=G.UIT.R, nodes ={
                        {n=G.UIT.C, config={align='tm',padding = 0.2, minw=4, minh=4, r=0.1, colour = G.C.BLACK}, nodes = {
                            {n=G.UIT.R, config={align='cm'}, nodes ={{n=G.UIT.T, config={text = 'New Blinds', shadow = true, colour = G.ARGS.LOC_COLOURS.Zodiac, scale = 0.45}}}},
                            {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.O, config={object= Ortalab.blind_area}}}},
                            {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'A full suite of blinds, including', colour = G.C.WHITE, scale = 0.35}}}},
                            {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = '5 showdowns and 6 alternative', colour = G.C.WHITE, scale = 0.35}}}},
                            {n=G.UIT.R, config={align='cm'}, nodes = {{n=G.UIT.T, config={text = 'small and big blinds!', colour = G.C.WHITE, scale = 0.35}}}},
                        }},
                    }},
                    {n=G.UIT.R, config={align='cm', minh=1 }, nodes={
                        {n=G.UIT.C, config={align='cm',padding=0.2,minw=4,minh=1,r=0.1,colour=G.C.BLACK, button='close_initial_config', button_delay = 2, hover=true, emboss=0.1}, nodes ={{n=G.UIT.T, config={text = localize('ortalab_back'), colour = G.ARGS.LOC_COLOURS.Zodiac, scale = 0.45}}}},
                    }},
                    EremelUtility.create_toggle({active_colour = G.ARGS.LOC_COLOURS.Zodiac, outline = G.C.BLACK, label_colour = G.C.BLACK, label_bg = G.C.UI.TRANSPARENT_DARK, label_scale = 0.35,
                    inactive_colour = G.ARGS.LOC_COLOURS.Ort_menu_colourB, left = true, label = localize('ortalab_hide_intro'), ref_table = Ortalab.config, ref_value = 'initial_setup_demo_3'}),
                }}}
            }},
        }
    }})

    return t

end

EremelUtility = EremelUtility or {}

function EremelUtility.create_toggle(args)
    args = args or {}
    args.active_colour = args.active_colour or Malverk.badge_colour
    args.inactive_colour = args.inactive_colour or G.C.BLACK
    args.w = args.w or 3
    args.h = args.h or 0.5
    args.scale = args.scale or 1
    args.label = args.label or 'TEST?'
    args.label_scale = args.label_scale or 0.4
    args.ref_table = args.ref_table or {}
    args.ref_value = args.ref_value or 'test'
    args.left = args.left or false
    args.right = not args.left
    args.info_above = args.info_above or false

    local error = {n=G.UIT.C, config = {r=0.1, colour = G.C.RED, align = 'cm', padding = 0.1}, nodes = {}}

    if args.left and args.right then
        error.nodes[#error.nodes + 1] = {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = 'Left and Right selected', scale = args.scale, colour = G.C.BLACK, shadow = true}}}}
    end

    if #error.nodes > 0 then return error end

    local check = Sprite(0,0,0.5*args.scale,0.5*args.scale,G.ASSET_ATLAS["icons"], {x=1, y=0})
    check.states.drag.can = false
    check.states.visible = false

    local info = nil
    if args.info then 
        info = {}
        for k, v in ipairs(args.info) do 
            table.insert(info, {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={
            {n=G.UIT.T, config={text = v, scale = 0.25, colour = G.C.UI.TEXT_LIGHT}}
            }})
        end
        info =  {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes=info}
    end

    local toggle = {n=G.UIT.C, config = {align = 'cm', minw = 0.3*args.w}, nodes = {
        {n=G.UIT.C, config = {align = 'cm', r=0.1, colour = G.C.BLACK}, nodes={
            {n=G.UIT.C, config={align = "cm", r = 0.1, padding = 0.03, minw = 0.4*args.scale, minh = 0.4*args.scale, outline_colour = args.outline or G.C.WHITE, outline = 1.2*args.scale, line_emboss = 0.5*args.scale, ref_table = args,
                colour = args.inactive_colour,
                button = 'toggle_button', button_dist = 0.2, hover = true, toggle_callback = args.callback, func = 'toggle', focus_args = {funnel_to = true}}, nodes={
                {n=G.UIT.O, config={object = check}},
            }}
        }}
    }}

    local label = {n=G.UIT.C, config={align = args.left and 'cr' or 'cl', colour = args.label_bg or G.C.CLEAR, r = 0.1,},  nodes={
        {n=G.UIT.B, config={w = 0.1, h = 0.1}},
        {n=G.UIT.T, config={text = args.label, scale = args.label_scale, colour = args.label_colour or G.C.UI.TEXT_LIGHT}},
        {n=G.UIT.B, config={w = 0.1, h = 0.1}},
    }}

    local t = 
        {n=args.col and G.UIT.C or G.UIT.R, config={align = args.left and 'cr' or 'cl', padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = {funnel_from = true}}, nodes={
            args.left and label or nil,
            toggle,
            args.right and label or nil
        }}

    if args.info then 
        t = {n=args.col and G.UIT.C or G.UIT.R, config={align = "cm"}, nodes={
        args.info_above and info or nil,
        t,
        args.info_above and nil or info,
        }}
    end
    return t
end

G.FUNCS.close_initial_config = function()
    -- Ortalab.config.initial_setup_demo_3 = false
    Ortalab.zodiac_area:remove()
    Ortalab.joker_area:remove()
    Ortalab.blind_area:remove()
    SMODS.save_mod_config(Ortalab)
    G.FUNCS:exit_overlay_menu()
    -- G:main_menu()
end
