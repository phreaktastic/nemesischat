-----------------------------------------------------
-- MIGRATION
-----------------------------------------------------
-- Model for orchestrating migrations.
-----------------------------------------------------

-----------------------------------------------------
-- Namespaces
-----------------------------------------------------
local _, core = ...;

NCMigration = {
    -- Unique string for checking if migration has been run.
    Identifier = "",

    -- Paths to erase from the database.
    PathsToErase = {},

    -- Function to execute when migration is run.
    Exec = nil,

    -- Maximum version of the addon that this migration is compatible with.
    LessThanVersion = nil,

    -- NCMigration (parent) ONLY, tracks all instantiated migrations.
    Migrations = {},

    -- Condition to check if migration should run (function, optional).
    Condition = nil,
}

function NCMigration:New(identifier, pathsToErase, exec)
    local migration = {
        identifier = identifier,
        pathsToErase = pathsToErase,
        exec = exec,
    }

    setmetatable(migration, self)
    self.__index = self

    table.insert(NCMigration.Migrations, migration)

    return migration
end

function NCMigration:AddPathToErase(path)
    table.insert(self.PathsToErase, path)

    return self
end

function NCMigration:SetExec(exec)
    self.Exec = exec

    return self
end

function NCMigration:SetLessThanVersion(maxVersion)
    self.LessThanVersion = maxVersion

    return self
end

function NCMigration:SetCondition(condition)
    if type(condition) ~= "function" then
        NemesisChat:Print("Migration condition must be a function.")
        return self
    end

    self.Condition = condition

    return self
end

function NCMigration:Run()
    if core.db.profile.migrations == nil then
        core.db.profile.migrations = {}
    end

    local total = #NCMigration.Migrations
    local count = 0

    for _, migration in pairs(NCMigration.Migrations) do
        if not core.db.profile.migrations[migration.identifier] and NCSemver:Less(migration.lessThanVersion) and (not migration.Condition or (migration.Condition and migration.Condition())) then
            if migration.pathsToErase then
                for _, path in pairs(migration.pathsToErase) do
                    if string.find(path, "core.db.profile") ~= nil then
                        path = string.gsub(path, "core.db.profile.", "")
                    end
                    
                    local pathChunks = Split(path, ".")
                    local table = core.db.profile

                    for i = 1, #pathChunks - 1 do
                        table = table[pathChunks[i]]

                        if table == nil then
                            break
                        end
                    end

                    table[pathChunks[#pathChunks]] = nil
                end
            end

            if migration.exec then
                migration.exec()
            end

            core.db.profile.migrations[migration.identifier] = true

            count = count + 1
        end
    end

    if count > 0 then
        NemesisChat:Print("Ran", NCColors.Emphasize(count), "migrations.")
    end

    NemesisChat:Print("Migrations complete. Checked:", total, "Ran:", count)
end