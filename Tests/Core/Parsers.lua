-- Function to parse the .toc file and extract Lua files
function ParseTOCFile(addonRoot)
    local tocFileName = "NemesisChat.toc"
    local tocFilePath = addonRoot .. tocFileName
    local luaFiles = {}
    local file = io.open(tocFilePath, "r")
    if not file then
        error("Cannot open .toc file: " .. tocFilePath)
    end

    for line in file:lines() do
        line = line:match("^%s*(.-)%s*$") -- Trim whitespace
        if line ~= "" and not line:match("^#") then
            if line:match("^##") then
                -- Handle directives if needed
            else
                if line:match("%.lua$") then
                    -- Lua file, add to list
                    local fullPath = addonRoot .. line
                    table.insert(luaFiles, fullPath)
                elseif line:match("%.xml$") then
                    -- XML file, process it
                    local xmlFilePath = addonRoot .. line
                    ParseXMLFile(xmlFilePath, luaFiles)
                end
            end
        end
    end

    file:close()
    return luaFiles
end

-- Function to parse an XML file and extract Lua files
function ParseXMLFile(xmlFilePath, luaFiles, processedFiles)
    processedFiles = processedFiles or {}
    if processedFiles[xmlFilePath] then
        return
    end
    processedFiles[xmlFilePath] = true

    print("Parsing XML file: " .. xmlFilePath)
    local file = io.open(xmlFilePath, "r")
    if not file then
        -- error("Cannot open XML file: " .. xmlFilePath)
        return
    end

    -- Get the directory of the XML file
    local xmlDir = xmlFilePath:match("(.*/)") or "./"

    for line in file:lines() do
        line = line:match("^%s*(.-)%s*$") -- Trim whitespace
        if line ~= "" then
            -- Check for <Include> elements
            local includeFile = line:match('<Include.-file="(.-)"')
            if includeFile then
                includeFile = includeFile:gsub("\\", "/") -- Normalize path
                local fullPath = xmlDir .. includeFile
                if includeFile:match("%.xml$") then
                    -- Recursively parse included XML files
                    ParseXMLFile(fullPath, luaFiles, processedFiles)
                elseif includeFile:match("%.lua$") then
                    table.insert(luaFiles, fullPath)
                end
            end

            -- Check for <Script> elements
            local scriptFile = line:match('<Script.-file="(.-)"')
            if scriptFile then
                scriptFile = scriptFile:gsub("\\", "/") -- Normalize path
                local fullPath = xmlDir .. scriptFile
                if scriptFile:match("%.lua$") then
                    table.insert(luaFiles, fullPath)
                end
            end
        end
    end

    file:close()
end

return {
    ParseXMLFile = ParseXMLFile,
    ParseTOCFile = ParseTOCFile,
}
