local Utils = {}

-- String manipulation
function Utils.splitString(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function Utils.trim(s)
    return s:match("^%s*(.-)%s*$")
end

function Utils.cleanLine(line, options)
    options = options or {
        removeComments = true,
        removeDoubleQuotes = true,
        removeSingleQuotes = true
    }

    local clean_line = line
    if options.removeComments then
        clean_line = clean_line:gsub("%-%-.*", "")
    end
    if options.removeDoubleQuotes then
        clean_line = clean_line:gsub([["(.-)"]], "")
    end
    if options.removeSingleQuotes then
        clean_line = clean_line:gsub([['(.-)']], "")
    end
    return clean_line
end

-- File operations
function Utils.readFile(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

-- Path manipulation
function Utils.normalizePath(path)
    return path:gsub("^%./", ""):gsub("\\", "/")
end

function Utils.findMatchingFiles(dir, pattern)
    local matches = {}
    for file in lfs.dir(dir) do
        if file:match("Check%.lua$") and file:lower():match(pattern:lower()) then
            table.insert(matches, file:match("(.+)%.lua$"))
        end
    end
    return matches
end

function Utils.resolveCheckName(checksDir, checkName)
    local matches = Utils.findMatchingFiles(checksDir, checkName)

    if #matches == 0 then
        print("No matching check files found for: " .. checkName)
        return nil
    elseif #matches == 1 then
        return matches[1]
    else
        print("Multiple matching check files found for '" .. checkName .. "':")
        for _, match in ipairs(matches) do
            print("  - " .. match)
        end
        return nil
    end
end

function Utils.shouldExcludeLine(check, full_path, line_number)
    if not check.exclusions then return false end

    local relative_path = full_path:gsub("^%./", ""):gsub("\\", "/")

    for _, exclusion in ipairs(check.exclusions) do
        local exclude_file, exclude_lines = exclusion:match("([^:]+):(.+)")
        if exclude_file and exclude_lines then
            if relative_path:match(exclude_file .. "$") then
                for line in exclude_lines:gmatch("([^,]+)") do
                    if tonumber(Utils.trim(line)) == line_number then
                        return true
                    end
                end
            end
        elseif relative_path:match(exclusion .. "$") then
            return true
        end
    end
    return false
end

return Utils
