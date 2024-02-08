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
    identifier = "",

    -- Paths to erase from the database.
    pathsToErase = {},

    -- Function to execute when migration is run.
    exec = nil,

    -- Maximum version of the addon that this migration is compatible with.
    lessThanVersion = nil,

    -- NCMigration (parent) ONLY, tracks all instantiated migrations.
    migrations = {},
}

function NCMigration:New(identifier, pathsToErase, exec)
    local migration = {
        identifier = identifier,
        pathsToErase = pathsToErase,
        exec = exec,
    }

    setmetatable(migration, self)
    self.__index = self

    table.insert(NCMigration.migrations, migration)

    return migration
end

function NCMigration:AddPathToErase(path)
    table.insert(self.pathsToErase, path)

    return self
end

function NCMigration:SetExec(exec)
    self.exec = exec

    return self
end

function NCMigration:SetLessThanVersion(maxVersion)
    self.lessThanVersion = maxVersion

    return self
end

function NCMigration:Run()
    if core.db.profile.migrations == nil then
        core.db.profile.migrations = {}
    end

    local total = #NCMigration.migrations
    local count = 0

    for _, migration in pairs(NCMigration.migrations) do
        if not core.db.profile.migrations[migration.identifier] and NCSemver:Less(migration.lessThanVersion) then
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