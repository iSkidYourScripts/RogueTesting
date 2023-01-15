if getgenv().Rogue_AlreadyLoaded ~= nil then error("Rogue Hub was already found running or you have other scripts executed!") return else getgenv().Rogue_AlreadyLoaded = 0 end

getgenv().isLoaded = false
getgenv().lastTick = tick()

local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://1548304764"
sound.PlayOnRemove = true
sound.Volume = 0.5

function CheckConfigFile()
    if not isfile("/Rogue Hub/Configs/Keybind.ROGUEHUB") then return Enum.KeyCode.RightControl else return Enum.KeyCode[game:GetService("HttpService"):JSONDecode(readfile("/Rogue Hub/Configs/Keybind.ROGUEHUB"))["Key"]] or Enum.KeyCode.RightControl end
end

local Config = {
    WindowName = "Rogue Hub | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Countryball World",
    Color = Color3.fromRGB(201,144,150),
    Keybind = CheckConfigFile()
}

local localPlr = game:GetService("Players").LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kitzoon/Rogue-Hub/main/Libs/BracketV3.lua"))()
local notifLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kitzoon/Rogue-Hub/main/Libs/Notifications.lua"))()

local window = library:CreateWindow(Config, game:GetService("CoreGui"))
local mainTab = window:CreateTab("Countryball World")

getgenv().settings = {
    walkSpeed = 20,
    walkSpeedTog = false,
    jumpPowerTog = false,
    jumpPower = 60,
    fly = false,
    moneyAmount = 0,
    
    -- TROLLING

    rpName = "",
    changeRPNames = false,

    -- THEMES
    theme = "Default",
    color = Color3.fromRGB(201, 144, 150)
}

if makefolder and isfolder and not isfolder("Rogue Hub") then
    makefolder("Rogue Hub")
    
    makefolder("Rogue Hub/Configs")
    makefolder("Rogue Hub/Data")
end

if readfile and isfile and isfile("Rogue Hub/Configs/CountryRP_Config.ROGUEHUB") then
    getgenv().settings = game:GetService("HttpService"):JSONDecode(readfile("Rogue Hub/Configs/CountryRP_Config.ROGUEHUB"))
end

local function saveSettings()
    if writefile then
        writefile("Rogue Hub/Configs/CountryRP_Config.ROGUEHUB", game:GetService("HttpService"):JSONEncode(getgenv().settings))
    end
end

-- Movement

local plrSec = mainTab:CreateSection("Movement")

local togspeed = plrSec:CreateToggle("Walk Speed", getgenv().settings.walkSpeedTog or false, function(bool)
    getgenv().settings.walkSpeedTog = bool
    saveSettings()
    
    if getgenv().settings.walkSpeedTog then
        localPlr.Character.Humanoid.WalkSpeed = getgenv().settings.walkSpeed
    else
        localPlr.Character.Humanoid.WalkSpeed = 20
    end
end)

togspeed:AddToolTip("Toggles between the default walkspeed and your set walkspeed.")

local wsSlider = plrSec:CreateSlider("Walk Speed", 20,300,getgenv().settings.walkSpeed or 20,true, function(value)
	getgenv().settings.walkSpeed = value
    saveSettings()
    
    if getgenv().settings.walkSpeedTog then
        localPlr.Character.Humanoid.WalkSpeed = getgenv().settings.walkSpeed
    else
        localPlr.Character.Humanoid.WalkSpeed = 20
    end
end)

wsSlider:AddToolTip("Change your humanoid's WalkSpeed value.")

local jumpPowerTog = plrSec:CreateToggle("Jump Power", getgenv().settings.jumpPowerTog or false, function(bool)
    getgenv().settings.jumpPowerTog = bool
    saveSettings()
    if getgenv().settings.jumpPowerTog then
        localPlr.Character.Humanoid.JumpPower = getgenv().settings.jumpPower
        localPlr.Character.Humanoid.UseJumpPower = true
    else
        localPlr.Character.Humanoid.JumpPower = 50
        localPlr.Character.Humanoid.UseJumpPower = true
    end
end)

jumpPowerTog:AddToolTip("Toggles between the default jump power and your set jump power.")

local jpSlider = plrSec:CreateSlider("Jump Power", 50,120,getgenv().settings.jumpPower or 50,true, function(value)
	getgenv().settings.jumpPower = value
    saveSettings()
    
    if getgenv().settings.jumpPowerTog then
        localPlr.Character.Humanoid.JumpPower = getgenv().settings.jumpPower
        localPlr.Character.Humanoid.UseJumpPower = true
    else
        localPlr.Character.Humanoid.JumpPower = 50
        localPlr.Character.Humanoid.UseJumpPower = true
    end
end)

jpSlider:AddToolTip("Change your humanoid's Jump Power value.")

local flyTog = plrSec:CreateToggle("Player Fly", false, function(bool)
    getgenv().settings.fly = bool
    
    if getgenv().settings.fly then
        -- Credit to Adonis Admin (old)
        repeat wait()
        until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:findFirstChild("Torso") and game.Players.LocalPlayer.Character:findFirstChild("Humanoid")
        local mouse = game.Players.LocalPlayer:GetMouse()
        repeat wait() until mouse
        local plr = game.Players.LocalPlayer
        local torso = plr.Character.Torso
        local flying = getgenv().settings.fly
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 50
    
        function Fly()
            local bg = Instance.new("BodyGyro", torso)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = torso.CFrame
            local bv = Instance.new("BodyVelocity", torso)
            bv.velocity = Vector3.new(0,0.1,0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            repeat wait()
                plr.Character.Humanoid.PlatformStand = true
                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed+.5+(speed/maxspeed)
                    if speed > maxspeed then
                        speed = maxspeed
                    end
                -- elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                --     speed = speed-1
                --     if speed < 0 then
                --         speed = 0
                --     end
                end
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                else
                    bv.velocity = Vector3.new(0,0.1,0)
                end
                bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
            until not flying
            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            speed = 0
            bg:Destroy()
            bv:Destroy()
            plr.Character.Humanoid.PlatformStand = false
        end
        mouse.KeyDown:connect(function(key)
            if key:lower() == "e" then
                if flying then flying = false
                else
                    flying = true
                    Fly()
                end
            elseif key:lower() == "w" then
                ctrl.f = 1
            elseif key:lower() == "s" then
                ctrl.b = -1
            elseif key:lower() == "a" then
                ctrl.l = -1
            elseif key:lower() == "d" then
                ctrl.r = 1
            end
        end)
        mouse.KeyUp:connect(function(key)
            if key:lower() == "w" then
                ctrl.f = 0
            elseif key:lower() == "s" then
                ctrl.b = 0
            elseif key:lower() == "a" then
                ctrl.l = 0
            elseif key:lower() == "d" then
                ctrl.r = 0
            end
        end)
        Fly()
    end
end)

flyTog:AddToolTip("Allows you to fly around the map.")

-- Teleports

local tpSec = mainTab:CreateSection("Teleports")
local tpDrop = tpSec:CreateDropdown("Destination", {"City Spawn", "Lighthouse", "Shipment", "Campgrounds"}, function(option)
    if option == "City Spawn" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.TPLocations.CityTP.CFrame
    end
    if option == "Lighthouse" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.TPLocations.LighthouseTP.CFrame
    end
    if option == "Shipment" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.TPLocations.PortTP.CFrame
    end
    if option == "Campgrounds" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.TPLocations.CampTP.CFrame
    end
end)

tpDrop:AddToolTip("Select a destination to travel across the map to that location instantly.")

-- Currency
local curSec = mainTab:CreateSection('Currency')

local amountOfMoney = curSec:CreateTextBox("Amount", "Enter Amount", false, function(str)
    getgenv().settings.moneyAmount = str
end)

local setMoney = curSec:CreateButton("Set Money", function()
    game:GetService("Players").LocalPlayer.leaderstats.Money.Value = getgenv().settings.moneyAmount
end)

setMoney:AddToolTip("Gives you the amount of money specified.")

local infmoney = curSec:CreateButton("Infinite Money", function()
    -- The game handles prices on the client. (edit from kitzoon: math.huge sets your money to 0 for some reason)
    game:GetService("Players").LocalPlayer.leaderstats.Money.Value = 99999999999999999
end)

infmoney:AddToolTip("Gives you unlimited in-game money.")

-- Items

local itemSec = mainTab:CreateSection("Items")
local btools = itemSec:CreateButton("F3X Building Tools", function()
    local args = {
        [1] = game:GetService("ReplicatedStorage").Tools.Btools,
        [2] = game:GetService("ReplicatedStorage").Tools.Burger.Cost
    }
    
    game:GetService("ReplicatedStorage").BuyTool:InvokeServer(unpack(args))
end)

btools:AddToolTip("Gives you F3X Building Tools that work Serverside. (Must afford Burger)")

local bucket = itemSec:CreateButton("Paint Bucket", function()
    local args = {
        [1] = game:GetService("ReplicatedStorage").Tools.Paint,
        [2] = game:GetService("ReplicatedStorage").Tools.Burger.Cost
    }
    
    game:GetService("ReplicatedStorage").BuyTool:InvokeServer(unpack(args))
    
end)

bucket:AddToolTip("Gives you the Paint Bucket tool, and works Serverside. (Must afford Burger)")

local weapon = itemSec:CreateButton("M16A1 Weapon", function()
    local args = {
        [1] = game:GetService("ReplicatedStorage").Tools.M16A1,
        [2] = game:GetService("ReplicatedStorage").Tools.Burger.Cost
    }
    
    game:GetService("ReplicatedStorage").BuyTool:InvokeServer(unpack(args))
    
    
end)

weapon:AddToolTip("Gives you an M16A1, works Serverside. (Must afford Burger)")

local boombox = itemSec:CreateButton("Free Boombox", function()
    local args = {
        [1] = game:GetService("ReplicatedStorage").Tools.Boombox,
        [2] = game:GetService("ReplicatedStorage").Tools.Burger.Cost
    }
    
    game:GetService("ReplicatedStorage").BuyTool:InvokeServer(unpack(args))
end)

boombox:AddToolTip("Gives you a free Boombox, works Serverside, and everyone can hear it. (Must afford Burger)")

-- Trolling

local trollingSec = mainTab:CreateSection("Trolling")

local displayBox = trollingSec:CreateTextBox("Roleplay Name", "Enter Text", false, function(String)
    getgenv().settings.rpName = String
    saveSettings()
end)

displayBox:SetValue(getgenv().settings.rpName or "")
displayBox:AddToolTip("Sets the text to change everyone's roleplay name.")

local activateRP = trollingSec:CreateToggle("Change RP Names", false, function(v)
    getgenv().settings.changeRPNames = v
end)

activateRP:AddToolTip("Changes everyone's roleplay name to whatever is in the textbox.")

-- Extra

local infoTab = window:CreateTab("Extra")
local uiSec = infoTab:CreateSection("UI Settings")

local uiColor = uiSec:CreateColorpicker("UI Color", function(color)
	window:ChangeColor(color)
    getgenv().settings.color = color
end)

uiColor:UpdateColor(Config.Color)

local uiTog = uiSec:CreateToggle("UI Toggle", nil, function(bool)
	window:Toggle(bool)
end)

uiTog:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(key)
	if key == "Escape" or key == "Backspace" then key = "NONE" end
	
    if key == "NONE" then return else Config.Keybind = Enum.KeyCode[key]; writefile("/Rogue Hub/Configs/Keybind.ROGUEHUB", game:GetService("HttpService"):JSONEncode({Key = key})) end
end)

uiTog:SetState(true)

local uiRainbow = uiSec:CreateToggle("Rainbow UI", nil, function(bool)
	getgenv().rainbowUI = bool
    
    while getgenv().rainbowUI and task.wait() do
        local hue = tick() % 10 / 10
        local rainbow = Color3.fromHSV(hue, 1, 1)
            
        window:ChangeColor(rainbow)
        uiColor:UpdateColor(rainbow)
    end
end)

local infoSec = infoTab:CreateSection("Credits")

local req = http_request or request or syn.request

infoSec:CreateButton("Founder of Rogue Hub: Kitzoon#7750", function()
    setclipboard("Kitzoon#7750")

    notifLib:Notification("Copied Kitzoon's discord username and tag to your clipboard.", 5)
end)

infoSec:CreateButton("Rogue Hub Plus: StoneNicolas93#0001", function()
    setclipboard("StoneNicolas93#0001")

    notifLib:Notification("Copied StoneNicolas discord username and tag to your clipboard.", 5)
end)

infoSec:CreateButton("Help with a lot: Kyron#6083", function()
    setclipboard("Kyron#6083")
    
    notifLib:Notification("Copied Kyron's discord username and tag to your clipboard.", 5)
end)

infoSec:CreateButton("Join us on discord!", function()
	if req then
        req({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            
            Headers = {
                ["Content-Type"] = "application/json",
                ["origin"] = "https://discord.com",
            },
                    
            Body = game:GetService("HttpService"):JSONEncode(
            {
                ["args"] = {
                ["code"] = "c4xWZ4G4bx",
                },
                
                ["cmd"] = "INVITE_BROWSER",
                ["nonce"] = "."
            })
        })
    else
        setclipboard("https://discord.gg/c4xWZ4G4bx")
        
        notifLib:Notification("Copied our discord server to your clipboard.", 5)
    end
end)

-- Misc
local miscSec = infoTab:CreateSection("Miscellaneous")
local zoomBackup = localPlr.CameraMaxZoomDistance

local server = miscSec:CreateButton("Serverhop", function()
    -- credits to: inf yield for there serverhop
    local serverList = {}
    
    for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
    	if v.playing and type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
    		serverList[#serverList + 1] = v.id
    	end
    end
    
    if #serverList > 0 then
    	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverList[math.random(1, #serverList)])
    else
        error("No servers found")
    end
end)

server:AddToolTip("Joins a different server than the one you're currently in.")

local camZoom = miscSec:CreateToggle("Infinite Zoom", false, function(bool)
    if bool then
        localPlr.CameraMaxZoomDistance = math.huge
    else
        localPlr.CameraMaxZoomDistance = zoomBackup
    end
end)

camZoom:AddToolTip("Lets you infinitely change your camera's zoom.")

local asset = getcustomasset or syn and getsynasset

if asset and isfile and writefile then
    local soundsToggled = miscSec:CreateToggle("Toggle Sounds", false, function(bool)
        getgenv().settings.toggleSounds = bool
    end)
    
    soundsToggled:AddToolTip("plays a sound when enabling or disabling a feature.")
end

-- Customization

local themeSec = infoTab:CreateSection("Themes")
local themeBG = themeSec:CreateDropdown("Background", {"Default","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"}, function(Name)
    if Name == "Default" then
		window:SetBackground("2151741365")
        getgenv().settings.theme = Name
	elseif Name == "Hearts" then
		window:SetBackground("6073763717")
        getgenv().settings.theme = Name
	elseif Name == "Abstract" then
		window:SetBackground("6073743871")
        getgenv().settings.theme = Name
	elseif Name == "Hexagon" then
		window:SetBackground("6073628839")
        getgenv().settings.theme = Name
	elseif Name == "Circles" then
		window:SetBackground("6071579801")
        getgenv().settings.theme = Name
	elseif Name == "Lace With Flowers" then
		window:SetBackground("6071575925")
        getgenv().settings.theme = Name
	elseif Name == "Floral" then
		window:SetBackground("5553946656")
        getgenv().settings.theme = Name
	end
end)

themeBG:AddToolTip("Change the background design of Rogue Hub.")

local resetDefault = themeSec:CreateButton("Reset to Default", function()
    window:SetBackground("2151741365")
    themeBG:SetOption("Default")
    
    getgenv().settings.theme = Name
end)

resetDefault:AddToolTip("Resets the Background settings to default")

-- Debug
local debugSec = infoTab:CreateSection("Debug")

local forceUnload = debugSec:CreateButton("Force Unload", function()
    getgenv().Rogue_AlreadyLoaded = nil
end)

forceUnload:AddToolTip("Reverts the Rogue_AlreadyLoaded value for debug purposes.")

local deleteUI = debugSec:CreateButton("Delete UI", function()
    getgenv().Rogue_AlreadyLoaded = nil
    window:Destroy()
end)

deleteUI:AddToolTip("Removes the Rogue Hub UI.")

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().settings.changeRPNames then
        for i, v in pairs(game:GetService("Players"):GetChildren()) do
            for _, x in pairs(v.Character:GetChildren()) do
                if x:IsA("Model") and x:FindFirstChild("ServerHandler") then
                    x:FindFirstChild("ServerHandler"):FireServer(getgenv().settings.rpName)
                end
            end
        end
    end
end)

sound:Destroy()
getgenv().isLoaded = true

notifLib:Notification("Rogue Hub took " .. math.floor(tick() - getgenv().lastTick) .. " seconds to load!", 5)
