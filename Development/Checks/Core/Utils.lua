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

return Utils
