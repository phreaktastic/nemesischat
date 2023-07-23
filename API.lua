-----------------------------------------------------
-- API
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

-----------------------------------------------------
-- API model for interfacing with other addons
-----------------------------------------------------

NemesisChatAPI = {}

function NemesisChatAPI:AddAPI(name, friendlyName)
    if not core.apis then
        core.apis = {}
    end

    -- Instantiate a structured object for the API
    core.apis[name] = DeepCopy(core.runtimeDefaults.ncApi)

    core.apis[name].friendlyName = friendlyName

    -- Add callable functions to the individual API for ease of use
    core.apis[name].AddConfigOption = function(self, configOption)
        NemesisChatAPI:AddConfigOption(name, configOption)

        return self
    end

    core.apis[name].AddCompatibilityCheck = function(self, func)
        NemesisChatAPI:AddCompatibilityCheck(name, func)

        return self
    end

    core.apis[name].AddPreMessageHook = function(self, func)
        NemesisChatAPI:AddPreMessageHook(name, func)

        return self
    end

    core.apis[name].AddPostMessageHook = function(self, func)
        NemesisChatAPI:AddPostMessageHook(name, func)

        return self
    end

    core.apis[name].AddSubject = function(self, subject)
        NemesisChatAPI:AddSubject(name, subject)

        self.subjectMethods[subject.value] = subject.exec

        return self
    end

    core.apis[name].AddOperator = function(self, operator)
        NemesisChatAPI:AddOperator(name, operator)

        return self
    end

    core.apis[name].AddReplacement = function(self, replacement)
        NemesisChatAPI:AddReplacement(name, replacement)

        self.replacementMethods[replacement.value] = replacement.exec

        return self
    end

    -- This checks if the API can be enabled
    core.apis[name].CheckConfigCompatibility = function(self)
        local checks = NemesisChatAPI:GetCompatibilityChecks(name)

        if not checks then
            return true
        end

        for _, check in pairs(checks) do
            if not check.configCheck then
                local success, message = check.exec()

                if not success then
                    return false, message
                end
            end
        end

        return true
    end

    -- This checks if the API can be ran / referenced
    core.apis[name].CheckRunCompatibility = function(self)
        local checks = NemesisChatAPI:GetCompatibilityChecks(name)

        if not checks then
            return true
        end

        for _, check in pairs(checks) do
            if check.configCheck then
                local success, message = check.exec()

                if not success then
                    return false, message
                end
            end
        end

        return true
    end

    core.apis[name].IsEnabled = function(self)
        for _, configOption in pairs(core.apis[name].configOptions) do
            if configOption.primary then
                return core.db.profile.API[name .. "_" .. configOption.value]
            end
        end

        return false
    end

    return core.apis[name]
end

function NemesisChatAPI:GetAPI(name)
    if not core.apis then
        return nil
    end

    return core.apis[name]
end

function NemesisChatAPI:RemoveAPI(name)
    if not core.apis then
        return
    end

    core.apis[name] = nil

    return NemesisChatAPI
end

function NemesisChatAPI:HasAPI(name)
    if not core.apis then
        return false
    end

    return core.apis[name] ~= nil
end

function NemesisChatAPI:GetFriendlyName(name)
    return core.apis[name].friendlyName
end

function NemesisChatAPI:AddConfigOption(name, configOption)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    if not configOption.label or not configOption.value then
        return
    end

    if not core.apis[name].configOptions then
        core.apis[name].configOptions = {}
    end

    table.insert(core.apis[name].configOptions, configOption)

    return NemesisChatAPI
end

function NemesisChatAPI:GetConfigOptions(name)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    return core.apis[name].configOptions
end

function NemesisChatAPI:AddCompatibilityCheck(name, func)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    table.insert(core.apis[name].compatibilityChecks, func)

    return NemesisChatAPI
end

function NemesisChatAPI:GetCompatibilityChecks(name)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    return core.apis[name].compatibilityChecks
end

function NemesisChatAPI:AddPreMessageHook(name, func)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    if not core.apis[name].preMessageHooks then
        core.apis[name].preMessageHooks = {}
    end

    table.insert(core.apis[name].preMessageHooks, func)

    return NemesisChatAPI
end

function NemesisChatAPI:GetPreMessageHooks(name)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    return core.apis[name].preMessageHooks
end

function NemesisChatAPI:AddPostMessageHook(name, func)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    if not core.apis[name].postMessageHooks then
        core.apis[name].postMessageHooks = {}
    end

    table.insert(core.apis[name].postMessageHooks, func)

    return NemesisChatAPI
end

function NemesisChatAPI:GetPostMessageHooks(name)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    return core.apis[name].postMessageHooks
end

function NemesisChatAPI:AddSubject(name, subject)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    if not subject.label or not subject.value or not subject.exec or not subject.operators or not subject.type then
        return
    end

    if not core.apis[name].subjects then
        core.apis[name].subjects = {}
    end

    table.insert(core.apis[name].subjects, subject)

    return NemesisChatAPI
end

function NemesisChatAPI:GetSubjects(name)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    return core.apis[name].subjects
end

function NemesisChatAPI:AddOperator(name, operator)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    if not operator.label or not operator.value or not operator.exec then
        return
    end

    if not core.apis[name].operators then
        core.apis[name].operators = {}
    end

    table.insert(core.apis[name].operators, operator)

    return NemesisChatAPI
end

function NemesisChatAPI:GetOperators(name)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    return core.apis[name].operators
end

function NemesisChatAPI:AddReplacement(name, replacement)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    if not replacement.value or not replacement.exec then
        return
    end

    if not core.apis[name].replacements then
        core.apis[name].replacements = {}
    end

    table.insert(core.apis[name].replacements, replacement)
    return NemesisChatAPI
end

function NemesisChatAPI:GetReplacements(name)
    if not NemesisChatAPI:HasAPI(name) then
        return
    end

    return core.apis[name].replacements
end

function NemesisChatAPI:GetAPIConfigOptions()
    local configOptions = {}
    local configOrder = 0
    local refText = {}
    local refTextOrder = 2
    local refGroupOrder = 1
    local subjects = {}
    local numericReplacements = {}

    for name, api in pairs(core.apis) do
        if api.configOptions then
            local success, message = core.apis[name]:CheckConfigCompatibility()

            for _, configOption in pairs(api.configOptions) do
                configOptions[name .. "_" .. configOption.value] = {
                    order = configOrder,
                    type = "toggle",
                    name = configOption.label,
                    get = function() return core.db.profile.API[name .. "_" .. configOption.value] end,
                    set = function(_, value) core.db.profile.API[name .. "_" .. configOption.value] = value end,
                    disabled = function() return not success end,
                }

                if configOption.description then
                    if success then
                        configOptions[name .. "_" .. configOption.value].desc = configOption.description
                    else
                        configOptions[name .. "_" .. configOption.value].desc = message
                    end
                end

                configOrder = configOrder + 1
            end
        end

        if api.replacements then
            local shouldAdd = false
            local groupItems = {}

            for _, replacement in pairs(api.replacements) do
                if replacement.label and replacement.description then
                    groupItems[replacement.value] = {
                        order = refTextOrder,
                        type = "description",
                        fontSize = "medium",
                        name = "|c00ffcc00[" .. replacement.value .. "]|r: " .. replacement.description,
                    }

                    refTextOrder = refTextOrder + 1
                    shouldAdd = true

                    if replacement.isNumeric then
                        numericReplacements["[" .. replacement.value .. "]"] = 1
                    end
                end
            end

            if shouldAdd then
                local replacementHeader = {
                    header ={
                        order = 0,
                        type = "description",
                        fontSize = "large",
                        name = "Text Replacements - " .. api.friendlyName,
                    },
                    headerPadding = {
                        order = 1,
                        type = "description",
                        fontSize = "large",
                        name = " ",
                    }
                }

                refText[name] = {
                    order = refGroupOrder,
                    type = "group",
                    name = api.friendlyName,
                    inline = true,
                    args = MapMerge(replacementHeader, groupItems),
                }

                refGroupOrder = refGroupOrder + 1
            end

            refTextOrder = 2
        end

        if api.subjects then
            for _, subject in pairs(api.subjects) do
                table.insert(subjects, subject)
            end
        end
    end

    return configOptions, refText, subjects, numericReplacements
end

function NemesisChatAPI:SetAPIConfigOptions()
    local options, references, subjects, numericReplacements = NemesisChatAPI:GetAPIConfigOptions()

    core.apiConfigOptions = DeepCopy(options)
    core.options.args.generalGroup.args.apis.args = DeepCopy(options)

    references.coreReplacements = DeepCopy(core.options.args.referenceGroup.args.textReplacements.args.coreReplacements)
    core.options.args.referenceGroup.args.textReplacements.args = DeepCopy(references)

    for i, subject in pairs(subjects) do
        table.insert(core.messageConditions, DeepCopy(subject))
    end

    core.numericReplacements = MapMerge(core.numericReplacementsCore, numericReplacements)
end

function NemesisChatAPI:InitPreMessage()
    if not core.apis or type(core.apis) ~= "table" then
        return
    end

    for name, api in pairs(core.apis) do
        local isCompatible = true

        for _, check in pairs(api.compatibilityChecks) do
            local success, message = check.exec()

            if not success then
                if not check.configCheck then
                    NemesisChat:Print(api.friendlyName .. " compatibility check FAILED: " .. message)
                end
                
                isCompatible = false
                break
            end
        end

        if isCompatible then
            for _, hook in pairs(api.preMessageHooks) do
                hook()
            end
    
            for _, replacement in pairs(api.replacements) do
                NCMessage:AddCustomReplacement("%[" .. replacement.value .. "%]", replacement.exec)
            end
        end
    end
end

function NemesisChatAPI:InitPostMessage()
    if not core.apis or type(core.apis) ~= "table" then
        return
    end

    for name, api in pairs(core.apis) do
        for _, hook in pairs(api.postMessageHooks) do
            hook()
        end
    end
end
