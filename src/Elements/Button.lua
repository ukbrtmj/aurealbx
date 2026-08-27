local Card = require(script.Parent.Card) -- na dist, isso vira inline (ver build.js)

return function(parent, config)
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
end
