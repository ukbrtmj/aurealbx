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

return Card
