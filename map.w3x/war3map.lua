gg_trg_Standard_Script_Initialization = nil
function InitGlobals()
end

--CUSTOM_CODE
do
    Ability = { }

    function Ability.initialize()
        local trig = CreateTrigger()

        for _, value in pairs(Ability) do
            if type(value) == 'table' then
                if value.onInit and type(value.onInit) == 'function' then
                    value:onInit()
                end
            end
        end

        TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_HERO_SKILL)
        TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_CAST)
        TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_EFFECT)
        TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
        TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
        TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_FINISH)

        TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_DAMAGING)
        TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_DAMAGED)

        TriggerAddAction(trig, function()
            local id = GetTriggerEventId()

            if id == EVENT_PLAYER_HERO_SKILL then
                for _, value in pairs(Ability) do
                    if type(value) == 'table' then
                        if value.id and value.id == GetLearnedSkill() then
                            if value.onLearn and type(value.onLearn) == 'function' then
                                value:onLearn()
                            end
                        end
                    end
                end

            elseif id == EVENT_PLAYER_UNIT_SPELL_CAST then
                for _, value in pairs(Ability) do
                    if type(value) == 'table' then
                        if value.id and value.id == GetSpellAbilityId() then
                            if value.onCast and type(value.onCast) == 'function' then
                                value:onCast()
                            end
                        end
                    end
                end

            elseif id == EVENT_PLAYER_UNIT_SPELL_EFFECT then
                for _, value in pairs(Ability) do
                    if type(value) == 'table' then
                        if value.id and value.id == GetSpellAbilityId() then
                            if value.onEffect and type(value.onEffect) == 'function' then
                                value:onEffect()
                            end
                        end
                    end
                end

            elseif id == EVENT_PLAYER_UNIT_SPELL_ENDCAST then
                for _, value in pairs(Ability) do
                    if type(value) == 'table' then
                        if value.id and value.id == GetSpellAbilityId() then
                            if value.onEndcast and type(value.onEndcast) == 'function' then
                                value:onEndcast()
                            end
                        end
                    end
                end

            elseif id == EVENT_PLAYER_UNIT_SPELL_CHANNEL then
                for _, value in pairs(Ability) do
                    if type(value) == 'table' then
                        if value.id and value.id == GetSpellAbilityId() then
                            if value.onChannel and type(value.onChannel) == 'function' then
                                value:onChannel()
                            end
                        end
                    end
                end

            elseif id == EVENT_PLAYER_UNIT_SPELL_FINISH then
                for _, value in pairs(Ability) do
                    if type(value) == 'table' then
                        if value.id and value.id == GetSpellAbilityId() then
                            if value.onFinish and type(value.onFinish) == 'function' then
                                value:onFinish()
                            end
                        end
                    end
                end

            elseif id == EVENT_PLAYER_UNIT_DAMAGING then
                for _, value in pairs(Ability) do
                    if type(value) == 'table' then
                        if value.onDamaging and type(value.onDamaging) == 'function' then
                            value:onDamaging()
                        end
                    end
                end

            elseif id == EVENT_PLAYER_UNIT_DAMAGED then
                for _, value in pairs(Ability) do
                    if type(value) == 'table' then
                        if value.onDamaged and type(value.onDamaged) == 'function' then
                            value:onDamaged()
                        end
                    end
                end
            end
        end)

        if DEBUG_MODE then
            print('DEBUG_MODE: the Ability library has been initialized.')
        end
    end

end

S2FourCC = function(value)
    return string.unpack(">I4", id)
end

FourCC2S = function(value)
    return string.pack(">I4", id)
end

do
    local worldRect = nil
    local worldRegion = nil

    function GetWorldRect()
        if worldRect == nil then
            worldRect = GetWorldBounds()
        end
        return worldRect
    end

    function GetWorldRegion()
        if worldRegion == nil then
            worldRegion = CreateRegion()
            RegionAddRect(worldRegion, GetWorldRect())
        end
        return worldRegion
    end
end



do
    local tempGroup = CreateGroup()

    function RestoreDestructable(whichDestructable)
        local curLife = GetWidgetLife(whichDestructable)
        local maxLife = GetDestructableMaxLife(whichDestructable)

        if curLife <= 0.0 then
            GroupClear(tempGroup)
            GroupEnumUnitsInRange(tempGroup, GetDestructableX(whichDestructable), GetDestructableY(whichDestructable), 256.0, nil)
            if BlzGroupGetSize(tempGroup) == 0 then
                DestructableRestoreLife(whichDestructable, maxLife, false)
            end
        elseif curLife < maxLife and curLife > 0.0 then
            DestructableRestoreLife(whichDestructable, maxLife, false)
        end
    end

    function RestoreAllDestructables()
        EnumDestructablesInRect(GetWorldRect(), nil, function()
            RestoreDestructable(GetEnumDestructable())
        end)
    end
end

function UnitRestoreLife(source, target, amount)
    local curLife = GetUnitState(target, UNIT_STATE_LIFE)
    local newLife = curLife + amount

    SetUnitState(target, UNIT_STATE_LIFE, newLife)
end

function UnitRestoreMana(source, target, amount)
    local curMana = GetUnitState(target, UNIT_STATE_MANA)
    local newMana = curMana + amount

    SetUnitState(target, UNIT_STATE_MANA, newMana)
end

Debug = {

    logMsg = function(str)
        if DEBUG_MODE then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0.0, 0.0, 60.0, "[|cFFFFFFFFLOG MSG|r] :  " .. str)
        end
    end,

    warnMsg = function(str)
        if DEBUG_MODE then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0.0, 0.0, 60.0, "[|cFFFF851BWARNING MSG|r] :  " .. str)
        end
    end,

    errorMsg = function(str)
        if DEBUG_MODE then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0.0, 0.0, 60.0, "[|cFFFF4136ERROR MSG|r] :  " .. str)
        end
    end

}
TimerStart(CreateTimer(),0,false,function()
    Debug.logMsg("asd gar asdf asdf ")
    Debug.warnMsg("asd gar asdf asdf ")
    Debug.errorMsg("asd gar asdf asdf ")
end)
DummyUnit = {
    id = FourCC("h000"),

    ---@param owner player
    ---@param x real
    ---@param y real
    ---@param z real
    ---@param face real
    ---@return unit
    create = function(owner, x, y, z, face)
        if z == nil or z == 0.0 then
            return CreateUnit(owner, DummyUnit.id, x, y, face)

        else
            local u = CreateUnit(owner, DummyUnit.id, x, y, face)

            SetUnitFlyHeight(u, z, 0.0)

            return u
        end
    end

}

FloatingTextTag = {

    ---@type function
    ---@param forPlayer player
    ---@param whichUnit unit
    ---@param value string
    ---@return nothing
    gold = function(forPlayer, whichUnit, value)
        if GetLocalPlayer() == forPlayer then
            local tt = CreateTextTag()

            SetTextTagText(tt, value, 0.023)
            SetTextTagPosUnit(tt, whichUnit, 0.0)
            SetTextTagColor(tt, 255, 220, 0, 255)
            SetTextTagVisibility(tt, true)
            SetTextTagPermanent(tt, false)
            SetTextTagVelocity(tt, 0.0, 0.029)
            SetTextTagLifespan(tt, 2.0)
            SetTextTagFadepoint(tt, 1.0)
        end
    end,

    ---@type function
    ---@param forPlayer player
    ---@param whichUnit unit
    ---@param value string
    ---@return nothing
    lumber = function(forPlayer, whichUnit, value)
        if GetLocalPlayer() == forPlayer then
            local tt = CreateTextTag()

            SetTextTagText(tt, value, 0.023)
            SetTextTagPosUnit(tt, whichUnit, 0.0)
            SetTextTagColor(tt, 0, 200, 80, 255)
            SetTextTagVisibility(tt, true)
            SetTextTagPermanent(tt, false)
            SetTextTagVelocity(tt, 0.0, 0.029)
            SetTextTagLifespan(tt, 2.0)
            SetTextTagFadepoint(tt, 1.0)
        end
    end,

    ---@type function
    ---@param whichUnit unit
    ---@param value string
    ---@return nothing
    miss = function(whichUnit, value)
        local tt = CreateTextTag()

        SetTextTagText(tt, value, 0.023)
        SetTextTagPosUnit(tt, whichUnit, 0.0)
        SetTextTagColor(tt, 255, 0, 0, 255)
        SetTextTagVisibility(tt, true)
        SetTextTagPermanent(tt, false)
        SetTextTagVelocity(tt, 0.0, 0.03993)
        SetTextTagLifespan(tt, 3.0)
        SetTextTagFadepoint(tt, 1.0)
    end,

    ---@type function
    ---@param whichUnit unit
    ---@param value string
    ---@return nothing
    criticalstrike = function(whichUnit, value)
        local tt = CreateTextTag()

        SetTextTagText(tt, value, 0.023)
        SetTextTagPosUnit(tt, whichUnit, 0.0)
        SetTextTagColor(tt, 255, 0, 0, 255)
        SetTextTagVisibility(tt, true)
        SetTextTagPermanent(tt, false)
        SetTextTagVelocity(tt, 0.0, 0.03993)
        SetTextTagLifespan(tt, 5.0)
        SetTextTagFadepoint(tt, 2.0)
    end,

    ---@type function
    ---@param whichUnit unit
    ---@param value string
    ---@return nothing
    shadowstrike = function(whichUnit, value)
        local tt = CreateTextTag()

        SetTextTagText(tt, value, 0.023)
        SetTextTagPosUnit(tt, whichUnit, 0.0)
        SetTextTagColor(tt, 158, 255, 0, 255)
        SetTextTagVisibility(tt, true)
        SetTextTagPermanent(tt, false)
        SetTextTagVelocity(tt, 0.0, 0.03993)
        SetTextTagLifespan(tt, 5.0)
        SetTextTagFadepoint(tt, 2.0)
    end,

    ---@type function
    ---@param whichUnit unit
    ---@param value string
    ---@return nothing
    manaburn = function(whichUnit, value)
        local tt = CreateTextTag()

        SetTextTagText(tt, value, 0.023)
        SetTextTagPosUnit(tt, whichUnit, 0.0)
        SetTextTagColor(tt, 81, 81, 255, 255)
        SetTextTagVisibility(tt, true)
        SetTextTagPermanent(tt, false)
        SetTextTagVelocity(tt, 0.0, 0.03993)
        SetTextTagLifespan(tt, 5.0)
        SetTextTagFadepoint(tt, 2.0)
    end

}


math.parabola = function(maxHeight, maxRange, currentRange)
    return (4 * maxHeight / maxRange) * (maxRange - currentRange) * (currentRange / maxRange)
end

PlayerColor = {

    getPlayerColoredString = function(index, str)
        local color = {
            [ 0] = "|cFFFF0303" .. str .. "|r",
            [ 1] = "|cFF0042FF" .. str .. "|r",
            [ 2] = "|cFF1CE6B9" .. str .. "|r",
            [ 3] = "|cFF540081" .. str .. "|r",
            [ 4] = "|cFFFFFF01" .. str .. "|r",
            [ 5] = "|cFFFE8A0E" .. str .. "|r",
            [ 6] = "|cFF20C000" .. str .. "|r",
            [ 7] = "|cFFE55BB0" .. str .. "|r",
            [ 8] = "|cFF959697" .. str .. "|r",
            [ 9] = "|cFF7EBFF1" .. str .. "|r",
            [10] = "|cFF106246" .. str .. "|r",
            [11] = "|cFF4E2A04" .. str .. "|r",
            [12] = "|cFF9B0000" .. str .. "|r",
            [13] = "|cFF0000C3" .. str .. "|r",
            [14] = "|cFF00EAFF" .. str .. "|r",
            [15] = "|cFFBE00FE" .. str .. "|r",
            [16] = "|cFFEBCD87" .. str .. "|r",
            [17] = "|cFFF8A48B" .. str .. "|r",
            [18] = "|cFFBFFF80" .. str .. "|r",
            [19] = "|cFFDCB9EB" .. str .. "|r",
            [20] = "|cFF282828" .. str .. "|r",
            [21] = "|cFFEBF0FF" .. str .. "|r",
            [22] = "|cFF00781E" .. str .. "|r",
            [23] = "|cFFA46F33" .. str .. "|r"
        }

        return color[index]
    end

}

Preload = {

    dummyUnit = nil,

    unit = function(id)
        RemoveUnit(CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), id, MAP_HIDDEN_X, MAP_HIDDEN_Y, 0.0))
    end,

    item = function(id)
        RemoveItem(CreateItem(id, MAP_HIDDEN_X, MAP_HIDDEN_Y))
    end,

    effect = function(path)
        DestroyEffect(AddSpecialEffect(path, MAP_HIDDEN_X, MAP_HIDDEN_Y))
    end,

    lightning = function(name)
        DestroyLightning(AddLightning(name, true, MAP_HIDDEN_X, MAP_HIDDEN_Y, MAP_HIDDEN_X, MAP_HIDDEN_Y))
    end,

    sound = function(path)
        local sound = CreateSound(path, false, false, false, 10, 10, "")

        SetSoundVolume(sound, 0)
        StartSound(sound)
        KillSoundWhenDone(sound)
    end,

    ability = function(id)
        if Preload.dummyUnit == nil then
            Preload.dummyUnit = DummyUnit.create(Player(PLAYER_NEUTRAL_PASSIVE), MAP_HIDDEN_X, MAP_HIDDEN_Y, MAP_HIDDEN_Z, 0.0)
        end

        return UnitAddAbility(Preload.dummyUnit, id) and UnitRemoveAbility(Preload.dummyUnit, id)
    end

}

do

    ---@type location
    local loc = Location(MAP_HIDDEN_X, MAP_HIDDEN_Y)

    ---@type function
    ---@param x real
    ---@param y real
    ---@return real
    GetTerrainZ = function(x, y)
        MoveLocation(loc, x, y)

        return GetLocationZ(loc)
    end

end

DEBUG_MODE = true

MAP_NAME = "Mok: Hero Defense"
MAP_VERSION = "1.0"
MAP_HIDDEN_X = 0.0
MAP_HIDDEN_Y = 0.0
MAP_HIDDEN_Z = 0.0

UNIT_MAX_COLLISION_SIZE = 197.0

InitGlobals = function()

    -- Map initialization:
    TOC.initialize()
    Force.initialize()

    -- Game data initialization:
    Game.initialize()
    Ai.initialize()

    -- Hero data initialization:
    HeroPick.initialize()
    HeroRevive.initialize()
    HeroExperience.initialize()
    SkillPoints.initialize()

    -- Peon data initialization:
    WatchTower.initialize()
    SentryWard.initialize()
    PeonsBurrow.initialize()
    Peon.initialize()

    -- Mokk data initialization:

    if DEBUG_MODE then
        print("DEBUG_MODE: all game data has been initialized.")
    end
end

do
    PowerUp = { }

    function PowerUp.initialize()
        local circle = { }
        local item = { }
        local trig = CreateTrigger()

        table.insert(circle, AddSpecialEffect('Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl', 4736.0, -8320.0))
        table.insert(circle, AddSpecialEffect('Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl', 7296.0, -5760.0))

        for _, value in pairs(circle) do
            CreateUnit(Player(22), FourCC('n005'), BlzGetLocalSpecialEffectX(value), BlzGetLocalSpecialEffectY(value), bj_UNIT_FACING)
        end

        table.insert(item, FourCC('manh'))
        table.insert(item, FourCC('tdx2'))
        table.insert(item, FourCC('texp'))
        table.insert(item, FourCC('tin2'))
        table.insert(item, FourCC('tpow'))
        table.insert(item, FourCC('tst2'))

        for _, value in pairs(Team.defensiveForce) do
            TriggerRegisterPlayerUnitEvent(trig, value, EVENT_PLAYER_UNIT_PICKUP_ITEM, nil)
        end

        TriggerAddAction(trig, function()
            local it = GetManipulatedItem()
            local id = GetItemTypeId(it)

            for _, value in pairs(item) do
                if id == value then
                    RemoveItem(it)
                    break
                end
            end
        end)

        TimerStart(CreateTimer(), 60.0, true, function()
            for _, value in pairs(circle) do
                local x = BlzGetLocalSpecialEffectX(value)
                local y = BlzGetLocalSpecialEffectY(value)
                local r = Rect(x - 32.0, y - 32.0, x + 32.0, y + 32.0)
                local i = 0

                EnumItemsInRect(r, nil, function()
                    for _, value in pairs(item) do
                        if GetItemTypeId(GetEnumItem()) == value then
                            i = i + 1
                        end
                    end
                end)

                if i == 0 then
                    SetItemInvulnerable(CreateItem(item[GetRandomInt(1, #item)], x, y), true)
                end

                RemoveRect(r)
            end
        end)
    end

end

TimerStart(CreateTimer(), 0.0, false, PowerUp.initialize)

do
    Scoreboard = { }

    local board = nil
    local unitsProduced = { }
    local unitsKilled = { }
    local unitsLost = { }
    local buildingsProduced = { }
    local buildingsRazed = { }
    local buildingsLost = { }
    local damageDealt = { }
    local damageReceived = { }
    local goldMined = { }
    local lumberHarvested = { }
    local techPercentage = { }
    local column = { }
    local lostToUpkeep = { }

    function Scoreboard.show(flag)
        MultiboardDisplay(board, flag)
        MultiboardMinimize(board, not flag)
    end

    function Scoreboard.setItem(row, column, iconfilename, val, width, red, green, blue, alpha)
        local mbi = MultiboardGetItem(board, row, column)

        MultiboardSetItemStyle(mbi, val ~= "", iconfilename ~= "")
        MultiboardSetItemIcon(mbi, iconfilename)
        MultiboardSetItemValue(mbi, val)
        MultiboardSetItemWidth(mbi, width)
        MultiboardSetItemValueColor(mbi, red, green, blue, alpha)
        MultiboardReleaseItem(mbi)
    end

    function Scoreboard.addPlayerColumn(p)
        column[p] = MultiboardGetColumnCount(board)
        MultiboardSetColumnCount(board, column[p] + 1)
    end

    function Scoreboard.updatePlayerInfo(p)
        local pIcon = ""
        local pName = ""
        local hIcon = ""
        local hName = ""

        --  if Player.isHero( p ) then
        pIcon = "ReplaceableTextures\\CommandButtons\\BTNHoldPosition.tga"
        pName = GetPlayerName(p)

        if hero[p] ~= nil then
            hIcon = "UI\\Widgets\\Console\\Human\\CommandButton\\human-multipleselection-heroglow123.blp"
            hName = GetUnitName(p)
        else
            hIcon = "UI\\Widgets\\Console\\Human\\CommandButton\\human-multipleselection-heroglow.blp"
            hName = "no hero"
        end

        --[[  elseif Player.isBuilder( p ) then
                  pIcon = "ReplaceableTextures\\CommandButtons\\BTNBasicStruct.blp"
                  pName = GetPlayerName( p )

                  hIcon = "ReplaceableTextures\\CommandButtons\\BTNPeon.tga"
                  hName = "Builder"
              end ]]

        Scoreboard.setItem(0, column[p], pIcon, pName, 0.103125, 0xFF, 0xCC, 0x00, 0xFF)
        Scoreboard.setItem(1, column[p], hIcon, hName, 0.103125, 0x80, 0x80, 0x80, 0xFF)
    end

    function Scoreboard.updatePlayerUnits(p)
        Scoreboard.setItem(2, column[p], "", "", 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(3, column[p], "", tostring(unitsProduced[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(4, column[p], "", tostring(unitsKilled[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(5, column[p], "", tostring(unitsLost[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(6, column[p], "", "", 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
    end

    function Scoreboard.updatePlayerBuildings(p)
        Scoreboard.setItem(7, column[p], "", "", 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(8, column[p], "", tostring(buildingsProduced[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(9, column[p], "", tostring(buildingsRazed[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(10, column[p], "", tostring(buildingsLost[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(11, column[p], "", "", 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
    end

    function Scoreboard.updatePlayerCombat(p)
        Scoreboard.setItem(12, column[p], "", "", 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(13, column[p], "", tostring(damageDealt[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(14, column[p], "", tostring(damageReceived[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(15, column[p], "", "", 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
    end

    function Scoreboard.updatePlayerResources(p)
        Scoreboard.setItem(16, column[p], "", "", 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(17, column[p], "", tostring(goldMined[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(18, column[p], "", tostring(lumberHarvested[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(19, column[p], "", tostring(techPercentage[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(20, column[p], "", tostring(lostToUpkeep[p]), 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
        Scoreboard.setItem(21, column[p], "", "", 0.103125, 0xFF, 0xFF, 0xFF, 0xFF)
    end

    function Scoreboard.initialize()
        TimerStart(CreateTimer(), 0.0, false, function()
            DestroyTimer(GetExpiredTimer())

            local unitsIcon = "ReplaceableTextures\\CommandButtons\\BTNGrunt.tga"
            local buildingsIcon = "ReplaceableTextures\\CommandButtons\\BTNOrcTower.tga"
            local combatIcon = "ReplaceableTextures\\CommandButtons\\BTNAttack.tga"
            local resourcesIcon = "ReplaceableTextures\\CommandButtons\\BTNPillage.tga"

            board = CreateMultiboard()
            MultiboardSetTitleText(board, "Статистика:")
            MultiboardSetTitleTextColor(board, 0xFF, 0xFF, 0xFF, 0xFF)
            MultiboardSetRowCount(board, 24)
            MultiboardSetColumnCount(board, 1)
            MultiboardDisplay(board, true)
            MultiboardMinimize(board, false)
            MultiboardMinimize(board, true)

            Scoreboard.setItem(0, 0, "", "", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(1, 0, "", "", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(2, 0, unitsIcon, "В О Й С К А :", 0.175, 0xFF, 0xCC, 0x00, 0xFF)
            Scoreboard.setItem(3, 0, "", "     Units Produced", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(4, 0, "", "     Units Killed", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(5, 0, "", "     Units Lost", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(6, 0, "", "", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(7, 0, buildingsIcon, "З Д А Н И Я :", 0.175, 0xFF, 0xCC, 0x00, 0xFF)
            Scoreboard.setItem(8, 0, "", "     Buildings Produced", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(9, 0, "", "     Buildings Razed", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(10, 0, "", "     Buildings Lost", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(11, 0, "", "", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(12, 0, combatIcon, "Б О Й :", 0.175, 0xFF, 0xCC, 0x00, 0xFF)
            Scoreboard.setItem(13, 0, "", "     Нанесено урона", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(14, 0, "", "     Получено урона", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(15, 0, "", "     Восстановлено здоровья", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(16, 0, "", "     Восстановлено маны", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(17, 0, "", "", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(18, 0, resourcesIcon, "Р Е С У Р С Ы :", 0.175, 0xFF, 0xCC, 0x00, 0xFF)
            Scoreboard.setItem(19, 0, "", "     Добыто золота", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(20, 0, "", "     Добыто древесины", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(21, 0, "", "     Прогресс технологий", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(22, 0, "", "     Потрачено на расходы", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)
            Scoreboard.setItem(23, 0, "", "", 0.175, 0xFF, 0xFF, 0xFF, 0xFF)

            for _, val in pairs(Team.defensiveForce) do
                unitsProduced[val] = 0
                unitsKilled[val] = 0
                unitsLost[val] = 0
                buildingsProduced[val] = 0
                buildingsRazed[val] = 0
                buildingsLost[val] = 0
                damageDealt[val] = 0
                damageReceived[val] = 0
                goldMined[val] = 0
                lumberHarvested[val] = 0
                techPercentage[val] = 0
                column[val] = 0
                lostToUpkeep[val] = 0

                Scoreboard.addPlayerColumn(val)
                Scoreboard.updatePlayerInfo(val)
                Scoreboard.updatePlayerUnits(val)
                Scoreboard.updatePlayerBuildings(val)
                Scoreboard.updatePlayerCombat(val)
                Scoreboard.updatePlayerResources(val)
            end
        end)
    end

end

Ai = {

    start = function(forPlayer)
    end,

    initialize = function()
        if DEBUG_MODE then
            print("DEBUG_MODE: the Ai library has been initialized.")
        end
    end

}

do
    Creep = {

        Wolves = {
            initialize = function()
                Creep.Wolves.round = 1
                Creep.Wolves.name = "Волки"
                Creep.Wolves.stylizedName = "В О Л К И"
                Creep.Wolves.tip = ""
                Creep.Wolves.prepare = 15.0
                Creep.Wolves.count = 36
                Creep.Wolves.limit = 60
                Creep.Wolves.spawnCamp = { SpawnCircle.getGroundCamp() }
                Creep.Wolves.startSound = nil
                Creep.Wolves.endSound = nil
                Creep.Wolves.pool = CreateUnitPool()

                UnitPoolAddUnitType(Creep.Wolves.pool, FourCC("n002"), 30.0)
                UnitPoolAddUnitType(Creep.Wolves.pool, FourCC("n003"), 20.0)
                UnitPoolAddUnitType(Creep.Wolves.pool, FourCC("n004"), 10.0)
            end
        },

        Lobstrokks = {
            initialize = function()
                Creep.Lobstrokks.round = 1
                Creep.Lobstrokks.name = "Lobstrokks"
                Creep.Lobstrokks.stylizedName = "L O B S T R O K K S"
                Creep.Lobstrokks.tip = ""
                Creep.Lobstrokks.prepare = 15.0
                Creep.Lobstrokks.count = 215
                Creep.Lobstrokks.limit = 100
                Creep.Lobstrokks.spawnCamp = { SpawnCircle.getWaterCamp() }
                Creep.Lobstrokks.startSound = nil
                Creep.Lobstrokks.endSound = nil
                Creep.Lobstrokks.pool = CreateUnitPool()

                UnitPoolAddUnitType(Creep.Lobstrokks.pool, FourCC("nlpr"), 60.0)
                UnitPoolAddUnitType(Creep.Lobstrokks.pool, FourCC("nlpd"), 50.0)
                UnitPoolAddUnitType(Creep.Lobstrokks.pool, FourCC("nltc"), 40.0)
                UnitPoolAddUnitType(Creep.Lobstrokks.pool, FourCC("nlds"), 30.0)
                UnitPoolAddUnitType(Creep.Lobstrokks.pool, FourCC("nlsn"), 20.0)
                UnitPoolAddUnitType(Creep.Lobstrokks.pool, FourCC("nlkl"), 10.0)
            end
        }

    }

    Creep.trolls = { }
    Creep.ogres = { }
    Creep.gnolls = { }
    Creep.centaurs = { }
    Creep.turtles = { }
    Creep.dragonspawn = { }
    Creep.bluedragons = { }
    Creep.blackdragons = { }
    Creep.bronzedragons = { }
    Creep.reddragons = { }
    Creep.greendragons = { }
    Creep.kamok = { }

    function Creep.trolls:initialize()
        self.round = 2
        self.name = "Тролли"
        self.stylizedName = "Т Р О Л Л И"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 250
        self.spawnCamp = { SpawnCircle.getGroundCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("nftr"), 60.0)
        UnitPoolAddUnitType(self.pool, FourCC("nftb"), 50.0)
        UnitPoolAddUnitType(self.pool, FourCC("nfsp"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("nftt"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("nftk"), 20.0)
        UnitPoolAddUnitType(self.pool, FourCC("nfsh"), 10.0)
    end

    function Creep.ogres:initialize()
        self.round = 2
        self.name = "Огры"
        self.stylizedName = "О Г Р Ы"
        self.tip = "Огры спокойно могут надавать пиздю*ей неосторожному игроку, так что будьте керифул."
        self.prepare = 15.0
        self.count = 300
        self.limit = 250
        self.spawnCamp = { SpawnCircle.getGroundCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("nogr"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("nomg"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("nogm"), 20.0)
        UnitPoolAddUnitType(self.pool, FourCC("nogl"), 10.0)
    end

    function Creep.gnolls:initialize()
        self.round = 2
        self.name = "Гноллы"
        self.stylizedName = "Г Н О Л Л Ы"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 250
        self.spawnCamp = { SpawnCircle.getGroundCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("ngna"), 60.0)
        UnitPoolAddUnitType(self.pool, FourCC("ngns"), 50.0)
        UnitPoolAddUnitType(self.pool, FourCC("ngno"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("ngnb"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("ngnw"), 20.0)
        UnitPoolAddUnitType(self.pool, FourCC("ngnv"), 10.0)
    end

    function Creep.centaurs:initialize()
        self.round = 3
        self.name = "Кентавры"
        self.stylizedName = "К Е Н Т А В Р Ы"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 250
        self.spawnCamp = { SpawnCircle.getGroundCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("ncea"), 60.0)
        UnitPoolAddUnitType(self.pool, FourCC("ncer"), 50.0)
        UnitPoolAddUnitType(self.pool, FourCC("ncim"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("ncen"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("ncks"), 20.0)
        UnitPoolAddUnitType(self.pool, FourCC("ncnk"), 10.0)
    end

    function Creep.turtles:initialize()
        self.round = 4
        self.name = "Черепахи"
        self.stylizedName = "Ч Е Р Е П А Х И"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 250
        self.spawnCamp = { SpawnCircle.getWaterCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("ntrh"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("ntrs"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("ntrt"), 20.0)
        UnitPoolAddUnitType(self.pool, FourCC("ntrg"), 20.0)
        UnitPoolAddUnitType(self.pool, FourCC("ntrd"), 20.0)
    end

    function Creep.dragonspawn:initialize()
        self.round = 13
        self.name = "Дракониды"
        self.stylizedName = "Д Р А К О Н И Д Ы"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 120
        self.spawnCamp = { SpawnCircle.getGroundCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("nbdm"), 50.0)
        UnitPoolAddUnitType(self.pool, FourCC("nbda"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("nbdw"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("nbds"), 20.0)
        UnitPoolAddUnitType(self.pool, FourCC("nbdo"), 10.0)
    end

    function Creep.reddragons:initialize()
        self.round = 14
        self.name = "Red Dragons"
        self.stylizedName = "R E D   D R A G O N S"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 120
        self.spawnCamp = { SpawnCircle.getAirCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("nrdk"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("nrdr"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("nrwm"), 20.0)
    end

    function Creep.blackdragons:initialize()
        self.round = 14
        self.name = "Black Dragons"
        self.stylizedName = "B L A C K   D R A G O N S"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 120
        self.spawnCamp = { SpawnCircle.getAirCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("nbdr"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("nbdd"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("nbwm"), 20.0)
    end

    function Creep.bronzedragons:initialize()
        self.round = 14
        self.name = "Bronze Dragons"
        self.stylizedName = "B R O N Z E   D R A G O N S"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 120
        self.spawnCamp = { SpawnCircle.getAirCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("nbzw"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("nbzk"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("nbzd"), 20.0)
    end

    function Creep.greendragons:initialize()
        self.round = 14
        self.name = "Green Dragons"
        self.stylizedName = "G R E E N   D R A G O N S"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 120
        self.spawnCamp = { SpawnCircle.getAirCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("ngrw"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("ngdk"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("ngrd"), 20.0)
    end

    function Creep.bluedragons:initialize()
        self.round = 14
        self.name = "Blue Dragons"
        self.stylizedName = "B L U E   D R A G O N S"
        self.tip = ""
        self.prepare = 15.0
        self.count = 300
        self.limit = 120
        self.spawnCamp = { SpawnCircle.getAirCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("nadw"), 40.0)
        UnitPoolAddUnitType(self.pool, FourCC("nadk"), 30.0)
        UnitPoolAddUnitType(self.pool, FourCC("nadr"), 20.0)
    end

    function Creep.kamok:initialize()
        self.round = 20
        self.name = "Ka\"mok"
        self.stylizedName = "K A \" M O K"
        self.tip = ""
        self.prepare = 45.0
        self.count = 1
        self.limit = 1
        self.spawnCamp = { SpawnCircle.getGroundCamp() }
        self.pool = CreateUnitPool()

        UnitPoolAddUnitType(self.pool, FourCC("n00D"), 100.0)
    end

end

do
    SpawnCircle = { }

    local campGround = { }
    local campAir = { }
    local campWater = { }

    local red = { }
    local green = { }
    local blue = { }

    function SpawnCircle.getGroundCamp()
        return campGround
    end

    function SpawnCircle.getAirCamp()
        return campAir
    end

    function SpawnCircle.getWaterCamp()
        return campWater
    end

    function SpawnCircle.getRandom(whichTable)
        local camp = whichTable[math.random(1, #whichTable)]

        return camp[math.random(1, #camp)]
    end

    function SpawnCircle.pingMinimap(whichTable)
        for _, camp in pairs(whichTable) do
            for _, circle in pairs(camp) do
                local id = GetPlayerId(GetOwningPlayer(circle))

                PingMinimapEx(GetUnitX(circle), GetUnitY(circle), 12.0, red[id], green[id], blue[id], false)
            end
        end
    end

    function SpawnCircle.create(forPlayer, x, y)
        local circle = CreateUnit(forPlayer, FourCC('n005'), x, y, 270.0)
        --  local icon    = CreateMinimapIcon(x, y, 0xFF, 0xFF, 0xFF, 'UI\\Minimap\\MinimapIconCircleOfPower.mdl', true)

        UnitSetUsesAltIcon(circle, true)

        for _, player in pairs(Team.defensiveForce) do
            UnitShareVision(circle, player, true)
        end

        return circle
    end

    function SpawnCircle.initialize()
        SetAltMinimapIcon('UI\\Minimap\\MinimapIconCircleOfPower.dds')

        red[0x00] = 0xFF;
        green[0x00] = 0x03;
        blue[0x00] = 0x03;
        red[0x01] = 0x00;
        green[0x01] = 0x42;
        blue[0x01] = 0xFF;
        red[0x02] = 0x1C;
        green[0x02] = 0xE6;
        blue[0x02] = 0xB9;
        red[0x03] = 0x54;
        green[0x03] = 0x00;
        blue[0x03] = 0x81;

        red[0x04] = 0xFF;
        green[0x04] = 0xFF;
        blue[0x04] = 0x01;
        red[0x05] = 0xFE;
        green[0x05] = 0x8A;
        blue[0x05] = 0x0E;
        red[0x06] = 0x20;
        green[0x06] = 0xC0;
        blue[0x06] = 0x00;
        red[0x07] = 0xE5;
        green[0x07] = 0x5B;
        blue[0x07] = 0xB0;

        red[0x08] = 0x95;
        green[0x08] = 0x96;
        blue[0x08] = 0x97;
        red[0x09] = 0x7E;
        green[0x09] = 0xBF;
        blue[0x09] = 0xF1;
        red[0x0A] = 0x10;
        green[0x0A] = 0x62;
        blue[0x0A] = 0x46;
        red[0x0B] = 0x4E;
        green[0x0B] = 0x2A;
        blue[0x0B] = 0x04;

        table.insert(campGround, SpawnCircle.create(Player(0x00), 2944.0, -1664.0)) -- Red Color Player
        table.insert(campGround, SpawnCircle.create(Player(0x01), 640.0, -3968.0)) -- Blue Color Player
        table.insert(campGround, SpawnCircle.create(Player(0x02), 7168.0, -1024.0)) -- Teal Color Player
        table.insert(campGround, SpawnCircle.create(Player(0x03), 0.0, -8192.0)) -- Purple Color Player

        table.insert(campWater, SpawnCircle.create(Player(0x04), 5888.0, 1280.0)) -- Yellow Color Player
        table.insert(campWater, SpawnCircle.create(Player(0x05), -2304.0, -6912.0)) -- Orange Color Player
        table.insert(campWater, SpawnCircle.create(Player(0x06), 9472.0, -6400.0)) -- Green Color Player
        table.insert(campWater, SpawnCircle.create(Player(0x07), 5376.0, -10496.0)) -- Pink Color Player

        table.insert(campAir, SpawnCircle.create(Player(0x08), 8448.0, -9472.0)) -- Gray Color Player
        table.insert(campAir, SpawnCircle.create(Player(0x09), 0.0, -1024.0)) -- Light Blue Color Player
        table.insert(campAir, SpawnCircle.create(Player(0x0A), 10752.0, 2560.0)) -- Dark Green Player
        table.insert(campAir, SpawnCircle.create(Player(0x0B), -3584.0, -11776.0)) -- Brown Color Player

        if DEBUG_MODE then
            print('DEBUG_MODE: the SpawnCircle library has been initialized.')
        end
    end

end

do
    Wave = { }

    local round = 1
    local name = { }
    local stylizedName = { }
    local tip = { }
    local prepare = { }
    local count = { }
    local limit = { }
    local spawnCamp = { }
    local startSound = { }
    local endSound = { }
    local pool = { }

    local tickSound = nil
    local hintSound = nil
    local timer = nil
    local timerWindow = nil

    function Wave.displayTopMsg()
        local gameui = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
        local frame = BlzCreateFrameByType('TEXT', '', gameui, '', 0)
        local alpha = 0xFF

        BlzFrameSetPoint(frame, FRAMEPOINT_TOP, gameui, FRAMEPOINT_TOP, 0.0, -0.0195)
        BlzFrameSetVisible(frame, true)
        BlzFrameSetScale(frame, 2.6)

        if pool[round + 1] ~= nil then
            BlzFrameSetText(frame, '|cFFFFFF00Р А У Н Д   ' .. tostring(round) .. ' :|r   ' .. tostring(stylizedName[round]))
        elseif pool[round + 1] == nil then
            BlzFrameSetText(frame, '|cFFFFFF00Ф И Н А Л Ь Н Ы Й   Р А У Н Д :|r   ' .. tostring(stylizedName[round]))
        end

        TimerStart(CreateTimer(), 10.0, false, function()
            TimerStart(GetExpiredTimer(), 0.03125, true, function()
                alpha = alpha - 0x04

                if alpha > 0x00 then
                    BlzFrameSetAlpha(frame, alpha)
                else
                    PauseTimer(GetExpiredTimer())
                    DestroyTimer(GetExpiredTimer())
                    BlzDestroyFrame(frame)
                end
            end)
        end)
    end

    function Wave.displayTip()
        if tip[round] ~= '' then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0.0, 0.0, bj_TEXT_DELAY_ALWAYSHINT, ' ')
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0.0, 0.0, bj_TEXT_DELAY_ALWAYSHINT, '|cFF32CD32HINT|r - ' .. tip[round])
            StartSound(hintSound)
        end
    end

    function Wave.getCount()
        local n = 0

        for _, value in pairs(Team.offensiveForce) do
            n = n + GetPlayerState(value, PLAYER_STATE_RESOURCE_FOOD_USED)
        end

        return n
    end

    function Wave.playSound(soundHandle)
        if soundHandle ~= nil then
            StartSound(soundHandle)
        end
    end

    function Wave.endRound()
        round = round + 1

        if pool[round] ~= nil then
            Wave.playSound(endSound[round])
            Wave.startSpawnTimeout()
            --  Scoreboard.show(true)
            PowerUp.create()
        else
            Game.startVictory()
            Scoreboard.show(true)
        end
    end

    function Wave.startRound()
        TimerDialogDisplay(timerWindow, false)

        SpawnCircle.pingMinimap(spawnCamp[round])
        Wave.displayTopMsg()
        Wave.displayTip()
        Wave.playSound(startSound[round])
        Wave.startSpawn()
        --  Scoreboard.show(false)
        PowerUp.create()
    end

    function Wave.startSpawn()
        if count[round] > 0 then
            TimerStart(timer, 0.75, false, Wave.startSpawn)
            for i = 0, 3 do
                if Wave.getCount() > limit[round] or count[round] == 0 then
                    break
                end

                local circle = SpawnCircle.getRandom(spawnCamp[round])
                local owner = GetOwningPlayer(circle)
                local x = GetUnitX(circle) + GetRandomReal(-16.0, 16.0)
                local y = GetUnitY(circle) + GetRandomReal(-16.0, 16.0)
                local unit = PlaceRandomUnit(pool[round], owner, x, y, 0.0)

                for _, value in pairs(Team.defensiveForce) do
                    UnitShareVision(unit, value, true)
                end

                IssuePointOrderById(unit, OrderId('attack'), 4096.0, -5120.0)
                SetUnitColor(unit, PLAYER_COLOR_COAL)
                --  DestroyEffect(AddSpecialEffectTarget('Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl', unit, 'origin'))

                count[round] = count[round] - 1
            end

        elseif count[round] == 0 and Wave.getCount() > 0 then
            TimerStart(timer, 2.75, false, Wave.startSpawn)

        elseif count[round] == 0 and Wave.getCount() == 0 then
            Wave.endRound()
        end
    end

    function Wave.startSpawnTimeout()
        if timer == nil then
            timer = CreateTimer()
            timerWindow = CreateTimerDialog(timer)

            TimerDialogSetTitleColor(timerWindow, 0xFF, 0xFF, 0xFF, 0xFF)
            TimerDialogSetTimeColor(timerWindow, 0xFF, 0xFF, 0xFF, 0xFF)
        end

        if pool[round - 1] == nil then
            TimerDialogSetTitle(timerWindow, 'Первая волна:')
        elseif pool[round + 1] == nil then
            TimerDialogSetTitle(timerWindow, 'Последняя волна:')
        else
            TimerDialogSetTitle(timerWindow, 'Следующая волна:')
        end

        TimerDialogDisplay(timerWindow, true)
        TimerStart(timer, prepare[round], false, Wave.startRound)

        if prepare[round] >= 3.0 then
            TimerStart(CreateTimer(), prepare[round] - 3.0, false, function()
                StartSound(tickSound)
                TimerStart(GetExpiredTimer(), 1.0, false, function()
                    StartSound(tickSound)
                    TimerStart(GetExpiredTimer(), 1.0, false, function()
                        StartSound(tickSound)
                        PauseTimer(GetExpiredTimer())
                        DestroyTimer(GetExpiredTimer())
                    end)
                end)
            end)
        end
    end

    function Wave.initialize()
        tickSound = CreateSound('Sound\\Interface\\BattleNetTick.wav', false, false, false, 10, 10, 'DefaultEAXON')
        hintSound = CreateSoundFromLabel('Hint', false, false, false, 10000, 10000)

        for _, offensivePlayer in pairs(Team.offensiveForce) do
            for _, defensivePlayer in pairs(Team.defensiveForce) do
                --  SetPlayerAlliance(offensivePlayer, defensivePlayer, ALLIANCE_SHARED_VISION, true)
                --  SetPlayerAlliance(defensivePlayer, offensivePlayer, ALLIANCE_SHARED_VISION, true)
            end
        end

        local trig = CreateTrigger()
        for _, value in pairs(Team.offensiveForce) do
            TriggerRegisterPlayerUnitEvent(trig, value, EVENT_PLAYER_UNIT_SPELL_ENDCAST, nil)
        end
        TriggerAddAction(trig, function()
            IssuePointOrderById(GetSpellAbilityUnit(), OrderId('attack'), 4096.0, -5120.0)
        end)

        TimerStart(CreateTimer(), 0.0, false, function()
            DestroyTimer(GetExpiredTimer())
            Wave.startSpawnTimeout()
        end)

        local data = { }

        for _, value in pairs(Creep) do
            if type(value) == "table" and value.initialize ~= nil then
                value:initialize()
            end
        end

        for _, value in pairs(Creep) do
            if type(value) == "table" and value.round ~= nil then
                if data[value.round] == nil then
                    data[value.round] = { }
                end

                table.insert(data[value.round], value)
            end
        end

        for key, value in pairs(data) do
            local i = math.random(1, #value)

            name[key] = value[i].name
            stylizedName[key] = value[i].stylizedName
            tip[key] = value[i].tip
            prepare[key] = value[i].prepare
            count[key] = value[i].count
            limit[key] = value[i].limit
            spawnCamp[key] = value[i].spawnCamp
            startSound[key] = value[i].startSound
            endSound[key] = value[i].endSound
            pool[key] = value[i].pool

            --  print('Round ' .. key .. ': ' .. name[ key ])
        end

        if DEBUG_MODE then
            print('DEBUG_MODE: the Wave library has been initialized.')
        end
    end

end

Debug = {

    onEsc = function()
        local group = CreateGroup()

        GroupEnumUnitsOfPlayer(group, GetTriggerPlayer(), nil)

        for i = 1, BlzGroupGetSize(group) do
            local enumUnit = BlzGroupUnitAt(group, i - 1)

            if IsUnitType(enumUnit, UNIT_TYPE_HERO) then
                SetHeroLevel(enumUnit, GetHeroLevel(enumUnit) + 1, true)
                UnitResetCooldown(enumUnit)
            end
        end

        DestroyGroup(group)
    end,

    initialize = function()
        Debug.trigger = CreateTrigger()

        for i = 0, bj_MAX_PLAYERS - 1 do
            BlzTriggerRegisterPlayerKeyEvent(Debug.trigger, Player(i), OSKEY_ESCAPE, 0, true)
        end

        TriggerAddAction(Debug.trigger, Debug.onEsc)
    end

}

TimerStart(CreateTimer(), 0.0, false, function()
    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, true)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, true)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, true)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, true)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, true)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, true)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, false)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, false)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, "title")
    QuestSetDescription(bj_lastCreatedQuest, "description")
    QuestSetIconPath(bj_lastCreatedQuest, "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    QuestSetRequired(bj_lastCreatedQuest, false)
    QuestSetDiscovered(bj_lastCreatedQuest, true)
    QuestSetCompleted(bj_lastCreatedQuest, false)
end)

Force = {

    getMokkOwnerPlayer = function()
        return Player(0x00)
    end,

    getPeonOwnerPlayer = function()
        return Player(0x16)
    end,

    initialize = function()
        -- Native Force API:
        -- function CreateForce() end
        -- function DestroyForce(whichForce) end
        -- function ForceAddPlayer(whichForce, whichPlayer) end
        -- function ForceRemovePlayer(whichForce, whichPlayer) end
        -- function BlzForceHasPlayer(whichForce, whichPlayer) end
        -- function ForceClear(whichForce) end
        -- function ForceEnumPlayers(whichForce, filter) end
        -- function ForceEnumPlayersCounted(whichForce, filter, countLimit) end
        -- function ForceEnumAllies(whichForce, whichPlayer, filter) end
        -- function ForceEnumEnemies(whichForce, whichPlayer, filter) end
        -- function ForForce(whichForce, callback) end

        -- Initialize offensive players:
        Force.offensivePlayers = CreateForce()
        ForceAddPlayer(Force.offensivePlayers, Player(0x00))

        -- Initialize defensive players:
        Force.defensivePlayers = CreateForce()
        ForceAddPlayer(Force.defensivePlayers, Player(0x02))
        ForceAddPlayer(Force.defensivePlayers, Player(0x03))
        ForceAddPlayer(Force.defensivePlayers, Player(0x04))
        ForceAddPlayer(Force.defensivePlayers, Player(0x05))
        ForceAddPlayer(Force.defensivePlayers, Player(0x16))

        -- Initialize hero owner players:
        Force.heroOwnerPlayers = CreateForce()
        ForceAddPlayer(Force.heroOwnerPlayers, Player(0x02))
        ForceAddPlayer(Force.heroOwnerPlayers, Player(0x03))
        ForceAddPlayer(Force.heroOwnerPlayers, Player(0x04))
        ForceAddPlayer(Force.heroOwnerPlayers, Player(0x05))

        -- Initialize peon owner players:
        Force.peonOwnerPlayers = CreateForce()
        ForceAddPlayer(Force.peonOwnerPlayers, Player(0x00))

        -- Initialize all players:
        Force.allMapPlayers = CreateForce()
        ForceAddPlayer(Force.allMapPlayers, Player(0x00))
        ForceAddPlayer(Force.allMapPlayers, Player(0x02))
        ForceAddPlayer(Force.allMapPlayers, Player(0x03))
        ForceAddPlayer(Force.allMapPlayers, Player(0x04))
        ForceAddPlayer(Force.allMapPlayers, Player(0x05))
        ForceAddPlayer(Force.allMapPlayers, Player(0x16))

        SetPlayerOnScoreScreen(Player(0x00), false)
        SetPlayerOnScoreScreen(Player(0x16), false)

        if DEBUG_MODE then
            print("DEBUG_MODE: the Force library has been initialized.")
        end
    end

}

Game = {

    startDefeat = function()
    end,

    startVictory = function()
    end,

    setStartingVisibility = function()
        FogEnable(true)
        FogMaskEnable(true)
    end,

    setStartingResources = function()
    end,

    createStartingUnits = function()
        for _, value in pairs(Team.computerForce) do
            local id = GetPlayerId(value)
            local startLocX = GetStartLocationX(id)
            local startLocY = GetStartLocationY(id)

            local unitSpacing = 64.00
            local peonX = startLocX
            local peonY = startLocY - 224.00

            --  Spawn Great Hall at the start location.
            CreateUnit(value, FourCC("o002"), startLocX, startLocY, bj_UNIT_FACING)

            --  Spawn Peons directly south of the town hall.
            CreateUnit(value, FourCC("opeo"), peonX + 2.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
            CreateUnit(value, FourCC("opeo"), peonX + 1.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
            CreateUnit(value, FourCC("opeo"), peonX + 0.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
            CreateUnit(value, FourCC("opeo"), peonX - 1.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
            CreateUnit(value, FourCC("opeo"), peonX - 2.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        end
    end,

    setStartingHeroLimit = function()
    end,

    setPlayerAllianceStateAlly = function(sourcePlayer, otherPlayer, flag)
        SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_PASSIVE, flag)
        SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_HELP_REQUEST, flag)
        SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_HELP_RESPONSE, flag)
        SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_SHARED_XP, flag)
        SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_SHARED_SPELLS, flag)
        SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_SHARED_VISION, flag)
    end,
    
    setAllPlayersAlliance = function()
        Game.setPlayerAllianceStateAlly(Player(0x00), Player(0x02), false)
        Game.setPlayerAllianceStateAlly(Player(0x00), Player(0x03), false)
        Game.setPlayerAllianceStateAlly(Player(0x00), Player(0x04), false)
        Game.setPlayerAllianceStateAlly(Player(0x00), Player(0x05), false)
        Game.setPlayerAllianceStateAlly(Player(0x00), Player(0x16), false)

        Game.setPlayerAllianceStateAlly(Player(0x02), Player(0x00), false)
        Game.setPlayerAllianceStateAlly(Player(0x03), Player(0x00), false)
        Game.setPlayerAllianceStateAlly(Player(0x04), Player(0x00), false)
        Game.setPlayerAllianceStateAlly(Player(0x05), Player(0x00), false)
        Game.setPlayerAllianceStateAlly(Player(0x16), Player(0x00), false)
        
        Game.setPlayerAllianceStateAlly(Player(0x02), Player(0x03), true)
        Game.setPlayerAllianceStateAlly(Player(0x02), Player(0x04), true)
        Game.setPlayerAllianceStateAlly(Player(0x02), Player(0x05), true)
        Game.setPlayerAllianceStateAlly(Player(0x02), Player(0x16), true)

        Game.setPlayerAllianceStateAlly(Player(0x03), Player(0x02), true)
        Game.setPlayerAllianceStateAlly(Player(0x03), Player(0x04), true)
        Game.setPlayerAllianceStateAlly(Player(0x03), Player(0x05), true)
        Game.setPlayerAllianceStateAlly(Player(0x03), Player(0x16), true)

        Game.setPlayerAllianceStateAlly(Player(0x04), Player(0x02), true)
        Game.setPlayerAllianceStateAlly(Player(0x04), Player(0x03), true)
        Game.setPlayerAllianceStateAlly(Player(0x04), Player(0x05), true)
        Game.setPlayerAllianceStateAlly(Player(0x04), Player(0x16), true)

        Game.setPlayerAllianceStateAlly(Player(0x05), Player(0x02), true)
        Game.setPlayerAllianceStateAlly(Player(0x05), Player(0x03), true)
        Game.setPlayerAllianceStateAlly(Player(0x05), Player(0x04), true)
        Game.setPlayerAllianceStateAlly(Player(0x05), Player(0x16), true)

        Game.setPlayerAllianceStateAlly(Player(0x16), Player(0x02), true)
        Game.setPlayerAllianceStateAlly(Player(0x16), Player(0x03), true)
        Game.setPlayerAllianceStateAlly(Player(0x16), Player(0x04), true)
        Game.setPlayerAllianceStateAlly(Player(0x16), Player(0x05), true)
    end,

    setCameraBounds = function()
        local marginX = 1024.0 + 512.0 + 512.0
        local marginY = 1024.0 + 512.0 + 256.0

        local maxX = GetRectMaxX(GetWorldRect())
        local minX = GetRectMinX(GetWorldRect())
        local maxY = GetRectMaxY(GetWorldRect())
        local minY = GetRectMinY(GetWorldRect())

        SetCameraBounds(
            minX + marginX,
            minY + marginY,
            maxX - marginX,
            maxY - marginY,
            minX + marginX,
            maxY - marginY,
            maxX - marginX,
            minY + marginY
        )
    end,

    setCameraTargetDistance = function()
        local cameraDist = 1785.0

        SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, cameraDist, 0.0)

        TimerStart(CreateTimer(), 0.001, true, function()
            SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, cameraDist, 0.0)
        end)
    end,

    initialize = function()
        --[[
        Game.setStartingVisibility()
        Game.setStartingResources()
        Game.setStartingHeroLimit()


        Game.setCameraTargetDistance()
        Game.createStartingUnits()
        ]]

        Game.setCameraBounds()
        Game.setAllPlayersAlliance()

        if DEBUG_MODE then
            print("DEBUG_MODE: the Game library has been initialized.")
        end
    end

}

function displayTopMsg(msg)
    local frame = BlzCreateFrameByType("TEXT", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)

    BlzFrameSetPoint(frame, FRAMEPOINT_TOP, BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), FRAMEPOINT_TOP, 0.0, -0.0195)
    BlzFrameSetText(frame, msg)
    BlzFrameSetScale(frame, 2.6)
    BlzFrameSetVisible(frame, true)
end

Peon = {

    protectTarget = function(target)
    end,

    restoreAll = function()
    end,

    setInvulnerableAll = function(flag)
        SetUnitInvulnerable(u, flag)
    end,

    remove = function(u)
    end,

    create = function(x, y, face)
        return CreateUnit(Player(0x16), FourCC("opeo"), x, y, face)
    end,

    initialize = function()
        Peon.id = FourCC("peon")
        Peon.owner = Force.getPeonOwnerPlayer()
        Peon.group = CreateGroup()
    end

}

PeonsBurrow = {

    restore = function(u)
    end,

    setInvulnerable = function(u, flag)
        SetUnitInvulnerable(u, flag)
    end,

    create = function(x, y, face)
    end,

    initialize = function()
        PeonsBurrow.id = FourCC("pbrw")
        PeonsBurrow.owner = Force.getPeonOwnerPlayer()
        PeonsBurrow.group = CreateGroup()
    end

}

SentryWard = {

    create = function(x, y, face)
        return CreateUnit(SentryWard.owner, SentryWard.id, x, y, face)
    end,

    initialize = function()
        SentryWard.id = FourCC("swrd")
        SentryWard.owner = Force.getPeonOwnerPlayer()
        SentryWard.group = CreateGroup()
    end

}

WatchTower = {

    setInvulnerable = function(u, flag)
        SetUnitInvulnerable(u, flag)
        SetUnitVertexColor(u, 0xFF, 0xFF, 0xFF, IntegerTertiaryOp(flag, 0xA0, 0xFF))
    end,

    setInvulnerableAll = function(flag)
        ForGroup(WatchTower.group, function()
            WatchTower.setInvulnerable(GetEnumUnit(), flag)
        end)
    end,

    restore = function(u)
        if not UnitAlive(u) then
            ReviveUnit(u)
        end

        SetUnitState(u, UNIT_STATE_LIFE, BlzGetUnitMaxHP(u))
        SetUnitState(u, UNIT_STATE_MANA, BlzGetUnitMaxMana(u))
        DestroyEffect(AddSpecialEffectTarget("", u,"origin"))
    end,

    restoreAll = function()
        ForGroup(WatchTower.group, function()
            WatchTower.restore(GetEnumUnit())
        end)
    end,

    create = function(x, y)
        local unit = CreateUnit(WatchTower.owner, WatchTower.id, x, y, bj_UNIT_FACING)
        GroupAddUnit(WatchTower.group, unit)
        CreateMinimapIconOnUnit(unit, 0xFF, 0xFF, 0xFF, "UI\\MiniMap\\minimap-neutralbuilding.mdx", FOG_OF_WAR_VISIBLE)

        local splat = CreateUbersplat(x, y, "OLAR", 0xFF, 0xFF, 0xFF, 0xFF, true, true)
        SetUbersplatRenderAlways(splat, true)

        return unit
    end,

    createAll = function()
        WatchTower.create(0.0, 0.0)
    end,

    initialize = function()
        WatchTower.id = FourCC("t000")
        WatchTower.owner = Force.getPeonOwnerPlayer()
        WatchTower.group = CreateGroup()

        WatchTower.createAll()
    end

}

Blademaster = {

    preload = function()
    end,

    initialize = function()
    end

}
HeroExperience = {

    initialize = function()
        HeroExperience.trigger = CreateTrigger()
        HeroExperience.group = CreateGroup()

        ForForce(Force.heroOwnerPlayers, function()
            SetPlayerHandicapXP(GetEnumPlayer(), 0.0)
        end)

        ForForce(Force.offensivePlayers, function()
            TriggerRegisterPlayerUnitEvent(HeroExperience.trigger, GetEnumPlayer(), EVENT_PLAYER_UNIT_DEATH, nil)
        end)

        TriggerAddAction(HeroExperience.trigger, function()
            local dyingUnit = GetDyingUnit()
            local dyingUnitX = GetUnitX(dyingUnit)
            local dyingUnitY = GetUnitY(dyingUnit)
            local killingUnit = GetKillingUnit()

            local life = BlzGetUnitMaxHP(dyingUnit)
            local mana = BlzGetUnitMaxMana(dyingUnit)
            local level = GetUnitLevel(dyingUnit)
            local exp = math.ceil(2 * ((life + mana) * level) ^ 0.5)

            GroupClear(HeroExperience.group)
            GroupEnumUnitsInRange(HeroExperience.group, dyingUnitX, dyingUnitY, 1200.0 + UNIT_MAX_COLLISION_SIZE, nil)
            ForGroup(HeroExperience.group, function()
                local enumUnit = GetEnumUnit()

                if
                    IsUnitAlly(enumUnit, GetOwningPlayer(killingUnit)) and
                    IsUnitType(enumUnit, UNIT_TYPE_HERO) and
                    IsUnitInRangeXY(enumUnit, dyingUnitX, dyingUnitY, 1200.0)
                then
                    AddHeroXP(enumUnit, exp, true)
                end
            end)
        end)
    end

}

HERO_BLADEMASTER_TYPE_ID = FourCC("H000")
HERO_BANSHEE_RANGER_TYPE_ID = FourCC("H001")
HERO_WARDEN_TYPE_ID = FourCC("H002")
HERO_DEMON_HUNTER_TYPE_ID = FourCC("H003")
HERO_TAUREN_CHIEFTAIN_TYPE_ID = FourCC("H004")
HERO_SHADOW_HUNTER_TYPE_ID = FourCC("H005")
HERO_PANDAREN_BREWMASTER_TYPE_ID = FourCC("H006")
HERO_FARSEER_TYPE_ID = FourCC("H007")
HERO_BEASTMASTER_TYPE_ID = FourCC("H008")
HERO_CRYPT_LORD_TYPE_ID = FourCC("H009")
HERO_DREAD_LORD_TYPE_ID = FourCC("H00:")
HERO_FLAME_LORD_TYPE_ID = FourCC("H00;")
HERO_LICH_TYPE_ID = FourCC("H00<")
HERO_PRIESTESS_OF_THE_MOON_TYPE_ID = FourCC("H00=")
HERO_TINKER_TYPE_ID = FourCC("H00>")
HERO_ALCHEMIST_TYPE_ID = FourCC("H00?")
HERO_ELDER_DRANAI_TYPE_ID = FourCC("H00@")
HERO_NAGA_TYPE_ID = FourCC("H00A")
HERO_ADMIRAL_TYPE_ID = FourCC("H00B")
HERO_ARCH_MAGE_TYPE_ID = FourCC("H00C")
HERO_MOUNTAIN_KING_TYPE_ID = FourCC("H00D")
HERO_TRACKER_TYPE_ID = FourCC("H00E")
HERO_BLOOD_ELF_TYPE_ID = FourCC("H00F")
HERO_PALADIN_TYPE_ID = FourCC("H00G")
HERO_DREAD_KNIGHT_TYPE_ID = FourCC("H00H")
HERO_ARCH_MAGE_TYPE_ID = FourCC("H00I")

Hero = { }
HeroPick = {

    getSpawnX = function()
        return 5360.0
    end,

    getSpawnY = function()
        return -6300.0
    end,

    getSpawnFacing = function()
        return bj_UNIT_FACING
    end,

    initialize = function()
        --BlzHideOriginFrames(true)
        --PauseGame(true)

        -- Hero pick dialog initialization: 0.48 - 0.2085 * 2 - 0.030 * 2
        local heroPickDialog = BlzCreateFrameByType("FRAME", "", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        BlzFrameSetSize(heroPickDialog, 0.497, 0.6)
        BlzFrameSetPoint(heroPickDialog, FRAMEPOINT_CENTER, BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), FRAMEPOINT_CENTER, 0.0, 0.0)

        local heroPickDialogBackdrop = BlzCreateFrameByType("BACKDROP", "", heroPickDialog, "EscMenuBackdrop", 0)
        BlzFrameSetAllPoints(heroPickDialogBackdrop, heroPickDialog)
        BlzFrameSetText(heroPickDialogBackdrop, "webui\\versusmenu\\orc-beta-bg.jpg")

        local heroPickDialogTitle = BlzCreateFrameByType("TEXT", "", heroPickDialog, "EscMenuLabelTextTemplate", 0)
        BlzFrameSetPoint(heroPickDialogTitle, FRAMEPOINT_TOP, heroPickDialog, FRAMEPOINT_TOP, 0.0, -0.03)
        BlzFrameSetText(heroPickDialogTitle, "Mokk: Hero Defense")
        BlzFrameSetTextColor(heroPickDialogTitle, BlzConvertColor(0xFF, 0xFC, 0xD3, 0x12))

        local heroPickDialogSubtitle = BlzCreateFrameByType("TEXT", "", heroPickDialog, "EscMenuTitleTextTemplate", 0)
        BlzFrameSetPoint(heroPickDialogSubtitle, FRAMEPOINT_TOP, heroPickDialogTitle, FRAMEPOINT_BOTTOM, 0.0, -0.002)
        BlzFrameSetText(heroPickDialogSubtitle, "Выберите себе героя")
        BlzFrameSetTextColor(heroPickDialogSubtitle, BlzConvertColor(0xFF, 0xFF, 0xFF, 0xFF))



        -- Hero list container initialization:
        local heroListContainer = BlzCreateFrameByType("LISTBOX", "", heroPickDialog, "", 0)
        local heroListContainerWidth = 0.2085
        local heroListContainerHeight = 0.11
        BlzFrameSetSize(heroListContainer, heroListContainerWidth, heroListContainerHeight)
        BlzFrameSetPoint(heroListContainer, FRAMEPOINT_TOPLEFT, heroPickDialog, FRAMEPOINT_TOPLEFT,  0.030, -0.080)

        local heroListTitle = BlzCreateFrameByType("TEXT", "", heroListContainer, "EscMenuLabelTextTemplate", 0)
        BlzFrameSetPoint(heroListTitle, FRAMEPOINT_BOTTOMLEFT, heroListContainer, FRAMEPOINT_TOPLEFT, 0.006, 0.002)
        BlzFrameSetText(heroListTitle, "Cписок героев:")
        BlzFrameSetTextColor(heroListTitle, BlzConvertColor(0xFF, 0xFC, 0xD3, 0x12))

        local heroListScrollbar = BlzCreateFrameByType("SLIDER", "", heroListContainer, "EscMenuScrollBarTemplate", 0)
        local heroListScrollbarOffset = 0.010
        local heroListScrollbarHeight = BlzFrameGetHeight(heroListContainer) - heroListScrollbarOffset * 2
        local heroListScrollbarWidth = 0.012
        BlzFrameSetSize(heroListScrollbar, heroListScrollbarWidth, heroListScrollbarHeight)
        BlzFrameSetPoint(heroListScrollbar, FRAMEPOINT_TOPRIGHT, heroListContainer, FRAMEPOINT_TOPRIGHT, 0.0, -heroListScrollbarOffset)
        BlzFrameSetMinMaxValue(heroListScrollbar, 1, 5)
        BlzFrameSetStepSize(heroListScrollbar, 1)
        BlzFrameSetValue(heroListScrollbar, 5)
        BlzFrameSetEnable(heroListScrollbar, false)

        local trig = CreateTrigger()
        BlzTriggerRegisterFrameEvent(trig, heroListContainer, FRAMEEVENT_MOUSE_WHEEL)
        TriggerAddAction(trig, function()
            if BlzGetTriggerFrameValue() > 0.0 then
                BlzFrameSetValue(heroListScrollbar, BlzFrameGetValue(heroListScrollbar) + 1)
            elseif BlzGetTriggerFrameValue() < 0.0 then
                BlzFrameSetValue(heroListScrollbar, BlzFrameGetValue(heroListScrollbar) - 1)
            end
        end)



        -- Hero list item initialization:
        --[[local heroListItem = BlzCreateFrame("QuestListItem", heroListContainer, 0, 0)]]
        local heroListItemStepOffset = 0.0025 -- Расстояние между кнпоками.
        --[[local heroListItemWidth = heroListContainerWidth - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemHeight = 0.035
        BlzFrameSetSize(heroListItem, heroListItemWidth, heroListItemHeight)
        BlzFrameSetPoint(heroListItem, FRAMEPOINT_TOPLEFT, heroListContainer, FRAMEPOINT_TOPLEFT,  0.0, 0.0)]]

        local heroListItemIcon = BlzCreateFrame("HeroListItemIcon", heroListContainer, 0, 0)
        local heroListItemIconWidth = 0.035
        local heroListItemIconHeight = 0.035
        BlzFrameSetSize(heroListItemIcon, heroListItemIconWidth, heroListItemIconHeight)
        BlzFrameSetPoint(heroListItemIcon, FRAMEPOINT_TOPLEFT, heroListContainer, FRAMEPOINT_TOPLEFT,  0.0, 0.0)
        BlzFrameSetTexture(heroListItemIcon, "ReplaceableTextures\\CommandButtons\\BTNEarthBrewmaster", 0, true)

        local heroListItemButton = BlzCreateFrame("HeroListItemButton", heroListContainer, 0, 0)
        local heroListItemButtonOffset = -0.003 -- Смещение по оси "х" относительно "heroListItemIcon".
        local heroListItemButtonWidth = heroListContainerWidth - heroListItemIconWidth - heroListItemButtonOffset - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemButtonHeight = 0.035
        BlzFrameClearAllPoints(heroListItemButton)
        BlzFrameSetSize(heroListItemButton, heroListItemButtonWidth, heroListItemButtonHeight)
        BlzFrameSetPoint(heroListItemButton, FRAMEPOINT_TOPLEFT, heroListItemIcon, FRAMEPOINT_TOPRIGHT, heroListItemButtonOffset, 0.0)

        local trg = CreateTrigger()
        BlzTriggerRegisterFrameEvent(trg, heroListItemButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(trg, function() print "click" end)

        local heroListItemButtonText = BlzGetFrameByName("HeroListItemButtonTitle", 0)
        BlzFrameSetPoint(heroListItemButtonText, FRAMEPOINT_LEFT, heroListItemButton, FRAMEPOINT_LEFT, 0.002, 0.002)
        BlzFrameSetText(heroListItemButtonText, "Jer'rykh, Earth Spirit")
        BlzFrameSetTextColor(heroListItemButtonText, BlzConvertColor(0xFF, 0xFF, 0xFF, 0xFF))



        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        local heroListItem = BlzCreateFrame("QuestListItem", heroListContainer, 0, 0)
        local heroListItemStepOffset = 0.0025 -- Расстояние между кнпоками.
        local heroListItemWidth = heroListContainerWidth - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemHeight = 0.035
        BlzFrameSetSize(heroListItem, heroListItemWidth, heroListItemHeight)
        BlzFrameSetPoint(heroListItem, FRAMEPOINT_TOPLEFT, heroListContainer, FRAMEPOINT_TOPLEFT,  0.0, -(heroListItemHeight + heroListItemStepOffset) )

        local heroListItemIcon = BlzGetFrameByName("QuestListItemIconContainer", 0)
        local heroListItemIconWidth = 0.035
        local heroListItemIconHeight = 0.035
        BlzFrameSetSize(heroListItemIcon, heroListItemIconWidth, heroListItemIconHeight)
        BlzFrameSetPoint(heroListItemIcon, FRAMEPOINT_TOPLEFT, heroListItem, FRAMEPOINT_TOPLEFT,  0.0, 0.0)
        BlzFrameSetTexture(heroListItemIcon, "ReplaceableTextures\\CommandButtons\\BTNFireBrewmaster.dds", 0, true)

        local heroListItemButton = BlzGetFrameByName("QuestListItemButton", 0)
        local heroListItemButtonOffset = -0.003 -- Смещение по оси "х" относительно "heroListItemIcon".
        local heroListItemButtonWidth = heroListContainerWidth - heroListItemIconWidth - heroListItemButtonOffset - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemButtonHeight = 0.035
        BlzFrameClearAllPoints(heroListItemButton)
        BlzFrameSetSize(heroListItemButton, heroListItemButtonWidth, heroListItemButtonHeight)
        BlzFrameSetPoint(heroListItemButton, FRAMEPOINT_TOPLEFT, heroListItemIcon, FRAMEPOINT_TOPRIGHT, heroListItemButtonOffset, 0.0)

        local heroListItemButtonText = BlzGetFrameByName("QuestListItemTitle", 0)
        BlzFrameSetPoint(heroListItemButtonText, FRAMEPOINT_LEFT, heroListItemButton, FRAMEPOINT_LEFT, 0.002, 0.002)
        BlzFrameSetText(heroListItemButtonText, "Ort'rykh, Fire Spirit")
        BlzFrameSetTextColor(heroListItemButtonText, BlzConvertColor(0xFF, 0xFF, 0xFF, 0xFF))

        local heroListItemButtonStatusText = BlzGetFrameByName("QuestListItemComplete", 0)
        local heroListItemButtonStatusTextWidth = BlzFrameGetWidth(heroListItemButtonText)
        local heroListItemButtonStatusTextHeight = BlzFrameGetHeight(heroListItemButtonStatusText)
        BlzFrameClearAllPoints(heroListItemButtonStatusText)
        BlzFrameSetSize(heroListItemButtonStatusText, heroListItemButtonStatusTextWidth, heroListItemButtonStatusTextHeight)
        BlzFrameSetPoint(heroListItemButtonStatusText, FRAMEPOINT_BOTTOMLEFT, heroListItemButton, FRAMEPOINT_BOTTOMLEFT, 0.012, 0.008)
        BlzFrameSetText(heroListItemButtonStatusText, "")
        BlzFrameSetTextColor(heroListItemButtonStatusText, BlzConvertColor(0xFF, 0x80, 0x80, 0x80))
        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





        --[[
        -------------------------------------------------------------------------------------------------------------------------
        BlzFrameSetVisible(heroListItemButton, false)

        local heroListItemButton = BlzCreateFrameByType("GLUEBUTTON", "", heroListItem, "QuestButtonTemplate", 0)
        local heroListItemButtonWidth = 0.2085 - 0.035 + 0.003 - 0.012 - 0.0025
        local heroListItemButtonHeight = 0.035
        BlzFrameClearAllPoints(heroListItemButton)
        BlzFrameSetSize(heroListItemButton, heroListItemButtonWidth, heroListItemButtonHeight)
        BlzFrameSetPoint(heroListItemButton, FRAMEPOINT_TOPLEFT, heroListItemIcon, FRAMEPOINT_TOPRIGHT, -0.003, 0.0)
        -------------------------------------------------------------------------------------------------------------------------
        ]]



        -- Hero description container initialization:
        local heroDescriptionContainer = BlzCreateFrameByType("FRAME", "", heroPickDialog, "", 0)
        BlzFrameSetSize(heroDescriptionContainer, 0.2085, 0.11)
        BlzFrameSetPoint(heroDescriptionContainer, FRAMEPOINT_TOPRIGHT, heroPickDialog, FRAMEPOINT_TOPRIGHT, -0.030, -0.08)

        local heroDescriptionTitle = BlzCreateFrameByType("TEXT", "", heroDescriptionContainer, "EscMenuLabelTextTemplate", 0)
        BlzFrameSetPoint(heroDescriptionTitle, FRAMEPOINT_BOTTOMLEFT, heroDescriptionContainer, FRAMEPOINT_TOPLEFT, 0.006, 0.002)
        BlzFrameSetText(heroDescriptionTitle, "Описание героя:")
        BlzFrameSetTextColor(heroDescriptionTitle, BlzConvertColor(0xFF, 0xFC, 0xD3, 0x12))

        local heroDescriptionTextArea = BlzCreateFrameByType("TEXTAREA", "", heroDescriptionContainer, "EscMenuTextAreaTemplate", 0)
        BlzFrameSetAllPoints(heroDescriptionTextArea, heroDescriptionContainer)
        BlzFrameAddText(heroDescriptionTextArea, "Базовый рабочий. Добывает золото и древесину, а также строит и ремонтирует здания. Может оборонять базу, засев в землянке.")



        -- Ability list container initialization:
        local abilityListContainer = BlzCreateFrameByType("LISTBOX", "", heroPickDialog, "", 0)
        BlzFrameSetSize(abilityListContainer, 0.2085, 0.11)
        BlzFrameSetPoint(abilityListContainer, FRAMEPOINT_TOPLEFT, heroListContainer, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.020)

        local abilityListTitle = BlzCreateFrameByType("TEXT", "", abilityListContainer, "EscMenuLabelTextTemplate", 0)
        BlzFrameSetPoint(abilityListTitle, FRAMEPOINT_BOTTOMLEFT, abilityListContainer, FRAMEPOINT_TOPLEFT, 0.006, 0.002)
        BlzFrameSetText(abilityListTitle, "Cписок способностей:")
        BlzFrameSetTextColor(abilityListTitle, BlzConvertColor(0xFF, 0xFC, 0xD3, 0x12))

        local abilityListScrollbar = BlzCreateFrameByType("SLIDER", "", abilityListContainer, "EscMenuScrollBarTemplate", 0)
        local abilityListScrollbarOffset = 0.010
        local abilityListScrollbarHeight = BlzFrameGetHeight(abilityListContainer) - abilityListScrollbarOffset * 2
        BlzFrameSetSize(abilityListScrollbar, 0.012, abilityListScrollbarHeight)
        BlzFrameSetPoint(abilityListScrollbar, FRAMEPOINT_TOPRIGHT, abilityListContainer, FRAMEPOINT_TOPRIGHT, 0.0, -abilityListScrollbarOffset)
        BlzFrameSetMinMaxValue(abilityListScrollbar, 1, 15)
        BlzFrameSetStepSize(abilityListScrollbar, 1)
        BlzFrameSetValue(abilityListScrollbar, 15)



        local trig = CreateTrigger()
        BlzTriggerRegisterFrameEvent(trig, abilityListContainer, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, abilityListScrollbar, FRAMEEVENT_MOUSE_WHEEL)
        TriggerAddAction(trig, function()
            if BlzGetTriggerFrameValue() > 0.0 then
                BlzFrameSetValue(abilityListScrollbar, BlzFrameGetValue(abilityListScrollbar) + 1)
            elseif BlzGetTriggerFrameValue() < 0.0 then
                BlzFrameSetValue(abilityListScrollbar, BlzFrameGetValue(abilityListScrollbar) - 1)
            end
        end)



        -----------------------------
        local heroListItem = BlzCreateFrame("QuestListItem", abilityListContainer, 0, 0)
        local heroListItemStepOffset = 0.0025 -- Расстояние между кнпоками.
        local heroListItemWidth = heroListContainerWidth - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemHeight = 0.035
        BlzFrameSetSize(heroListItem, heroListItemWidth, heroListItemHeight)
        BlzFrameSetPoint(heroListItem, FRAMEPOINT_TOPLEFT, abilityListContainer, FRAMEPOINT_TOPLEFT,  0.0, 0.0)

        local heroListItemIcon = BlzGetFrameByName("QuestListItemIconContainer", 0)
        local heroListItemIconWidth = 0.035
        local heroListItemIconHeight = 0.035
        BlzFrameSetSize(heroListItemIcon, heroListItemIconWidth, heroListItemIconHeight)
        BlzFrameSetPoint(heroListItemIcon, FRAMEPOINT_TOPLEFT, heroListItem, FRAMEPOINT_TOPLEFT,  0.0, 0.0)
        BlzFrameSetTexture(heroListItemIcon, "ReplaceableTextures\\CommandButtons\\BTNWindWalkOn.blp", 0, true)

        local heroListItemButton = BlzGetFrameByName("QuestListItemButton", 0)
        local heroListItemButtonOffset = -0.003 -- Смещение по оси "х" относительно "heroListItemIcon".
        local heroListItemButtonWidth = heroListContainerWidth - heroListItemIconWidth - heroListItemButtonOffset - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemButtonHeight = 0.035
        BlzFrameClearAllPoints(heroListItemButton)
        BlzFrameSetSize(heroListItemButton, heroListItemButtonWidth, heroListItemButtonHeight)
        BlzFrameSetPoint(heroListItemButton, FRAMEPOINT_TOPLEFT, heroListItemIcon, FRAMEPOINT_TOPRIGHT, heroListItemButtonOffset, 0.0)

        local heroListItemButtonText = BlzGetFrameByName("QuestListItemTitle", 0)
        BlzFrameSetPoint(heroListItemButtonText, FRAMEPOINT_LEFT, heroListItemButton, FRAMEPOINT_LEFT, 0.002, 0.002)
        BlzFrameSetText(heroListItemButtonText, "Shadow Walk")
        BlzFrameSetTextColor(heroListItemButtonText, BlzConvertColor(0xFF, 0xFF, 0xFF, 0xFF))

        local heroListItemButtonStatusText = BlzGetFrameByName("QuestListItemComplete", 0)
        local heroListItemButtonStatusTextWidth = BlzFrameGetWidth(heroListItemButtonText)
        local heroListItemButtonStatusTextHeight = BlzFrameGetHeight(heroListItemButtonStatusText)
        BlzFrameClearAllPoints(heroListItemButtonStatusText)
        BlzFrameSetSize(heroListItemButtonStatusText, heroListItemButtonStatusTextWidth, heroListItemButtonStatusTextHeight)
        BlzFrameSetPoint(heroListItemButtonStatusText, FRAMEPOINT_BOTTOMLEFT, heroListItemButton, FRAMEPOINT_BOTTOMLEFT, 0.012, 0.008)
        BlzFrameSetText(heroListItemButtonStatusText, "")
        BlzFrameSetTextColor(heroListItemButtonStatusText, BlzConvertColor(0xFF, 0x80, 0x80, 0x80))



        BlzTriggerRegisterFrameEvent(trig, heroListItem, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemIcon, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButton, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButtonText, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButtonStatusText, FRAMEEVENT_MOUSE_WHEEL)



        local heroListItem = BlzCreateFrame("QuestListItem", abilityListContainer, 0, 0)
        local heroListItemStepOffset = 0.0025 -- Расстояние между кнпоками.
        local heroListItemWidth = heroListContainerWidth - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemHeight = 0.035
        BlzFrameSetSize(heroListItem, heroListItemWidth, heroListItemHeight)
        BlzFrameSetPoint(heroListItem, FRAMEPOINT_TOPLEFT, abilityListContainer, FRAMEPOINT_TOPLEFT,  0.0, -1 * (heroListItemHeight + heroListItemStepOffset))

        local heroListItemIcon = BlzGetFrameByName("QuestListItemIconContainer", 0)
        local heroListItemIconWidth = 0.035
        local heroListItemIconHeight = 0.035
        BlzFrameSetSize(heroListItemIcon, heroListItemIconWidth, heroListItemIconHeight)
        BlzFrameSetPoint(heroListItemIcon, FRAMEPOINT_TOPLEFT, heroListItem, FRAMEPOINT_TOPLEFT,  0.0, 0.0)
        BlzFrameSetTexture(heroListItemIcon, "ReplaceableTextures\\CommandButtons\\BTNMirrorImage.blp", 0, true)

        local heroListItemButton = BlzGetFrameByName("QuestListItemButton", 0)
        local heroListItemButtonOffset = -0.003 -- Смещение по оси "х" относительно "heroListItemIcon".
        local heroListItemButtonWidth = heroListContainerWidth - heroListItemIconWidth - heroListItemButtonOffset - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemButtonHeight = 0.035
        BlzFrameClearAllPoints(heroListItemButton)
        BlzFrameSetSize(heroListItemButton, heroListItemButtonWidth, heroListItemButtonHeight)
        BlzFrameSetPoint(heroListItemButton, FRAMEPOINT_TOPLEFT, heroListItemIcon, FRAMEPOINT_TOPRIGHT, heroListItemButtonOffset, 0.0)

        local heroListItemButtonText = BlzGetFrameByName("QuestListItemTitle", 0)
        BlzFrameSetPoint(heroListItemButtonText, FRAMEPOINT_LEFT, heroListItemButton, FRAMEPOINT_LEFT, 0.002, 0.002)
        BlzFrameSetText(heroListItemButtonText, "Mirror Image")
        BlzFrameSetTextColor(heroListItemButtonText, BlzConvertColor(0xFF, 0xFF, 0xFF, 0xFF))

        local heroListItemButtonStatusText = BlzGetFrameByName("QuestListItemComplete", 0)
        local heroListItemButtonStatusTextWidth = BlzFrameGetWidth(heroListItemButtonText)
        local heroListItemButtonStatusTextHeight = BlzFrameGetHeight(heroListItemButtonStatusText)
        BlzFrameClearAllPoints(heroListItemButtonStatusText)
        BlzFrameSetSize(heroListItemButtonStatusText, heroListItemButtonStatusTextWidth, heroListItemButtonStatusTextHeight)
        BlzFrameSetPoint(heroListItemButtonStatusText, FRAMEPOINT_BOTTOMLEFT, heroListItemButton, FRAMEPOINT_BOTTOMLEFT, 0.012, 0.008)
        BlzFrameSetText(heroListItemButtonStatusText, "")
        BlzFrameSetTextColor(heroListItemButtonStatusText, BlzConvertColor(0xFF, 0x80, 0x80, 0x80))



        BlzTriggerRegisterFrameEvent(trig, heroListItem, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemIcon, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButton, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButtonText, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButtonStatusText, FRAMEEVENT_MOUSE_WHEEL)



        local heroListItem = BlzCreateFrame("QuestListItem", abilityListContainer, 0, 0)
        local heroListItemStepOffset = 0.0025 -- Расстояние между кнпоками.
        local heroListItemWidth = heroListContainerWidth - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemHeight = 0.035
        BlzFrameSetSize(heroListItem, heroListItemWidth, heroListItemHeight)
        BlzFrameSetPoint(heroListItem, FRAMEPOINT_TOPLEFT, abilityListContainer, FRAMEPOINT_TOPLEFT,  0.0, -2 * (heroListItemHeight + heroListItemStepOffset))

        local heroListItemIcon = BlzGetFrameByName("QuestListItemIconContainer", 0)
        local heroListItemIconWidth = 0.035
        local heroListItemIconHeight = 0.035
        BlzFrameSetSize(heroListItemIcon, heroListItemIconWidth, heroListItemIconHeight)
        BlzFrameSetPoint(heroListItemIcon, FRAMEPOINT_TOPLEFT, heroListItem, FRAMEPOINT_TOPLEFT,  0.0, 0.0)
        BlzFrameSetTexture(heroListItemIcon, "ReplaceableTextures\\CommandButtons\\BTNCriticalStrike.blp", 0, true)

        local heroListItemButton = BlzGetFrameByName("QuestListItemButton", 0)
        local heroListItemButtonOffset = -0.003 -- Смещение по оси "х" относительно "heroListItemIcon".
        local heroListItemButtonWidth = heroListContainerWidth - heroListItemIconWidth - heroListItemButtonOffset - heroListScrollbarWidth - heroListItemStepOffset
        local heroListItemButtonHeight = 0.035
        BlzFrameClearAllPoints(heroListItemButton)
        BlzFrameSetSize(heroListItemButton, heroListItemButtonWidth, heroListItemButtonHeight)
        BlzFrameSetPoint(heroListItemButton, FRAMEPOINT_TOPLEFT, heroListItemIcon, FRAMEPOINT_TOPRIGHT, heroListItemButtonOffset, 0.0)

        local heroListItemButtonText = BlzGetFrameByName("QuestListItemTitle", 0)
        BlzFrameSetPoint(heroListItemButtonText, FRAMEPOINT_LEFT, heroListItemButton, FRAMEPOINT_LEFT, 0.002, 0.002)
        BlzFrameSetText(heroListItemButtonText, "Critical Strike")
        BlzFrameSetTextColor(heroListItemButtonText, BlzConvertColor(0xFF, 0xFF, 0xFF, 0xFF))

        local heroListItemButtonStatusText = BlzGetFrameByName("QuestListItemComplete", 0)
        local heroListItemButtonStatusTextWidth = BlzFrameGetWidth(heroListItemButtonText)
        local heroListItemButtonStatusTextHeight = BlzFrameGetHeight(heroListItemButtonStatusText)
        BlzFrameClearAllPoints(heroListItemButtonStatusText)
        BlzFrameSetSize(heroListItemButtonStatusText, heroListItemButtonStatusTextWidth, heroListItemButtonStatusTextHeight)
        BlzFrameSetPoint(heroListItemButtonStatusText, FRAMEPOINT_BOTTOMLEFT, heroListItemButton, FRAMEPOINT_BOTTOMLEFT, 0.012, 0.008)
        BlzFrameSetText(heroListItemButtonStatusText, "")
        BlzFrameSetTextColor(heroListItemButtonStatusText, BlzConvertColor(0xFF, 0x80, 0x80, 0x80))



        BlzTriggerRegisterFrameEvent(trig, heroListItem, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemIcon, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButton, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButtonText, FRAMEEVENT_MOUSE_WHEEL)
        BlzTriggerRegisterFrameEvent(trig, heroListItemButtonStatusText, FRAMEEVENT_MOUSE_WHEEL)

        -----------------------------
        -----------------------------



        -- Ability description container initialization:
        local abilityDescriptionContainer = BlzCreateFrameByType("FRAME", "", heroPickDialog, "", 0)
        BlzFrameSetSize(abilityDescriptionContainer, 0.2085, 0.11)
        --BlzFrameSetPoint(abilityDescriptionContainer, FRAMEPOINT_TOPRIGHT, heroDescriptionContainer, FRAMEPOINT_BOTTOMRIGHT, 0.0, -0.026375)
        BlzFrameSetPoint(abilityDescriptionContainer, FRAMEPOINT_TOPRIGHT, heroDescriptionContainer, FRAMEPOINT_BOTTOMRIGHT, 0.0, -0.020)

        local abilityDescriptionTitle = BlzCreateFrameByType("TEXT", "", abilityDescriptionContainer, "EscMenuLabelTextTemplate", 0)
        BlzFrameSetPoint(abilityDescriptionTitle, FRAMEPOINT_BOTTOMLEFT, abilityDescriptionContainer, FRAMEPOINT_TOPLEFT, 0.003, 0.002)
        BlzFrameSetPoint(abilityDescriptionTitle, FRAMEPOINT_BOTTOMLEFT, abilityDescriptionContainer, FRAMEPOINT_TOPLEFT, 0.006, 0.002)
        BlzFrameSetText(abilityDescriptionTitle, "Описание способности:")
        BlzFrameSetTextColor(abilityDescriptionTitle, BlzConvertColor(0xFF, 0xFC, 0xD3, 0x12))

        local abilityDescriptionTextArea = BlzCreateFrameByType("TEXTAREA", "", abilityDescriptionContainer, "EscMenuTextAreaTemplate", 0)
        BlzFrameSetAllPoints(abilityDescriptionTextArea, abilityDescriptionContainer)
        BlzFrameAddText(abilityDescriptionTextArea, "Some text can be here. Some text can be here. Some text can be here.")



        -- Chat log container initialization:
        local chatLogContainer = BlzCreateFrameByType("FRAME", "", heroPickDialog, "", 0)
        BlzFrameSetSize(chatLogContainer, 0.42, 0.11)
        --BlzFrameSetPoint(chatLogContainer, FRAMEPOINT_TOPRIGHT, abilityDescriptionContainer, FRAMEPOINT_BOTTOMRIGHT, 0.0, -0.026375)
        BlzFrameSetPoint(chatLogContainer, FRAMEPOINT_TOPRIGHT, abilityDescriptionContainer, FRAMEPOINT_BOTTOMRIGHT, 0.0, -0.020)
        BlzFrameSetPoint(chatLogContainer, FRAMEPOINT_TOPLEFT, abilityListContainer, FRAMEPOINT_BOTTOMLEFT, 0.0, -0.020)

        local chatLogTitle = BlzCreateFrameByType("TEXT", "", chatLogContainer, "EscMenuLabelTextTemplate", 0)
        BlzFrameSetPoint(chatLogTitle, FRAMEPOINT_BOTTOMLEFT, chatLogContainer, FRAMEPOINT_TOPLEFT, 0.003, 0.002)
        BlzFrameSetPoint(chatLogTitle, FRAMEPOINT_BOTTOMLEFT, chatLogContainer, FRAMEPOINT_TOPLEFT, 0.006, 0.002)
        BlzFrameSetText(chatLogTitle, "Журнал сообщений:")
        BlzFrameSetTextColor(chatLogTitle, BlzConvertColor(0xFF, 0xFC, 0xD3, 0x12))

        local chatLogTextArea = BlzCreateFrameByType("TEXTAREA", "", chatLogContainer, "EscMenuTextAreaTemplate", 0)
        BlzFrameSetAllPoints(chatLogTextArea, chatLogContainer)

        BlzFrameAddText(chatLogTextArea, "|cff32CD32HINT|r – Выбор правильного персонажа поможет вам проще пройти игру. Обратите внимание на то, чтобы в вашей команде был хотя бы один герой из каждого класса.")
        BlzFrameAddText(chatLogTextArea, " ")
        BlzFrameAddText(chatLogTextArea, "|cFFFF0303scopterectus|r: привет, модмейкеры!")
        BlzFrameAddText(chatLogTextArea, "|cFFFE8A0EBergi-bear|r: ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо! ха-хо-хо!")
        BlzFrameAddText(chatLogTextArea, "|cFFFE8A0EBergi-bear|r: Peony i translit rulit!! )))]]]")
        BlzFrameAddText(chatLogTextArea, "|cFFFF0303scopterectus|r: ну всё, я обиделся...............")

        local chatLogEditBox = BlzCreateFrameByType("EDITBOX", "", chatLogContainer, "EscMenuEditBoxTemplate", 0)
        BlzFrameSetSize(chatLogEditBox, 0.42, 0.04)
        BlzFrameSetPoint(chatLogEditBox, FRAMEPOINT_TOPRIGHT, chatLogTextArea, FRAMEPOINT_BOTTOMRIGHT, 0.0, -0.0010)
        BlzFrameSetPoint(chatLogEditBox, FRAMEPOINT_TOPLEFT, chatLogTextArea, FRAMEPOINT_BOTTOMLEFT, 0.0, -0.0010)



        -- Exit button initialization:
        local okButton = BlzCreateFrame("MapStandardButton", heroPickDialog, 0, 0)
        BlzFrameSetSize(okButton, 0.129, BlzFrameGetHeight(okButton))
        BlzFrameSetPoint(okButton, FRAMEPOINT_BOTTOMLEFT, heroPickDialog, FRAMEPOINT_BOTTOM, 0.003, 0.03)

        local okButtonText = BlzGetFrameByName("MapStandardButtonText", 0)
        BlzFrameSetText(okButtonText, "OK")

        local tempButton = BlzCreateFrame("MapStandardButton", heroPickDialog, 0, 0)
        BlzFrameSetSize(tempButton, 0.129, BlzFrameGetHeight(tempButton))
        BlzFrameSetPoint(tempButton, FRAMEPOINT_TOPRIGHT, okButton, FRAMEPOINT_TOPLEFT, -0.006, 0.0)
        BlzFrameSetEnable(tempButton, false)

        local tempButtonText = BlzGetFrameByName("MapStandardButtonText", 0)
        BlzFrameSetText(tempButtonText, "Cancel")

        local trg = CreateTrigger()
        BlzTriggerRegisterFrameEvent(trg, okButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(trg, function()
            if GetLocalPlayer() == GetTriggerPlayer() then
                BlzFrameSetVisible(heroPickDialog, false)
            end
        end)
    end

}

function Hero.getByPlayer(whichPlayer)
    return Hero[whichPlayer]
end

function HeroPick.displayHint()
    local snd = CreateSoundFromLabel("Hint", false, false, false, 10000, 10000)
    local hint = "Choose the right character for your game. " ..
        "To complete the game, your team must have at least one hero from each class. " ..
        "For more information, click on the tavern you are interested in."

    DisplayTimedTextToPlayer(GetLocalPlayer(), 0.0, 0.0, 9.0, " ")
    DisplayTimedTextToPlayer(GetLocalPlayer(), 0.0, 0.0, 9.0, "|cff32CD32HINT|r – " .. hint)
    StartSound(snd)
    KillSoundWhenDone(snd)
end

function HeroPick.initializeTavernPick()
    local soldUnit = GetSoldUnit()
    local owner = GetOwningPlayer(soldUnit)

    for _, value in pairs(Team.defensiveForce) do
        SetPlayerTechMaxAllowed(value, GetUnitTypeId(soldUnit), IntegerTertiaryOp(value == owner, 1, 0))
    end

    UnitModifySkillPoints(soldUnit, -1)
    SetUnitX(soldUnit, HeroPick.getSpawnX(owner))
    SetUnitY(soldUnit, HeroPick.getSpawnY(owner))
    SetUnitFacing(soldUnit, HeroPick.getSpawnFacing(owner))
    SetUnitState(soldUnit, UNIT_STATE_LIFE, BlzGetUnitMaxHP(soldUnit))
    SetUnitState(soldUnit, UNIT_STATE_MANA, BlzGetUnitMaxMana(soldUnit))
    BlzSetHeroProperName(soldUnit, GetPlayerName(owner))

    if GetLocalPlayer() == owner then
        ClearSelection()
        ClearTextMessages()
        SelectUnit(soldUnit, true)
        BlzFrameSetVisible(topMsg, false)
        SetCameraPosition(GetUnitX(soldUnit), GetUnitY(soldUnit))
    end
end

HeroRevive = {

    initialize = function()
        HeroRevive.trigger = CreateTrigger()
        HeroRevive.graveTypeId = FourCC('h003')

        ForForce(Force.heroOwnerPlayers, function()
            TriggerRegisterPlayerUnitEvent(HeroRevive.trigger, GetEnumPlayer(), EVENT_PLAYER_UNIT_DEATH, nil)
        end)

        TriggerAddAction(HeroRevive.trigger, function()
            local dyingUnit = GetDyingUnit()

            if IsUnitType(dyingUnit, UNIT_TYPE_HERO) then
                local dyingUnitX = GetUnitX(dyingUnit)
                local dyingUnitY = GetUnitY(dyingUnit)
                local grave = CreateUnit(GetOwningPlayer(dyingUnit), HeroRevive.graveTypeId, dyingUnitX, dyingUnitY, 0.0)
                local timer = CreateTimer()
                local graveLife = 1.0

                SetWidgetLife(grave, 1.0)
                SetUnitPathing(grave, false)
                BlzSetUnitName(grave, GetHeroProperName(dyingUnit))

                if IsUnitSelected(dyingUnit, GetLocalPlayer()) then
                    SelectUnit(dyingUnit, false)
                    SelectUnit(grave, true)
                end

                TimerStart(timer, 0.1, true, function()
                    local curLife = GetWidgetLife(grave)

                    if curLife < 100.0 then
                        if curLife > graveLife then
                            graveLife = curLife
                        elseif curLife <= graveLife then
                            graveLife = 1.0
                            SetWidgetLife(grave, 1.0)
                        end

                    else
                        ReviveHero(dyingUnit, dyingUnitX, dyingUnitY, true)
                        SetUnitState(dyingUnit, UNIT_STATE_LIFE, BlzGetUnitMaxHP(dyingUnit))
                        SetUnitState(dyingUnit, UNIT_STATE_MANA, BlzGetUnitMaxMana(dyingUnit))

                        if IsUnitSelected(grave, GetLocalPlayer()) then
                            SelectUnit(grave, false)
                            SelectUnit(dyingUnit, true)
                        end

                        RemoveUnit(grave)
                        PauseTimer(timer)
                        DestroyTimer(timer)
                    end
                end)
            end
        end)
    end

}

SkillPoints = {

    onPlayerHeroLevel = function()
        local hero = GetLevelingUnit()
        local level = GetHeroLevel(hero)

        if level == 1 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 2 then
            UnitModifySkillPoints(hero, 0) -- 1
        elseif level == 3 then
            UnitModifySkillPoints(hero, 0) -- 1
        elseif level == 4 then
            UnitModifySkillPoints(hero, 1) -- 2
        elseif level == 5 then
            UnitModifySkillPoints(hero, 0) -- 1
        elseif level == 6 then
            UnitModifySkillPoints(hero, 2) -- 3
        elseif level == 7 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 8 then
            UnitModifySkillPoints(hero, 1)
        elseif level == 9 then
            UnitModifySkillPoints(hero, 0)
        elseif level == 10 then
            UnitModifySkillPoints(hero, 0)
        elseif level == 11 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 12 then
            UnitModifySkillPoints(hero, 2)
        elseif level == 13 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 14 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 15 then
            UnitModifySkillPoints(hero, 0)
        elseif level == 16 then
            UnitModifySkillPoints(hero, 0)
        elseif level == 17 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 18 then
            UnitModifySkillPoints(hero, 0)
        elseif level == 19 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 20 then
            UnitModifySkillPoints(hero, 0)
        elseif level == 21 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 22 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 23 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 24 then
            UnitModifySkillPoints(hero, 0)
        elseif level == 25 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 26 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 27 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 28 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 29 then
            UnitModifySkillPoints(hero, -1) -- empty
        elseif level == 30 then
            UnitModifySkillPoints(hero, 0)
        end
    end,

    initialize = function()
        SkillPoints.trigger = CreateTrigger()

        TriggerRegisterPlayerUnitEvent(SkillPoints.trigger, Player(0x02), EVENT_PLAYER_HERO_LEVEL, nil)
        TriggerRegisterPlayerUnitEvent(SkillPoints.trigger, Player(0x03), EVENT_PLAYER_HERO_LEVEL, nil)
        TriggerRegisterPlayerUnitEvent(SkillPoints.trigger, Player(0x04), EVENT_PLAYER_HERO_LEVEL, nil)
        TriggerRegisterPlayerUnitEvent(SkillPoints.trigger, Player(0x05), EVENT_PLAYER_HERO_LEVEL, nil)
        TriggerAddAction(SkillPoints.trigger, SkillPoints.onPlayerHeroLevel)
    end

}

TOC = {

    initialize = function()
        if BlzLoadTOCFile("UI\\FrameDef\\FrameDef.toc") then
            if DEBUG_MODE then
                print("|cFF00FF00DEBUG_MODE|r: the TOC library has been initialized.")
            end
        end
    end

}

--CUSTOM_CODE
function Trig_Standard_Script_Initialization_Actions()
end

function InitTrig_Standard_Script_Initialization()
    gg_trg_Standard_Script_Initialization = CreateTrigger()
    TriggerAddAction(gg_trg_Standard_Script_Initialization, Trig_Standard_Script_Initialization_Actions)
end

function InitCustomTriggers()
    InitTrig_Standard_Script_Initialization()
end

function RunInitializationTriggers()
    ConditionalTriggerExecute(gg_trg_Standard_Script_Initialization)
end

function InitCustomPlayerSlots()
    SetPlayerStartLocation(Player(0), 0)
    ForcePlayerStartLocation(Player(0), 0)
    SetPlayerColor(Player(0), ConvertPlayerColor(0))
    SetPlayerRacePreference(Player(0), RACE_PREF_ORC)
    SetPlayerRaceSelectable(Player(0), false)
    SetPlayerController(Player(0), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(1), 1)
    ForcePlayerStartLocation(Player(1), 1)
    SetPlayerColor(Player(1), ConvertPlayerColor(1))
    SetPlayerRacePreference(Player(1), RACE_PREF_ORC)
    SetPlayerRaceSelectable(Player(1), false)
    SetPlayerController(Player(1), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(2), 2)
    ForcePlayerStartLocation(Player(2), 2)
    SetPlayerColor(Player(2), ConvertPlayerColor(2))
    SetPlayerRacePreference(Player(2), RACE_PREF_ORC)
    SetPlayerRaceSelectable(Player(2), false)
    SetPlayerController(Player(2), MAP_CONTROL_USER)
end

function InitCustomTeams()
    SetPlayerTeam(Player(0), 0)
    SetPlayerState(Player(0), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(1), 0)
    SetPlayerState(Player(1), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerTeam(Player(2), 0)
    SetPlayerState(Player(2), PLAYER_STATE_ALLIED_VICTORY, 1)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(1), true)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateAllyBJ(Player(1), Player(0), true)
    SetPlayerAllianceStateAllyBJ(Player(1), Player(2), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(0), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(1), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(1), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(1), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(1), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(1), true)
end

function InitAllyPriorities()
    SetStartLocPrioCount(0, 2)
    SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(0, 1, 2, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(1, 2)
    SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(1, 1, 2, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(2, 2)
    SetStartLocPrio(2, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(2, 1, 1, MAP_LOC_PRIO_HIGH)
end

function main()
    SetCameraBounds(-1536.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -1536.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 1536.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 1536.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -1536.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 1536.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 1536.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -1536.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    NewSoundEnvironment("Default")
    SetAmbientDaySound("SunkenRuinsDay")
    SetAmbientNightSound("SunkenRuinsNight")
    SetMapMusic("Music", true, 0)
    InitBlizzard()
    InitGlobals()
    InitCustomTriggers()
    RunInitializationTriggers()
end

function config()
    SetMapName("TRIGSTR_008")
    SetMapDescription("TRIGSTR_010")
    SetPlayers(3)
    SetTeams(3)
    SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
    DefineStartLocation(0, 0.0, 0.0)
    DefineStartLocation(1, 0.0, 0.0)
    DefineStartLocation(2, 0.0, 0.0)
    InitCustomPlayerSlots()
    InitCustomTeams()
    InitAllyPriorities()
end

