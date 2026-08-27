local Card = require(script.Parent.Card)

local TweenService = game:GetService("TweenService")

return function(parent, config)
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
end
