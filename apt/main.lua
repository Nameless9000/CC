-- apt by Nameless#9000
local tArgs = { ... }

if not http then
    printError( "apt requires http API" )
    printError( "Set http_enable to true in ComputerCraft.cfg" )
    return
end

--functions

local function get(url)
    --write( "Connecting to server... " )
    local response = http.get(
        "https://raw.githubusercontent.com/Nameless9000/CC/master/apt/"..textutils.urlEncode( url )
    )

    if response then
        --print( "Success." )

        local sResponse = response.readAll()
        response.close()
        return sResponse
    else
        printError( "Failed." )
    end
end

local function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
           if s ~= 1 or cap ~= "" then
          table.insert(Table,cap)
           end
           last_end = e+1
           s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
           cap = pString:sub(last_end)
           table.insert(Table, cap)
    end
    return Table
 end

-- main

if #tArgs ~= 1 then
  print("Usage: apt <mode>")
  return
end
local mode = tArgs[1]

if mode == "help" or "-h" or "--help" then
    print([[
    Modes:\n 
        help\n
        install\n
        list\n
    ]])
    return
end

if mode == "list" or "-l" or "--list" then
    local raw = get("p.list")
    local programs = split(raw,"|")
    local sh = [[
    Programs:\n

    ]]
    for _,pr in pairs(programs) do
        sh=sh..pr.."\n  "
    end
    print(sh)
    return
end

if mode == "install" or "-i" or "--install" then

    if #tArgs ~= 3 then
        print("Usage: apt install <program> <location>")
        return
    end

    local program = tArgs[2]
    local location = tArgs[3]
    local sPath = shell.resolve( location )

    local res = get("p/"..program.."/main.lua")
    if res then
        local file = fs.open( sPath, "w" )
        file.write( res )
        file.close()

        print( "Downloaded as "..location )
    end

    return
end