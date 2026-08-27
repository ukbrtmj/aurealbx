--[[
    NarsUILib — dist/main.lua (GERADO AUTOMATICAMENTE por build.js)
    NÃO EDITE ESSE ARQUIVO DIRETO — edite os arquivos em src/ e rode
    "node build.js" de novo.

    Uso:
        local Library = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPO/main/dist/main.lua"
        ))()
]]

-- === Library.lua ===
--[[
    NarsUILib — Library.lua
    Núcleo da lib: cria a Window (Panel, Header, Tabs, Search) e expõe
    métodos pra plugar os Elements (Button, Toggle, Dropdown, Slider...).

    Uso básico:
        local Library = loadstring(game:HttpGet(".../dist/main.lua"))()
        local Window = Library:CreateWindow({ Title = "NARS' ENDEAVOR UI" })
        local Tab = Window:CreateTab("Main")
        Tab:CreateButton({ Name = "Say Hi", Callback = function() print("hi") end })
]]

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Registry preenchido pelos módulos em src/Elements/*.lua
Library.Elements = {}

function Library:RegisterElement(name, ctor)
    Library.Elements[name] = ctor
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 5)
    c.Parent = parent
    return c
end

local function stroke(parent, thickness, color, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 0.5
    s.Color = color or Color3.fromRGB(86, 86, 86)
    s.Transparency = transparency or 0.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

--- Cria a janela principal (Panel + Header + Tabs + Search)
function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "NARS' ENDEAVOR UI"
    local LogoId = config.LogoId or "rbxassetid://100744567525223"
    local BannerId = config.BannerId or "rbxassetid://99027217090571"
    local Size = config.Size or UDim2.new(0, 270, 0, 300)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NarsUILib"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local Panel = Instance.new("Frame")
    Panel.Name = "Panel"
    Panel.BorderSizePixel = 0
    Panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Panel.AnchorPoint = Vector2.new(0.5, 0.5)
    Panel.Size = Size
    Panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    Panel.Parent = ScreenGui
    corner(Panel, 12)
    local panelStroke = stroke(Panel, 2, Color3.fromRGB(255, 255, 255), 0)
    local panelGrad = Instance.new("UIGradient")
    panelGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(197, 197, 197)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(161, 161, 161)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    panelGrad.Parent = panelStroke
    stroke(Panel, 4, Color3.fromRGB(255,255,255), 0.85).Name = "UIStroke2"

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.ZIndex = 3
    Header.BorderSizePixel = 0
    Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Header.BackgroundTransparency = 0.85
    Header.Size = UDim2.new(0, Size.X.Offset, 0, 28)
    Header.Parent = Panel
    corner(Header, 12)

    local headerLine = Instance.new("Frame")
    headerLine.Name = "Garis"
    headerLine.BorderSizePixel = 0
    headerLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    headerLine.Size = UDim2.new(0, Size.X.Offset, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 0, 28)
    headerLine.Parent = Header
    local headerLineGrad = Instance.new("UIGradient")
    headerLineGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(85,85,85)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
    })
    headerLineGrad.Parent = headerLine

    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.BorderSizePixel = 0
    Logo.BackgroundTransparency = 1
    Logo.Image = LogoId
    Logo.Size = UDim2.new(0, 20, 0, 20)
    Logo.Position = UDim2.new(0, 5, 0, 4)
    Logo.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BorderSizePixel = 0
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Size = UDim2.new(0, 150, 0, 16)
    TitleLabel.Position = UDim2.new(0, 28, 0, 6)
    TitleLabel.Text = Title
    TitleLabel.Parent = Header

    local MinimalButton = Instance.new("TextButton")
    MinimalButton.Name = "MinimalButton"
    MinimalButton.BorderSizePixel = 0
    MinimalButton.TextSize = 16
    MinimalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimalButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    MinimalButton.BackgroundTransparency = 0.5
    MinimalButton.Size = UDim2.new(0, 20, 0, 20)
    MinimalButton.Text = "-"
    MinimalButton.Position = UDim2.new(0, Size.X.Offset - 50, 0, 4)
    MinimalButton.Parent = Header
    corner(MinimalButton, 5)
    stroke(MinimalButton)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BorderSizePixel = 0
    CloseButton.TextSize = 12
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    CloseButton.BackgroundTransparency = 0.5
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Text = "X"
    CloseButton.Position = UDim2.new(0, Size.X.Offset - 25, 0, 4)
    CloseButton.Parent = Header
    corner(CloseButton, 5)
    stroke(CloseButton)

    local headerGrad = Instance.new("UIGradient")
    headerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
    })
    headerGrad.Parent = Header

    -- Banner (opcional, decorativo)
    local Banner = Instance.new("ImageLabel")
    Banner.Name = "Banner"
    Banner.BorderSizePixel = 0
    Banner.BackgroundTransparency = 1
    Banner.ScaleType = Enum.ScaleType.Crop
    Banner.Image = BannerId
    Banner.Size = UDim2.new(0, Size.X.Offset, 0, 28)
    Banner.Parent = Panel
    corner(Banner, 12)

    -- Tabs (scroll horizontal)
    local ScrollingTab = Instance.new("ScrollingFrame")
    ScrollingTab.Name = "ScrollingTab"
    ScrollingTab.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingTab.ZIndex = 4
    ScrollingTab.BorderSizePixel = 0
    ScrollingTab.BackgroundTransparency = 1
    ScrollingTab.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingTab.Size = UDim2.new(0, Size.X.Offset - 9, 0, 30)
    ScrollingTab.Position = UDim2.new(0, 5, 0, 30)
    ScrollingTab.ScrollBarThickness = 0
    ScrollingTab.Parent = Panel

    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingTop = UDim.new(0, 3)
    tabPad.Parent = ScrollingTab

    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 4)
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Parent = ScrollingTab

    -- Search
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.ZIndex = 4
    SearchBox.BorderSizePixel = 0
    SearchBox.TextSize = 9
    SearchBox.TextColor3 = Color3.fromRGB(212, 212, 212)
    SearchBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    SearchBox.BackgroundTransparency = 0.5
    SearchBox.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold)
    SearchBox.PlaceholderText = "Search Script.."
    SearchBox.Text = ""
    SearchBox.Size = UDim2.new(0, Size.X.Offset - 9, 0, 24)
    SearchBox.Position = UDim2.new(0, 5, 0, 62)
    SearchBox.Parent = Panel
    corner(SearchBox, 5)
    stroke(SearchBox)

    -- Container que recebe os Elements (Card list)
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.ZIndex = 4
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Size = UDim2.new(0, Size.X.Offset, 0, Size.Y.Offset - 90)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 88)
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Parent = Panel

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 5)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.Parent = ScrollingFrame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 4)
    list.Parent = ScrollingFrame

    -- Drag da janela pelo Header
    do
        local dragging, dragStart, startPos
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Panel.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        Header.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                Panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local minimized = false
    MinimalButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local target = minimized and UDim2.new(0, Size.X.Offset, 0, 28) or Size
        TweenService:Create(Panel, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Size = target }):Play()
        ScrollingFrame.Visible = not minimized
        ScrollingTab.Visible = not minimized
        SearchBox.Visible = not minimized
    end)

    -- Window object
    local Window = setmetatable({
        ScreenGui = ScreenGui,
        Panel = Panel,
        Header = Header,
        ScrollingTab = ScrollingTab,
        ScrollingFrame = ScrollingFrame,
        SearchBox = SearchBox,
        Tabs = {},
        ActiveTab = nil,
    }, Library)

    -- filtro de busca por Name dos cards (Elements setam attribute "ElementName")
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        for _, card in ipairs(ScrollingFrame:GetChildren()) do
            if card:IsA("Frame") and card:GetAttribute("ElementName") then
                local name = tostring(card:GetAttribute("ElementName")):lower()
                card.Visible = query == "" or name:find(query, 1, true) ~= nil
            end
        end
    end)

    return Window
end

--- Cria uma Tab (só controla visibilidade dos cards que pertencem a ela)
function Library:CreateTab(name)
    local BgTab = Instance.new("Frame")
    BgTab.Name = "BgTab_" .. name
    BgTab.BorderSizePixel = 0
    BgTab.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
    BgTab.Size = UDim2.new(0, 70, 0, 24)
    BgTab.Parent = self.ScrollingTab
    corner(BgTab, 5)

    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab"
    TabButton.BorderSizePixel = 0
    TabButton.TextSize = 9
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    TabButton.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold)
    TabButton.Size = UDim2.new(0, 70, 0, 22)
    TabButton.Text = name
    TabButton.Parent = BgTab
    corner(TabButton, 5)

    local Tab = {
        Name = name,
        Button = TabButton,
        Elements = {},
        _window = self,
    }

    local function refreshVisibility()
        for _, otherTab in pairs(self.Tabs) do
            for _, el in ipairs(otherTab.Elements) do
                el.Visible = (otherTab == Tab)
            end
        end
    end

    TabButton.MouseButton1Click:Connect(function()
        self.ActiveTab = Tab
        refreshVisibility()
    end)

    -- métodos genéricos: Tab:CreateButton(cfg), Tab:CreateToggle(cfg), etc.
    for elementName, ctor in pairs(Library.Elements) do
        Tab["Create" .. elementName] = function(_, cfg)
            local instance, api = ctor(self.ScrollingFrame, cfg or {})
            table.insert(Tab.Elements, instance)
            instance.Visible = (self.ActiveTab == nil or self.ActiveTab == Tab)
            return api
        end
    end

    table.insert(self.Tabs, Tab)
    if not self.ActiveTab then
        self.ActiveTab = Tab
    else
        for _, el in ipairs(Tab.Elements) do el.Visible = false end
    end

    return Tab
end


-- === Elements/Card.lua (helper, não é um Element registrado) ===
--[[
    Card.lua — base visual compartilhada por todos os Elements.
    Não é registrado na Library; é só um helper usado pelos outros arquivos
    dessa pasta (Button.lua, Toggle.lua, Dropdown.lua, Slider.lua).
]]

local Card = {}

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 5)
    c.Parent = parent
    return c
end

local function stroke(parent, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 0.5
    s.Color = Color3.fromRGB(86, 86, 86)
    s.Transparency = transparency or 0.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

--- Cria o frame base (fundo, nome, descrição, tag) e devolve tudo pra o
--- Element específico plugar seu controle (botão, switch, dropdown...).
function Card.new(parent, config, height)
    local Frame = Instance.new("Frame")
    Frame.Name = config.Name or "Element"
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BackgroundTransparency = 0.5
    Frame.Size = UDim2.new(1, -9, 0, height or 70)
    Frame.LayoutOrder = config.Order or 0
    Frame.Parent = parent
    Frame:SetAttribute("ElementName", config.Name or "")
    corner(Frame, 8)
    stroke(Frame)

    local Name = Instance.new("TextLabel")
    Name.Name = "Name"
    Name.BorderSizePixel = 0
    Name.BackgroundTransparency = 1
    Name.TextSize = 10
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold)
    Name.TextColor3 = Color3.fromRGB(255, 255, 255)
    Name.Size = UDim2.new(1, -70, 0, 16)
    Name.Position = UDim2.new(0, 8, 0, 6)
    Name.Text = config.Name or "Element"
    Name.Parent = Frame

    local Description
    if config.Description and config.Description ~= "" then
        Description = Instance.new("TextLabel")
        Description.Name = "Description"
        Description.BorderSizePixel = 0
        Description.BackgroundTransparency = 1
        Description.TextWrapped = true
        Description.TextSize = 9
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.TextYAlignment = Enum.TextYAlignment.Top
        Description.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular)
        Description.TextColor3 = Color3.fromRGB(180, 180, 180)
        Description.Size = UDim2.new(1, -16, 0, 24)
        Description.Position = UDim2.new(0, 8, 0, 22)
        Description.Text = config.Description
        Description.Parent = Frame
    end

    return Frame, Name, Description
end


-- === Elements/Button.lua ===
local Card = require(script.Parent.Card) -- na dist, isso vira inline (ver build.js)

Library:RegisterElement("Button", function(parent, config)
    local Frame = Card.new(parent, config, 54)

    local Btn = Instance.new("TextButton")
    Btn.Name = "Button"
    Btn.BorderSizePixel = 0
    Btn.TextSize = 12
    Btn.BackgroundColor3 = Color3.fromRGB(224, 231, 238)
    Btn.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold)
    Btn.Size = UDim2.new(1, -16, 0, 24)
    Btn.Position = UDim2.new(0, 8, 1, -30)
    Btn.Text = config.ButtonText or "EXECUTE"
    Btn.Parent = Frame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        if config.Callback then
            local ok, err = pcall(config.Callback)
            if not ok then warn("[NarsUILib] Button '" .. (config.Name or "?") .. "' error: " .. tostring(err)) end
        end
    end)

    local api = {
        SetText = function(_, text) Btn.Text = text end,
        Instance = Frame,
    }
    return Frame, api
end)

-- === Elements/Toggle.lua ===
local TweenService = game:GetService("TweenService")

Library:RegisterElement("Toggle", function(parent, config)
    local Frame = Card.new(parent, config, 44)
    local state = config.Default or false

    local Switch = Instance.new("Frame")
    Switch.Name = "Switch"
    Switch.BorderSizePixel = 0
    Switch.Size = UDim2.new(0, 36, 0, 18)
    Switch.Position = UDim2.new(1, -44, 0, 6)
    Switch.BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 60)
    Switch.Parent = Frame
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.BorderSizePixel = 0
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = Switch
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = Knob

    local Click = Instance.new("TextButton")
    Click.BackgroundTransparency = 1
    Click.Text = ""
    Click.Size = UDim2.new(1, 0, 1, 0)
    Click.Parent = Switch

    local function render(animated)
        local knobGoal = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local colorGoal = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 60)
        if animated then
            TweenService:Create(Knob, TweenInfo.new(0.15), { Position = knobGoal }):Play()
            TweenService:Create(Switch, TweenInfo.new(0.15), { BackgroundColor3 = colorGoal }):Play()
        else
            Knob.Position = knobGoal
            Switch.BackgroundColor3 = colorGoal
        end
    end

    Click.MouseButton1Click:Connect(function()
        state = not state
        render(true)
        if config.Callback then
            local ok, err = pcall(config.Callback, state)
            if not ok then warn("[NarsUILib] Toggle '" .. (config.Name or "?") .. "' error: " .. tostring(err)) end
        end
    end)

    local api = {
        Set = function(_, value)
            state = value
            render(true)
        end,
        Get = function() return state end,
        Instance = Frame,
    }
    return Frame, api
end)

-- === Elements/Dropdown.lua ===
Library:RegisterElement("Dropdown", function(parent, config)
    local options = config.Options or {}
    local Frame = Card.new(parent, config, 44)
    local open = false
    local selected = config.Default or options[1]

    local Head = Instance.new("TextButton")
    Head.Name = "DropdownHead"
    Head.BorderSizePixel = 0
    Head.TextSize = 10
    Head.TextXAlignment = Enum.TextXAlignment.Left
    Head.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Head.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold)
    Head.TextColor3 = Color3.fromRGB(255, 255, 255)
    Head.Size = UDim2.new(1, -16, 0, 22)
    Head.Position = UDim2.new(0, 8, 1, -28)
    Head.Text = "  " .. tostring(selected or "Select...")
    Head.Parent = Frame
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 5)
    hc.Parent = Head

    local List = Instance.new("Frame")
    List.Name = "List"
    List.BorderSizePixel = 0
    List.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    List.Size = UDim2.new(1, -16, 0, 0)
    List.Position = UDim2.new(0, 8, 1, -6)
    List.ClipsDescendants = true
    List.Visible = false
    List.Parent = Frame
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 5)
    lc.Parent = List
    local layout = Instance.new("UIListLayout")
    layout.Parent = List

    local api = {}

    local function selectOption(opt)
        selected = opt
        Head.Text = "  " .. tostring(opt)
        if config.Callback then
            local ok, err = pcall(config.Callback, opt)
            if not ok then warn("[NarsUILib] Dropdown '" .. (config.Name or "?") .. "' error: " .. tostring(err)) end
        end
    end

    for _, opt in ipairs(options) do
        local OptButton = Instance.new("TextButton")
        OptButton.BackgroundTransparency = 1
        OptButton.Size = UDim2.new(1, 0, 0, 20)
        OptButton.TextSize = 9
        OptButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        OptButton.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular)
        OptButton.Text = tostring(opt)
        OptButton.Parent = List
        OptButton.MouseButton1Click:Connect(function() selectOption(opt) end)
    end

    Head.MouseButton1Click:Connect(function()
        open = not open
        List.Visible = open
        List.Size = UDim2.new(1, -16, 0, open and math.min(#options * 20, 100) or 0)
        -- expande o card pra caber a lista
        Frame.Size = UDim2.new(1, -9, 0, open and (54 + math.min(#options * 20, 100)) or 44)
    end)

    api.Set = function(_, opt) selectOption(opt) end
    api.Get = function() return selected end
    api.Instance = Frame

    return Frame, api
end)

-- === Elements/Slider.lua ===
local UserInputService = game:GetService("UserInputService")

Library:RegisterElement("Slider", function(parent, config)
    local min = config.Min or 0
    local max = config.Max or 100
    local value = math.clamp(config.Default or min, min, max)

    local Frame = Card.new(parent, config, 54)

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "Value"
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextSize = 9
    ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ValueLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular)
    ValueLabel.Size = UDim2.new(0, 50, 0, 14)
    ValueLabel.Position = UDim2.new(1, -58, 0, 6)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Text = tostring(value)
    ValueLabel.Parent = Frame

    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.BorderSizePixel = 0
    Track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Track.Size = UDim2.new(1, -16, 0, 6)
    Track.Position = UDim2.new(0, 8, 1, -22)
    Track.Parent = Frame
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.BorderSizePixel = 0
    Fill.BackgroundColor3 = Color3.fromRGB(224, 231, 238)
    Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    Fill.Parent = Track
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

    local dragging = false

    local function update(inputPos)
        local rel = math.clamp((inputPos.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * rel)
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        ValueLabel.Text = tostring(value)
        if config.Callback then
            local ok, err = pcall(config.Callback, value)
            if not ok then warn("[NarsUILib] Slider '" .. (config.Name or "?") .. "' error: " .. tostring(err)) end
        end
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local api = {
        Set = function(_, v)
            value = math.clamp(v, min, max)
            local rel = (value - min) / (max - min)
            Fill.Size = UDim2.new(rel, 0, 1, 0)
            ValueLabel.Text = tostring(value)
        end,
        Get = function() return value end,
        Instance = Frame,
    }
    return Frame, api
end)

return Library
