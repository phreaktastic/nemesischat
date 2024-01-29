-----------------------------------------------------
-- SEMVER
-----------------------------------------------------
-- Semantic versioning model for quick comparisons
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

NCSemver = {
    major = "0",
    minor = "0",
    patch = "0",
    numeric = 0,
}

function NCSemver:GetChunks(semVer)
    local chunks = Split(semVer, ".")

    return string.format("%03d", chunks[1]), string.format("%03d", chunks[2]), string.format("%03d", chunks[3])
end

function NCSemver:New(semVer)
    local major, minor, patch = NCSemver:GetChunks(semVer)

    local semVer = {
        major = major,
        minor = minor,
        patch = patch,
        numeric = tonumber(major .. minor .. patch),
    }

    setmetatable(semVer, self)
    self.__index = self

    return semVer
end

function NCSemver:Greater(semVer)
    if semVer == nil then
        return true
    end

    if type(semVer) == "string" then
        semVer = NCSemver:New(semVer)
    end

    return self.numeric > semVer.numeric
end

function NCSemver:Less(semVer)
    if semVer == nil then
        return true
    end

    if type(semVer) == "string" then
        semVer = NCSemver:New(semVer)
    end

    return self.numeric < semVer.numeric
end

function NCSemver:Equal(semVer)
    if semVer == nil then
        return false
    end

    if type(semVer) == "string" then
        semVer = NCSemver:New(semVer)
    end

    return self.numeric == semVer.numeric
end

NCSemver.major, NCSemver.minor, NCSemver.patch = NCSemver:GetChunks(core.version)
NCSemver.numeric = tonumber(NCSemver.major .. NCSemver.minor .. NCSemver.patch)