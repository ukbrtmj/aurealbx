local Card = require(script.Parent.Card)

return function(parent, config)
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
end
