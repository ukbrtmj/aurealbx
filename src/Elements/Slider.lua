local Card = require(script.Parent.Card)

local UserInputService = game:GetService("UserInputService")

return function(parent, config)
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
end
