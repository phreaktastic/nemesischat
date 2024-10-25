-----------------------------------------------------
-- Group Finder Filter Settings Configuration
-----------------------------------------------------
local _, core = ...;

local classTable = select(3, GetClassTable(true, true))
local specTable = select(3, GetSpecTable(true, true))

core.options.args.dungeonGroup.args.lfgTools.args.filterSettings = {
    order = 3,
    type = "group",
    name = "Applicant Filters",
    args = {
        realms = {
            order = 1,
            type = "group",
            name = "Realm Filters",
            inline = true,
            args = {
                allowed = {
                    order = 1,
                    type = "input",
                    name = "Allowed Realms",
                    desc = "Enter realm names separated by commas. Leave empty to allow all realms.",
                    width = "full",
                    get = function()
                        local realms = NCConfig:GetAllowedRealms()
                        return realms and table.concat(realms, ", ") or ""
                    end,
                    set = function(_, value)
                        local realms = { strsplit(",", value) }
                        for i, realm in ipairs(realms) do realms[i] = strtrim(realm) end
                        NCConfig:SetAllowedRealms(realms)
                    end,
                },
                ignored = {
                    order = 2,
                    type = "input",
                    name = "Ignored Realms",
                    desc = "Enter realm names separated by commas. These realms will be filtered out.",
                    width = "full",
                    get = function()
                        local realms = NCConfig:GetIgnoredRealms()
                        return realms and table.concat(realms, ", ") or ""
                    end,
                    set = function(_, value)
                        local realms = { strsplit(",", value) }
                        for i, realm in ipairs(realms) do realms[i] = strtrim(realm) end
                        NCConfig:SetIgnoredRealms(realms)
                    end,
                },
            }
        },
        classes = {
            order = 2,
            type = "group",
            name = "Class Filters",
            inline = true,
            args = {
                description = {
                    order = 1,
                    type = "description",
                    fontSize = "medium",
                    name = "Filter applicants based on their class:",
                },
                allowed = {
                    order = 2,
                    type = "multiselect",
                    name = "Allowed Classes",
                    desc = "Select classes to allow. If none are selected, all classes are allowed.",
                    values = classTable,
                    width = "full",
                    get = function(_, key)
                        local list = NCConfig:GetAllowedClasses()
                        return list and tContains(list, key) or false
                    end,
                    set = function(_, key, value)
                        local list = NCConfig:GetAllowedClasses() or {}
                        if value then
                            tinsert(list, key)
                        else
                            tDeleteItem(list, key)
                        end
                        NCConfig:SetAllowedClasses(list)
                    end,
                },
                ignored = {
                    order = 3,
                    type = "multiselect",
                    name = "Ignored Classes",
                    desc = "Select classes to ignore. These classes will be filtered out.",
                    values = classTable,
                    width = "full",
                    get = function(_, key)
                        local list = NCConfig:GetIgnoredClasses()
                        return list and tContains(list, key) or false
                    end,
                    set = function(_, key, value)
                        local list = NCConfig:GetIgnoredClasses() or {}
                        if value then
                            tinsert(list, key)
                        else
                            tDeleteItem(list, key)
                        end
                        NCConfig:SetIgnoredClasses(list)
                    end,
                },
            }
        },
        specs = {
            order = 3,
            type = "group",
            name = "Specialization Filters",
            inline = true,
            args = {
                description = {
                    order = 1,
                    type = "description",
                    fontSize = "medium",
                    name = "Filter applicants based on their specialization:",
                },
                allowed = {
                    order = 2,
                    type = "multiselect",
                    name = "Allowed Specs",
                    desc = "Select specs to allow. If none are selected, all specs are allowed.",
                    values = specTable,
                    width = "full",
                    get = function(_, key)
                        local list = NCConfig:GetAllowedSpecs()
                        return list and tContains(list, key) or false
                    end,
                    set = function(_, key, value)
                        local list = NCConfig:GetAllowedSpecs() or {}
                        if value then
                            tinsert(list, key)
                        else
                            tDeleteItem(list, key)
                        end
                        NCConfig:SetAllowedSpecs(list)
                    end,
                },
                ignored = {
                    order = 3,
                    type = "multiselect",
                    name = "Ignored Specs",
                    desc = "Select specs to ignore. These specs will be filtered out.",
                    values = specTable,
                    width = "full",
                    get = function(_, key)
                        local list = NCConfig:GetIgnoredSpecs()
                        return list and tContains(list, key) or false
                    end,
                    set = function(_, key, value)
                        local list = NCConfig:GetIgnoredSpecs() or {}
                        if value then
                            tinsert(list, key)
                        else
                            tDeleteItem(list, key)
                        end
                        NCConfig:SetIgnoredSpecs(list)
                    end,
                },
            }
        },
        notifications = {
            order = 4,
            type = "group",
            name = "Filter Notifications",
            inline = true,
            args = {
                popupForDeclining = {
                    order = 1,
                    type = "toggle",
                    name = "Show Decline Popup",
                    desc = "Display a popup when an applicant is filtered, allowing you to decline their application.",
                    width = "full",
                    get = function() return NCConfig:IsPopupOnIgnoredApplicants() end,
                    set = function() NCConfig:TogglePopupOnIgnoredApplicants() end,
                }
            }
        }
    }
}
