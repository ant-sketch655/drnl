--[[
====================================================================
  ⚽ Brookhaven Soccer Hub - Private Test Build v4.0
  Owner: itz_leoleo54
  
  NOVIDADES v4.0:
  - Expiração de key (1 dia / 7 dias / permanente)
  - HWID lock (1 key = 1 device)
  - Painel admin redesenhado
====================================================================
]]

--====================================================================
-- SERVIÇOS
--====================================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Workspace        = game:GetService("Workspace")
local LocalPlayer      = Players.LocalPlayer

--====================================================================
-- 🔐 CONFIGURAÇÃO
--====================================================================
local Config = {
    OWNER_NAME = "itz_leoleo54",
    ADMIN_KEY  = "ADMIN-LEO-2026",
    DISCORD_URL = "https://discord.gg/xdnBFxHeAp",
    KEYS_FILE   = "soccer_hub_keys.json",
    MAX_ATTEMPTS = 3,
    LOCKOUT_TIME = 30,
    KEY_PREFIX   = "SOCCER",
}

--====================================================================
-- 🆔 HWID (funciona em todos executores modernos)
--====================================================================
local function getHWID()
    -- Tenta vários métodos em ordem de preferência
    local ok, hwid
    -- 1) RbxAnalyticsService (mais confiável)
    ok, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and hwid and #hwid > 5 then return hwid end
    -- 2) gethwid (alguns executores expõem)
    if typeof(gethwid) == "function" then
        ok, hwid = pcall(gethwid)
        if ok and hwid then return hwid end
    end
    -- 3) Fallback: hash simples do UserId (não é único por device,
    --    mas serve como plano B se o resto falhar)
    ok, hwid = pcall(function()
        return "UID-" .. tostring(LocalPlayer.UserId)
    end)
    if ok then return hwid end
    return "UNKNOWN-HWID"
end

local MY_HWID = getHWID()

--====================================================================
-- 💾 FILE STORE (JSON próprio, sem depender do HttpService)
--====================================================================
local FileStore = {
    supported = (typeof(writefile) == "function")
             and (typeof(readfile) == "function")
             and (typeof(isfile) == "function"),
}

function FileStore.encode(tbl)
    -- JSON manual robusto (funciona em qualquer executor)
    local function esc(s)
        return tostring(s):gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n')
    end
    local function encVal(v)
        local t = type(v)
        if t == "string" then return '"' .. esc(v) .. '"'
        elseif t == "number" then return tostring(v)
        elseif t == "boolean" then return tostring(v)
        elseif t == "nil" then return "null"
        elseif t == "table" then
            -- Detecta array vs objeto
            local isArray = true
            local count = 0
            for k, _ in pairs(v) do
                count = count + 1
                if type(k) ~= "number" then isArray = false; break end
            end
            if isArray and count == #v then
                local parts = {}
                for _, x in ipairs(v) do table.insert(parts, encVal(x)) end
                return "[" .. table.concat(parts, ",") .. "]"
            else
                local parts = {}
                for k, val in pairs(v) do
                    table.insert(parts, '"' .. esc(k) .. '":' .. encVal(val))
                end
                return "{" .. table.concat(parts, ",") .. "}"
            end
        end
        return "null"
    end
    return encVal(tbl)
end

-- Decodificador JSON simples (recursivo)
function FileStore.decode(str)
    if not str or #str < 2 then return {} end
    -- Se o executor tem HttpService:JSONDecode, usa
    local ok, res = pcall(function() return HttpService:JSONDecode(str) end)
    if ok and type(res) == "table" then return res end
    -- Fallback: parser próprio
    return {}
end

function FileStore.load()
    if not FileStore.supported then return {} end
    if not isfile(Config.KEYS_FILE) then return {} end
    local ok, data = pcall(readfile, Config.KEYS_FILE)
    if not ok or not data or #data < 3 then return {} end
    local ok2, tbl = pcall(FileStore.decode, data)
    if ok2 and type(tbl) == "table" then return tbl end
    return {}
end

function FileStore.save(tbl)
    if not FileStore.supported then return false end
    local ok = pcall(writefile, Config.KEYS_FILE, FileStore.encode(tbl))
    return ok
end

--====================================================================
-- 🔑 KEY MANAGER (com expiração + HWID)
--====================================================================
local KeyManager = {
    keys = {}, -- { [key] = { created, expires, hwid } }
}

function KeyManager.isOwner()
    return LocalPlayer.Name == Config.OWNER_NAME
end

function KeyManager.load()
    local data = FileStore.load()
    -- Sanitiza formato antigo (só timestamp) para novo formato
    for k, v in pairs(data) do
        if type(v) == "number" then
            KeyManager.keys[k] = { created = v, expires = 0, hwid = nil }
        elseif type(v) == "table" then
            KeyManager.keys[k] = {
                created = tonumber(v.created) or 0,
                expires = tonumber(v.expires) or 0, -- 0 = permanente
                hwid    = v.hwid,
            }
        end
    end
    local count = 0
    for _ in pairs(KeyManager.keys) do count = count + 1 end
    print(string.format("[Soccer Hub] %d key(s) carregada(s).", count))
end

function KeyManager.save()
    return FileStore.save(KeyManager.keys)
end

-- Cria uma key aleatória
function KeyManager.generate(durationDays)
    local chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    local function blk(n)
        local s = ""
        for _ = 1, n do
            local i = math.random(1, #chars)
            s = s .. chars:sub(i, i)
        end
        return s
    end
    local key
    repeat
        key = Config.KEY_PREFIX .. "-" .. blk(4) .. "-" .. blk(4)
    until not KeyManager.keys[key] and key ~= Config.ADMIN_KEY

    local now = os.time()
    local expires = 0 -- 0 = permanente
    if durationDays and durationDays > 0 then
        expires = now + (durationDays * 86400) -- 86400 seg/dia
    end

    KeyManager.keys[key] = {
        created = now,
        expires = expires,
        hwid    = nil, -- será vinculado no primeiro uso
    }
    KeyManager.save()
    return key, expires
end

-- Revoga
function KeyManager.revoke(key)
    if KeyManager.keys[key] then
        KeyManager.keys[key] = nil
        KeyManager.save()
        return true
    end
    return false
end

-- Lista ordenada (mais novas primeiro)
function KeyManager.list()
    local list = {}
    for k, v in pairs(KeyManager.keys) do
        table.insert(list, {
            key = k,
            created = v.created or 0,
            expires = v.expires or 0,
            hwid = v.hwid,
        })
    end
    table.sort(list, function(a, b) return a.created > b.created end)
    return list
end

-- Formata timestamp em data legível (DD/MM/YYYY HH:MM)
function KeyManager.formatTime(ts)
    if not ts or ts == 0 then return "—" end
    local ok, str = pcall(os.date, "%d/%m/%Y", ts)
    return ok and str or "?"
end

-- Calcula dias restantes (número)
function KeyManager.daysLeft(expires)
    if not expires or expires == 0 then return -1 end -- permanente
    local diff = expires - os.time()
    if diff <= 0 then return 0 end
    return math.ceil(diff / 86400)
end

-- Valida (retorna status, motivo, info extra)
function KeyManager.validate(input)
    if not input or #input < 4 then return false, "Key muito curta" end
    input = input:upper():gsub("%s", "")

    -- Admin
    if input == Config.ADMIN_KEY then
        if KeyManager.isOwner() then
            return true, "admin", { expires = 0, hwid = MY_HWID }
        else
            return false, "Key reservada"
        end
    end

    -- Key de usuário
    local data = KeyManager.keys[input]
    if not data then return false, "Key incorreta" end

    -- Checa expiração
    if data.expires and data.expires > 0 then
        if os.time() > data.expires then
            return false, "Key expirada em " .. KeyManager.formatTime(data.expires)
        end
    end

    -- Checa HWID
    if data.hwid and data.hwid ~= "" then
        if data.hwid ~= MY_HWID then
            return false, "Key já vinculada a outro dispositivo"
        end
        -- Mesmo HWID: OK
        return true, "user", data
    end

    -- Primeiro uso: vincula HWID
    data.hwid = MY_HWID
    KeyManager.save()
    return true, "user", data
end

--====================================================================
-- 📋 CLIPBOARD
--====================================================================
local function copyToClipboard(text)
    return pcall(function()
        if typeof(setclipboard) == "function" then setclipboard(text)
        elseif typeof(toclipboard) == "function" then toclipboard(text)
        else error("no clipboard") end
    end)
end

--====================================================================
-- TEMA
--====================================================================
local Themes = {
    Dark = {
        bg        = Color3.fromRGB(22, 24, 30),
        bgLight   = Color3.fromRGB(30, 33, 42),
        accent    = Color3.fromRGB(0, 200, 130),
        accentOff = Color3.fromRGB(60, 65, 78),
        text      = Color3.fromRGB(240, 240, 245),
        textDim   = Color3.fromRGB(150, 155, 165),
        stroke    = Color3.fromRGB(45, 50, 62),
        danger    = Color3.fromRGB(220, 60, 60),
        warn      = Color3.fromRGB(240, 180, 50),
        success   = Color3.fromRGB(0, 200, 100),
        discord   = Color3.fromRGB(88, 101, 242),
        purple    = Color3.fromRGB(150, 90, 220),
    },
    Light = {
        bg        = Color3.fromRGB(245, 246, 250),
        bgLight   = Color3.fromRGB(255, 255, 255),
        accent    = Color3.fromRGB(0, 170, 110),
        accentOff = Color3.fromRGB(200, 205, 215),
        text      = Color3.fromRGB(25, 28, 35),
        textDim   = Color3.fromRGB(110, 115, 125),
        stroke    = Color3.fromRGB(220, 222, 230),
        danger    = Color3.fromRGB(200, 50, 50),
        warn      = Color3.fromRGB(200, 140, 30),
        success   = Color3.fromRGB(0, 160, 90),
        discord   = Color3.fromRGB(88, 101, 242),
        purple    = Color3.fromRGB(130, 70, 200),
    },
}

local State = {
    UI = { theme = "Dark", tab = "Scripts", filter = "Todos", testMode = false,
           visible = true, minimized = false },
    Soccer = { ballMagnet = false, ballControl = false, shootPower = 65, magnetRange = 20 },
    Keybinds = { toggleUI = Enum.KeyCode.RightShift },
    Access = { level = nil, keyData = nil },
}
local function getTheme() return Themes[State.UI.theme] or Themes.Dark end

--====================================================================
-- AUDIT LOG
--====================================================================
local AuditLog = {
    entries = {},
    add = function(name, url, success, err)
        table.insert(AuditLog.entries, {
            time = os.date("%H:%M:%S"), name = name, url = url,
            success = success, error = err,
        })
        print(string.format("[AUDIT] %s | %s | %s | %s",
            os.date("%H:%M:%S"), name, success and "OK" or "FAIL", err or "-"))
    end,
    dump = function()
        local lines = {}
        for _, e in ipairs(AuditLog.entries) do
            table.insert(lines, string.format("%s | %s | %s", e.time, e.name,
                e.success and "OK" or ("FAIL: " .. tostring(e.error))))
        end
        return table.concat(lines, "\n")
    end,
}

--====================================================================
-- UTILS
--====================================================================
local Utils = {}
function Utils.create(c, p, ch)
    local i = Instance.new(c)
    for k, v in pairs(p or {}) do i[k] = v end
    for _, x in ipairs(ch or {}) do x.Parent = i end
    return i
end
function Utils.corner(p, r)
    return Utils.create("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p })
end
function Utils.stroke(p, c, t)
    return Utils.create("UIStroke", {
        Color = c or Color3.new(1,1,1), Thickness = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p,
    })
end
function Utils.tween(i, t, p, s, d)
    local tw = TweenService:Create(i, TweenInfo.new(t or 0.25,
        s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out), p)
    tw:Play()
    return tw
end

--====================================================================
-- 🖼️ TELA DE LOGIN
--====================================================================
local LoginScreen = {}

function LoginScreen.show(onSuccess)
    local theme = getTheme()
    local attempts = 0
    local lockedUntil = 0

    local gui = Utils.create("ScreenGui", {
        Name = "SoccerHubLogin",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })
    if gethui then pcall(function() gui.Parent = gethui() end) end
    if not gui.Parent then
        local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not ok or not gui.Parent then
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end

    local bg = Utils.create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0, Parent = gui,
    })

    local card = Utils.create("Frame", {
        Size = UDim2.fromOffset(320, 340),
        Position = UDim2.new(0.5, -160, 0.5, -170),
        BackgroundColor3 = theme.bg,
        BorderSizePixel = 0, Parent = bg,
    })
    Utils.corner(card, 16)
    Utils.stroke(card, theme.stroke, 1)

    Utils.create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "⚽  SOCCER HUB",
        TextColor3 = theme.text, TextSize = 24,
        Font = Enum.Font.GothamBold, Parent = card,
    })
    Utils.create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 75),
        BackgroundTransparency = 1,
        Text = "Build privada — insira sua key",
        TextColor3 = theme.textDim, TextSize = 11,
        Font = Enum.Font.Gotham, Parent = card,
    })

    local boxHolder = Utils.create("Frame", {
        Size = UDim2.new(1, -60, 0, 44),
        Position = UDim2.new(0, 30, 0, 115),
        BackgroundColor3 = theme.bgLight,
        BorderSizePixel = 0, Parent = card,
    })
    Utils.corner(boxHolder, 10)
    Utils.stroke(boxHolder, theme.stroke, 1)

    local keyBox = Utils.create("TextBox", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Text = "",
        PlaceholderText = "🔑 Digite sua Key",
        PlaceholderColor3 = theme.textDim,
        TextColor3 = theme.text, TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false, Parent = boxHolder,
    })

    local validateBtn = Utils.create("TextButton", {
        Size = UDim2.new(1, -60, 0, 44),
        Position = UDim2.new(0, 30, 0, 175),
        BackgroundColor3 = theme.accent,
        Text = "VALIDAR",
        TextColor3 = Color3.new(1,1,1), TextSize = 15,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false, Parent = card,
    })
    Utils.corner(validateBtn, 10)

    local statusLbl = Utils.create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 24),
        Position = UDim2.new(0, 30, 0, 226),
        BackgroundTransparency = 1, Text = "",
        TextColor3 = theme.textDim, TextSize = 10,
        Font = Enum.Font.Gotham, TextWrapped = true, Parent = card,
    })

    Utils.create("Frame", {
        Size = UDim2.new(1, -60, 0, 1),
        Position = UDim2.new(0, 30, 0, 260),
        BackgroundColor3 = theme.stroke,
        BorderSizePixel = 0, Parent = card,
    })

    local discordBtn = Utils.create("TextButton", {
        Size = UDim2.new(1, -60, 0, 44),
        Position = UDim2.new(0, 30, 0, 274),
        BackgroundColor3 = theme.discord,
        Text = "💬  Nosso Discord",
        TextColor3 = Color3.new(1,1,1), TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false, Parent = card,
    })
    Utils.corner(discordBtn, 10)

    discordBtn.MouseButton1Click:Connect(function()
        if copyToClipboard(Config.DISCORD_URL) then
            discordBtn.Text = "✓  Link copiado!"
            task.delay(2, function() discordBtn.Text = "💬  Nosso Discord" end)
        else
            discordBtn.Text = "⚠ Copie: " .. Config.DISCORD_URL
        end
    end)

    card.Size = UDim2.fromOffset(0, 0)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    Utils.tween(card, 0.4, {
        Size = UDim2.fromOffset(320, 340),
        Position = UDim2.new(0.5, -160, 0.5, -170),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local function tryValidate()
        local now = os.time()
        if now < lockedUntil then
            statusLbl.Text = string.format("⛔ Bloqueado por %ds", lockedUntil - now)
            statusLbl.TextColor3 = theme.danger
            return
        end

        local ok, level, info = KeyManager.validate(keyBox.Text)
        if ok then
            statusLbl.Text = "✓ Acesso liberado!"
            statusLbl.TextColor3 = theme.accent
            State.Access.level = level
            State.Access.keyData = info
            task.wait(0.4)
            Utils.tween(card, 0.3, {
                Size = UDim2.fromOffset(0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
            }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            task.wait(0.3)
            gui:Destroy()
            onSuccess(level, info)
        else
            attempts = attempts + 1
            local left = Config.MAX_ATTEMPTS - attempts
            if left <= 0 then
                lockedUntil = os.time() + Config.LOCKOUT_TIME
                attempts = 0
                statusLbl.Text = string.format("⛔ Bloqueado por %ds", Config.LOCKOUT_TIME)
                statusLbl.TextColor3 = theme.danger
                Utils.tween(boxHolder, 0.1, { BackgroundColor3 = theme.danger })
                task.delay(0.2, function()
                    Utils.tween(boxHolder, 0.3, { BackgroundColor3 = theme.bgLight })
                end)
            else
                statusLbl.Text = string.format("%s — %d tentativa(s)", level, left)
                statusLbl.TextColor3 = theme.danger
            end
        end
    end

    validateButtonClick = tryValidate
    validateBtn.MouseButton1Click:Connect(tryValidate)
    keyBox.FocusLost:Connect(function(enter) if enter then tryValidate() end end)
end

--====================================================================
-- 📜 REGISTRO DE SCRIPTS EXTERNOS
--====================================================================
local ExternalRegistry = {
    { "Condução do Lancaster ⚽",       "https://pastebin.com/raw/c27sEpVh",  "Condução" },
    { "Bola Chiclete ⚽",              "https://pastefy.app/ZMHWh8kW/raw",  "Condução" },
    { "Condução Theus ⚽",             "https://pastefy.app/7FAwfRUX/raw",  "Condução" },
    { "Soccer Dribble Hub ⚡",         "https://pastebin.com/raw/gwZKjbVM", "Condução" },
    { "Chute Bomba 💣",                "https://pastefy.app/HeRcZpTg/raw",  "Chute" },
    { "Passe Forte 🦵",                "https://pastebin.com/raw/2Yw8Bv85", "Chute" },
    { "Football Master V5 Pro ⚽",     "https://pastefy.app/77ScQkbz/raw",  "Chute" },
    { "Football Master V7 ⚽",         "https://pastefy.app/I9nocuO2/raw",  "Chute" },
    { "Anti Atravessar Soccer Tool ⚽","https://pastebin.com/raw/LYWJ6sfF", "Defesa" },
    { "Anti Ball Pedra ⚽",            "https://pastefy.app/59dDHHfr/raw",  "Defesa" },
    { "Anti Ball Pedra + Atravessar",  "https://pastebin.com/raw/Z7eZDEj8", "Defesa" },
    { "Muralha Hub 🧱",                "https://pastebin.com/raw/UxtmMHm1", "Defesa" },
    { "Goleiro Hub 🧤",                "https://pastefy.app/cogJvYif/raw",  "Defesa" },
    { "GK Hub (Goleiro Deitado) 🧤",   "https://pastebin.com/raw/FaBkfBHr", "Defesa" },
    { "Yashin Ultra 🧤",               "https://pastebin.com/raw/KmNHLYsb", "Defesa" },
    { "Legendary Defender ⚔️",         "https://pastebin.com/raw/s91y0AFs", "Defesa" },
    { "Puyol V3 ⚡",                   "https://pastebin.com/raw/bMLRRKwG", "Defesa" },
    { "Atravessar Simples 🔥",         "https://pastebin.com/raw/D15v30nW", "Atravessar" },
    { "Atravessar Theus 👻",           "https://pastefy.app/7e1VxPgW/raw",  "Atravessar" },
    { "PJ Atravessa 🧧",               "https://pastefy.app/CrhmqFtx/raw",  "Atravessar" },
    { "Atravessar V12 🟣",             "https://pastebin.com/raw/GZn1L0PM", "Atravessar" },
    { "Noclip Injusto + Reach 900",    "https://pastebin.com/raw/hfrDcUm8", "Atravessar" },
    { "Reach The Void 🌑",             "https://pastebin.com/raw/HyAUVhnP", "Atravessar" },
    { "Ghost + Reach 👻",              "https://pastebin.com/raw/1if0pn7x", "Atravessar" },
    { "Theus Reach V2 🦿",             "https://pastebin.com/raw/pm4pyxm4", "Atravessar" },
    { "Henrique Drible ⚡",            "https://pastebin.com/raw/wJKBdV8A", "Bugs" },
    { "Jvz Bug 🥷",                    "https://pastefy.app/hYyBJna/raw",   "Bugs" },
    { "Bug Do reidorm 👑",             "https://pastebin.com/raw/qtsDZHGu", "Bugs" },
    { "Pedrizz Bug ⚡",                "https://pastebin.com/raw/28LDYic2", "Bugs" },
    { "Mtzin Pro Max ⚡",              "https://pastebin.com/raw/kCKEhh99", "Bugs" },
    { "Lag Switch 👣",                 "https://pastefy.app/zZo7yoUB/raw",  "Bugs" },
    { "Glitch Infinity ♾️",            "https://pastebin.com/raw/FpPh3UhN", "Bugs" },
    { "Otimização 🚀",                 "https://raw.githubusercontent.com/Davzxxfixroblox/DavzxHubFixLag/refs/heads/main/FixLagHub", "Otimização" },
    { "Ping Optimizer 🧟",             "https://pastebin.com/raw/kbHL8MZ5", "Otimização" },
    { "Mega Otimização Brookhaven 🏠", "https://pastebin.com/raw/GzrqQWkx", "Otimização" },
    { "Otimização Linha Transparente", "https://pastebin.com/raw/RbC506TY", "Otimização" },
    { "Tira Analógico 🕹",             "https://pastefy.app/AJhzcN5G/raw",  "Otimização" },
    { "X Hub ❌",                      "https://pastefy.app/yXuzlTpQ/raw",  "Hubs" },
    { "Caga Na Roupa Hub 💩",          "https://pastefy.app/eKFExNPG/raw",  "Hubs" },
    { "Nova Era Hub 💎",               "https://pastefy.app/zrszTIQx/raw",  "Hubs" },
    { "Zyck 4.5 🇺🇸",                  "https://pastefy.app/P2eNOBe2/raw",  "Hubs" },
    { "Gui Prime Pro ⚽",              "https://pastebin.com/raw/xgkQc7Q9", "Hubs" },
    { "K4y The Promission ☠️",         "https://pastefy.app/Of3pO501/raw",  "Hubs" },
    { "Armando Jr Hub 🔥",             "https://raw.githubusercontent.com/carlosedut11/ArmadinhoJrPorCantonaJr/refs/heads/main/ArmadinhoJrPorCantonaJr.lua", "Hubs" },
    { "Lucas Hub 😈",                  "https://pastebin.com/raw/xmbL5T3i", "Hubs" },
    { "Painel do Kayne 🔥",            "https://pastebin.com/raw/Frxjj6my", "Hubs" },
    { "Kayne Supremo 🔥",              "https://pastebin.com/raw/xyS7KQdY", "Hubs" },
    { "Theus Hub 🍎",                  "https://pastefy.app/bib1MRS8/raw",  "Hubs" },
    { "Matteo Hub ❄️",                 "https://pastefy.app/Pvf3lqmJ/raw",  "Hubs" },
    { "Gotto Hub ⚽",                  "https://pastefy.app/EOizRmIz/raw",  "Hubs" },
    { "Loved Hub 🍷",                  "https://pastefy.app/AccDN8CV/raw",  "Hubs" },
    { "Angel Hub 😇",                  "https://pastefy.app/679CyrEi/raw",  "Hubs" },
    { "Samuzx Hub 🥶",                 "https://pastefy.app/yOVyrBNy/raw",  "Hubs" },
    { "Papai Cris Menu ❤️",            "https://pastefy.app/jI58Il0a/raw",  "Hubs" },
    { "Hunk Hub 🫂",                   "https://pastefy.app/ZGDUJNWr/raw",  "Hubs" },
    { "Drinho Hub 🎯",                 "https://pastefy.app/KEfkfhsr/raw",  "Hubs" },
    { "Fire Hub 🔥",                   "https://pastebin.com/raw/iVp2tnCR", "Hubs" },
    { "Water Hub 🌊",                  "https://pastefy.app/iQzbaBGE/raw",  "Hubs" },
    { "Six Hub 6️⃣",                    "https://pastebin.com/raw/MDhqkib4", "Hubs" },
    { "Hotdog V4 🌭",                  "https://pastefy.app/GzxmSIIn/raw",  "Hubs" },
    { "Script do Kay V2 🔥",           "https://pastebin.com/raw/eXGuwWWE", "Hubs" },
    { "DD Osama V5 🇺🇸",               "https://pastebin.com/raw/NxpP7iWb", "Hubs" },
    { "Lukinhas Hub 💙",               "https://pastebin.com/raw/dhxQnF4b", "Hubs" },
    { "Pirulito Hub 🍭",               "https://pastebin.com/raw/A0xCHTGM", "Hubs" },
    { "Toni Kroos 🍀",                 "https://pastebin.com/raw/bCL22UZw", "Hubs" },
    { "X10 Premium Hub 💎",            "https://pastebin.com/raw/MW2Zyv6z", "Hubs" },
    { "Sforza Hub 🔧",                 "https://pastebin.com/raw/pdyfSjzK", "Hubs" },
    { "Zyck ☠️",                       "https://pastebin.com/raw/WYeG9ypc", "Hubs" },
    { "Abençoado 777 👼",              "https://raw.githubusercontent.com/admpietrovinicius-debug/Aben-oado-777/refs/heads/main/Aben%C3%A7oado777.lua", "Hubs" },
    { "Script Da Debinha 🥀",          "https://pastefy.app/9k4tL5Q7/raw",  "Hubs" },
    { "Tubaina Hub 🥶",                "https://pastefy.app/xLM92mP5/raw",  "Hubs" },
    { "Anti Roubo Bola ⚽ [KEY: KWLS]", "https://pastebin.com/raw/4GXQEjAs", "Com Key" },
    { "Sixxinho Hub 🔒 [KEY: SWGK]",   "https://raw.githubusercontent.com/josegaviao888-alt/Six-Hub-Privdo/refs/heads/main/Six%20hUB", "Com Key" },
    { "Anti Pulo Foldenxz 🚫",         "https://pastebin.com/raw/d2T3QxGt", "Anti Pulo" },
    { "Anti Pulo Elias 🚫",            "https://pastebin.com/raw/mgzrnsbr", "Anti Pulo" },
    { "Zyck Anti Pulo 🚫",             "https://pastebin.com/raw/MCTcaHZq", "Anti Pulo" },
}

local CATEGORIES = {
    "Todos", "Condução", "Chute", "Defesa", "Atravessar",
    "Bugs", "Otimização", "Hubs", "Com Key", "Anti Pulo",
}

--====================================================================
-- LOADER
--====================================================================
local ExternalLoader = {}
function ExternalLoader.canLoad()
    return (typeof(loadstring) == "function") or (typeof(load) == "function")
end
function ExternalLoader.load(name, url)
    if not ExternalLoader.canLoad() then
        AuditLog.add(name, url, false, "loadstring indisponível")
        return false, "loadstring indisponível"
    end
    if State.UI.testMode then
        print(string.format("[ANTICHEAT TEST] Carregando: %s (%s)", name, url))
    end
    local ok, err = pcall(function()
        local source = game:HttpGet(url)
        if not source or #source < 10 then error("Resposta vazia") end
        local fn = (typeof(loadstring) == "function") and loadstring(source) or load(source)
        if not fn then error("Falha ao compilar") end
        fn()
    end)
    if ok then
        AuditLog.add(name, url, true)
        return true
    else
        AuditLog.add(name, url, false, tostring(err))
        warn("[Soccer Hub] Erro em '" .. name .. "': " .. tostring(err))
        return false, err
    end
end

--====================================================================
-- UI
--====================================================================
local UI = {}
local refs = { gui=nil, mainFrame=nil, content=nil, tabs={}, pages={} }

local function createRootGui()
    local gui = Utils.create("ScreenGui", {
        Name = "SoccerHubTest", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true,
    })
    if gethui then pcall(function() gui.Parent = gethui() end) end
    if not gui.Parent then
        local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not ok or not gui.Parent then
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    refs.gui = gui
end

local function createFloatingButton()
    local theme = getTheme()
    local btn = Utils.create("TextButton", {
        Size = UDim2.fromOffset(56, 56),
        Position = UDim2.new(0, 20, 0.5, -28),
        BackgroundColor3 = theme.accent,
        Text = "⚽", TextSize = 28, Font = Enum.Font.GothamBold,
        TextColor3 = Color3.new(1,1,1), AutoButtonColor = false,
        Visible = false, Parent = refs.gui,
    })
    Utils.corner(btn, 28)
    Utils.stroke(btn, Color3.new(1,1,1), 2)
    btn.MouseButton1Click:Connect(function() UI.toggle(true) end)
end

local function createMainWindow()
    local theme = getTheme()
    local main = Utils.create("Frame", {
        Size = UDim2.fromOffset(360, 480),
        Position = UDim2.new(0.5, -180, 0.5, -240),
        BackgroundColor3 = theme.bg,
        BorderSizePixel = 0, ClipsDescendants = true, Parent = refs.gui,
    })
    Utils.corner(main, 14)
    Utils.stroke(main, theme.stroke, 1)
    refs.mainFrame = main
end

local function createHeader(parent)
    local theme = getTheme()
    local header = Utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = theme.bgLight,
        BorderSizePixel = 0, Parent = parent,
    })
    Utils.corner(header, 14)
    Utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = theme.bgLight, BorderSizePixel = 0, Parent = header,
    })
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = "⚽  Soccer Hub [TEST]",
        TextColor3 = theme.text, TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = header,
    })
    if State.Access.level == "admin" then
        local badge = Utils.create("TextLabel", {
            Size = UDim2.fromOffset(70, 20),
            Position = UDim2.new(1, -150, 0.5, -10),
            BackgroundColor3 = theme.warn,
            Text = "🛡 ADMIN",
            TextColor3 = Color3.new(0,0,0), TextSize = 10,
            Font = Enum.Font.GothamBold, Parent = header,
        })
        Utils.corner(badge, 6)
    end
    local minBtn = Utils.create("TextButton", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(1, -68, 0.5, -14),
        BackgroundColor3 = theme.accentOff, Text = "—",
        TextColor3 = theme.text, TextSize = 16,
        Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = header,
    })
    Utils.corner(minBtn, 8)
    local closeBtn = Utils.create("TextButton", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(1, -34, 0.5, -14),
        BackgroundColor3 = theme.danger, Text = "✕",
        TextColor3 = Color3.new(1,1,1), TextSize = 14,
        Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = header,
    })
    Utils.corner(closeBtn, 8)
    minBtn.MouseButton1Click:Connect(function() UI.minimize(not State.UI.minimized) end)
    closeBtn.MouseButton1Click:Connect(function() UI.toggle(false) end)
end

local function createTabBar(parent)
    local theme = getTheme()
    local bar = Utils.create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 34),
        Position = UDim2.new(0, 10, 0, 54),
        BackgroundTransparency = 1, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X, Parent = parent,
    })
    Utils.create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = bar,
    })
    local tabs = {
        { name = "Futebol", icon = "⚽" },
        { name = "Scripts", icon = "📜" },
        { name = "Auditoria", icon = "🔍" },
        { name = "Config", icon = "⚙️" },
    }
    for _, d in ipairs(tabs) do
        local b = Utils.create("TextButton", {
            Name = d.name, Size = UDim2.fromOffset(88, 30),
            BackgroundColor3 = (State.UI.tab == d.name) and theme.accent or theme.accentOff,
            Text = d.icon .. "  " .. d.name,
            TextColor3 = theme.text, TextSize = 12,
            Font = Enum.Font.GothamMedium, AutoButtonColor = false, Parent = bar,
        })
        Utils.corner(b, 8)
        refs.tabs[d.name] = b
        b.MouseButton1Click:Connect(function() UI.switchTab(d.name) end)
    end
end

local function createContentArea(parent)
    refs.content = Utils.create("Frame", {
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 94),
        BackgroundTransparency = 1, Parent = parent,
    })
end

local function createPage(name)
    local page = Utils.create("ScrollingFrame", {
        Name = name, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 4, ScrollBarImageColor3 = getTheme().accent,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = (State.UI.tab == name), Parent = refs.content,
    })
    Utils.create("UIListLayout", {
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page,
    })
    Utils.create("UIPadding", {
        PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = page,
    })
    refs.pages[name] = page
    return page
end

--====================================================================
-- COMPONENTES
--====================================================================
local Components = {}

function Components.toggle(parent, label, initialValue, callback)
    local theme = getTheme()
    local isOn = initialValue and true or false
    local row = Utils.create("Frame", {
        Size = UDim2.new(1, -8, 0, 52),
        BackgroundColor3 = theme.bgLight, BorderSizePixel = 0, Parent = parent,
    })
    Utils.corner(row, 10)
    Utils.stroke(row, theme.stroke, 1)
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = theme.text, TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local statusLabel = Utils.create("TextLabel", {
        Size = UDim2.fromOffset(50, 22), Position = UDim2.new(1, -76, 0.5, -11),
        BackgroundColor3 = isOn and theme.accent or theme.accentOff,
        Text = isOn and "ON" or "OFF",
        TextColor3 = Color3.new(1,1,1), TextSize = 12,
        Font = Enum.Font.GothamBold, Parent = row,
    })
    Utils.corner(statusLabel, 6)
    local click = Utils.create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = row,
    })
    local function setState(s, silent)
        isOn = s
        statusLabel.Text = isOn and "ON" or "OFF"
        Utils.tween(statusLabel, 0.2, {
            BackgroundColor3 = isOn and theme.accent or theme.accentOff,
        })
        if not silent and callback then pcall(callback, isOn) end
    end
    click.MouseButton1Click:Connect(function() setState(not isOn) end)
    if callback then pcall(callback, isOn) end
end

function Components.slider(parent, label, min, max, initial, callback)
    local theme = getTheme()
    local value = math.clamp(initial or min, min, max)
    local row = Utils.create("Frame", {
        Size = UDim2.new(1, -8, 0, 62),
        BackgroundColor3 = theme.bgLight, BorderSizePixel = 0, Parent = parent,
    })
    Utils.corner(row, 10)
    Utils.stroke(row, theme.stroke, 1)
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 24), Position = UDim2.new(0, 14, 0, 6),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = theme.text, TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local valueLabel = Utils.create("TextLabel", {
        Size = UDim2.fromOffset(50, 24), Position = UDim2.new(1, -64, 0, 6),
        BackgroundTransparency = 1, Text = tostring(math.floor(value)),
        TextColor3 = theme.accent, TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
    })
    local track = Utils.create("Frame", {
        Size = UDim2.new(1, -28, 0, 8), Position = UDim2.new(0, 14, 0, 40),
        BackgroundColor3 = theme.accentOff, BorderSizePixel = 0, Parent = row,
    })
    Utils.corner(track, 4)
    local fill = Utils.create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = theme.accent, BorderSizePixel = 0, Parent = track,
    })
    Utils.corner(fill, 4)
    local knob = Utils.create("Frame", {
        Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0),
        BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 2, Parent = track,
    })
    Utils.corner(knob, 9)
    local hitbox = Utils.create("TextButton", {
        Size = UDim2.new(1, 0, 3, 0), Position = UDim2.new(0, 0, -1, 0),
        BackgroundTransparency = 1, Text = "", Parent = track,
    })
    local dragging = false
    local function updateFromX(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * rel
        valueLabel.Text = tostring(math.floor(value))
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        if callback then pcall(callback, value) end
    end
    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Components.button(parent, label, callback, color)
    local theme = getTheme()
    local btn = Utils.create("TextButton", {
        Size = UDim2.new(1, -8, 0, 44),
        BackgroundColor3 = color or theme.accent, Text = label,
        TextColor3 = Color3.new(1,1,1), TextSize = 14,
        Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = parent,
    })
    Utils.corner(btn, 10)
    btn.MouseButton1Down:Connect(function() Utils.tween(btn, 0.1, { Size = UDim2.new(1, -16, 0, 42) }) end)
    btn.MouseButton1Up:Connect(function() Utils.tween(btn, 0.1, { Size = UDim2.new(1, -8, 0, 44) }) end)
    btn.MouseLeave:Connect(function() Utils.tween(btn, 0.1, { Size = UDim2.new(1, -8, 0, 44) }) end)
    btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
    return btn
end

function Components.section(parent, title)
    return Utils.create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 24),
        BackgroundTransparency = 1, Text = title,
        TextColor3 = getTheme().textDim, TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = parent,
    })
end

function Components.scriptButton(parent, name, url, category)
    local theme = getTheme()
    local row = Utils.create("Frame", {
        Size = UDim2.new(1, -8, 0, 56),
        BackgroundColor3 = theme.bgLight, BorderSizePixel = 0, Parent = parent,
    })
    Utils.corner(row, 10)
    Utils.stroke(row, theme.stroke, 1)
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -90, 0, 24), Position = UDim2.new(0, 14, 0, 6),
        BackgroundTransparency = 1, Text = name,
        TextColor3 = theme.text, TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -90, 0, 16), Position = UDim2.new(0, 14, 0, 30),
        BackgroundTransparency = 1, Text = category,
        TextColor3 = theme.textDim, TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local action = Utils.create("TextButton", {
        Size = UDim2.fromOffset(56, 32), Position = UDim2.new(1, -68, 0.5, -16),
        BackgroundColor3 = theme.accent, Text = "▶",
        TextColor3 = Color3.new(1,1,1), TextSize = 16,
        Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = row,
    })
    Utils.corner(action, 8)
    local pending = false
    local function resetPending()
        pending = false
        action.Text = "▶"
        Utils.tween(action, 0.2, { BackgroundColor3 = theme.accent })
    end
    action.MouseButton1Click:Connect(function()
        if not pending then
            pending = true
            action.Text = "✓?"
            Utils.tween(action, 0.2, { BackgroundColor3 = theme.warn })
            task.delay(3, function() if pending then resetPending() end end)
        else
            resetPending()
            local ok = ExternalLoader.load(name, url)
            if ok then
                action.Text = "✓"
                Utils.tween(action, 0.2, { BackgroundColor3 = theme.accent })
                task.delay(1, function() action.Text = "▶" end)
            else
                action.Text = "✕"
                Utils.tween(action, 0.2, { BackgroundColor3 = theme.danger })
                task.delay(1.5, function() resetPending() end)
            end
        end
    end)
    return row
end

--====================================================================
-- PÁGINAS
--====================================================================
local function buildFutebolPage()
    local page = createPage("Futebol")
    Components.section(page, "AÇÕES DE FUTEBOL (PRÓPRIAS)")
    Components.toggle(page, "🧲  Ímã de Bola", State.Soccer.ballMagnet,
        function(v) State.Soccer.ballMagnet = v end)
    Components.toggle(page, "⚽  Controle de Bola", State.Soccer.ballControl,
        function(v) State.Soccer.ballControl = v end)
    Components.section(page, "AJUSTES")
    Components.slider(page, "Força do Chute", 10, 100, State.Soccer.shootPower,
        function(v) State.Soccer.shootPower = v end)
    Components.slider(page, "Alcance do Ímã", 5, 60, State.Soccer.magnetRange,
        function(v) State.Soccer.magnetRange = v end)
end

local function rebuildScriptsList()
    local page = refs.pages["Scripts"]
    if not page then return end
    for _, c in ipairs(page:GetChildren()) do
        if c:IsA("Frame") and c.Name == "ScriptRow" then c:Destroy() end
    end
    for _, entry in ipairs(ExternalRegistry) do
        local name, url, cat = entry[1], entry[2], entry[3] or "Hubs"
        if State.UI.filter == "Todos" or State.UI.filter == cat then
            local row = Components.scriptButton(page, name, url, cat)
            row.Name = "ScriptRow"
        end
    end
end

local function buildScriptsPage()
    local page = createPage("Scripts")
    local theme = getTheme()
    Components.section(page, "📜  SCRIPTS ALTERNATIVOS")
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 30),
        BackgroundTransparency = 1,
        Text = "⚠️ Scripts de terceiros. Toque 2x para confirmar.",
        TextColor3 = theme.textDim, TextSize = 10,
        Font = Enum.Font.Gotham, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = page,
    })
    local chips = Utils.create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 0, 32),
        BackgroundTransparency = 1, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X, Parent = page,
    })
    Utils.create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = chips,
    })
    local chipRefs = {}
    local function updateChips()
        for cat, chip in pairs(chipRefs) do
            Utils.tween(chip, 0.15, {
                BackgroundColor3 = (State.UI.filter == cat) and theme.accent or theme.accentOff,
            })
        end
    end
    for _, cat in ipairs(CATEGORIES) do
        local chip = Utils.create("TextButton", {
            Size = UDim2.fromOffset(0, 28),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = (State.UI.filter == cat) and theme.accent or theme.accentOff,
            Text = "  " .. cat .. "  ",
            TextColor3 = theme.text, TextSize = 11,
            Font = Enum.Font.GothamMedium, AutoButtonColor = false, Parent = chips,
        })
        Utils.corner(chip, 14)
        chipRefs[cat] = chip
        chip.MouseButton1Click:Connect(function()
            State.UI.filter = cat
            updateChips()
            rebuildScriptsList()
        end)
    end
    rebuildScriptsList()
end

local function buildAuditoriaPage()
    local page = createPage("Auditoria")
    local theme = getTheme()
    Components.section(page, "🔍  LOG DE EXECUÇÃO")
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 40),
        BackgroundTransparency = 1,
        Text = "Registra cada script carregado.",
        TextColor3 = theme.textDim, TextSize = 10,
        Font = Enum.Font.Gotham, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = page,
    })
    Components.toggle(page, "🔬 Modo Teste Anticheat", State.UI.testMode,
        function(v) State.UI.testMode = v end)
    Components.button(page, "📋 Copiar Log (console)", function()
        print("========== AUDIT LOG ==========")
        print(AuditLog.dump())
        print("===============================")
    end, Color3.fromRGB(90, 130, 220))
    Components.button(page, "🗑 Limpar Log", function()
        AuditLog.entries = {}
    end, Color3.fromRGB(200, 70, 70))
end

local function buildConfigPage()
    local page = createPage("Config")
    Components.section(page, "INTERFACE")
    Components.button(page, "🔄 Alternar Tema", function()
        State.UI.theme = (State.UI.theme == "Dark") and "Light" or "Dark"
        UI.refreshTheme()
    end, Color3.fromRGB(90, 100, 220))
    Components.button(page, "💬 Copiar Nosso Discord", function()
        if copyToClipboard(Config.DISCORD_URL) then
            print("[Soccer Hub] Discord copiado.")
        else
            warn("[Soccer Hub] Link: " .. Config.DISCORD_URL)
        end
    end, getTheme().discord)

    -- Info do usuário atual
    Components.section(page, "SUA KEY")
    local infoText = "Acesso: " .. tostring(State.Access.level or "?")
    if State.Access.keyData then
        local kd = State.Access.keyData
        if kd.expires and kd.expires > 0 then
            infoText = infoText .. "\nExpira: " .. KeyManager.formatTime(kd.expires)
        else
            infoText = infoText .. "\nExpira: Permanente"
        end
        infoText = infoText .. "\nHWID vinculado: " .. string.sub(tostring(kd.hwid or MY_HWID), 1, 20) .. "..."
    end
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 70),
        BackgroundTransparency = 1,
        Text = infoText,
        TextColor3 = getTheme().textDim, TextSize = 11,
        Font = Enum.Font.Gotham, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = page,
    })

    if State.Access.level == "admin" and KeyManager.isOwner() then
        Components.section(page, "🛡  PAINEL ADMIN")
        Components.button(page, "🛡  Abrir Painel Admin", function()
            AdminPanel.show()
        end, getTheme().warn)
    end

    Components.section(page, "INFORMAÇÕES")
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -8, 0, 60),
        BackgroundTransparency = 1,
        Text = string.format(
            "Soccer Hub v4.0 — Build Privada\nArmazenamento: %s\nHWID: %s...",
            FileStore.supported and "✅ arquivo local" or "⚠️ só em memória",
            string.sub(MY_HWID, 1, 12)
        ),
        TextColor3 = getTheme().textDim, TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = page,
    })
end

--====================================================================
-- 🛡 PAINEL ADMIN (novo layout com 3 botões)
--====================================================================
AdminPanel = {}

function AdminPanel.show()
    if not (KeyManager.isOwner() and State.Access.level == "admin") then
        warn("[Soccer Hub] Acesso negado.")
        return
    end

    local theme = getTheme()
    local gui = Utils.create("ScreenGui", {
        Name = "SoccerHubAdmin", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true,
    })
    if gethui then pcall(function() gui.Parent = gethui() end) end
    if not gui.Parent then
        local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not ok or not gui.Parent then
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end

    local main = Utils.create("Frame", {
        Size = UDim2.fromOffset(380, 500),
        Position = UDim2.new(0.5, -190, 0.5, -250),
        BackgroundColor3 = theme.bg,
        BorderSizePixel = 0, ClipsDescendants = true, Parent = gui,
    })
    Utils.corner(main, 14)
    Utils.stroke(main, theme.warn, 1.5)

    -- Header
    local header = Utils.create("Frame", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = theme.bgLight,
        BorderSizePixel = 0, Parent = main,
    })
    Utils.corner(header, 14)
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = "🛡  Painel Admin",
        TextColor3 = theme.warn, TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = header,
    })
    local closeBtn = Utils.create("TextButton", {
        Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, -34, 0.5, -14),
        BackgroundColor3 = theme.danger, Text = "✕",
        TextColor3 = Color3.new(1,1,1), TextSize = 14,
        Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = header,
    })
    Utils.corner(closeBtn, 8)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Info topo
    local statusInfo = Utils.create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, 54),
        BackgroundTransparency = 1, Text = "",
        TextColor3 = theme.textDim, TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = main,
    })

    -- Linha dos 3 botões de duração
    local btnRow = Utils.create("Frame", {
        Size = UDim2.new(1, -20, 0, 50), Position = UDim2.new(0, 10, 0, 80),
        BackgroundTransparency = 1, Parent = main,
    })
    Utils.create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder, Parent = btnRow,
    })

    local function mkDurBtn(text, days, color)
        local b = Utils.create("TextButton", {
            Size = UDim2.new(0.333, -4, 1, 0),
            BackgroundColor3 = color,
            Text = text,
            TextColor3 = Color3.new(1,1,1), TextSize = 12,
            Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = btnRow,
        })
        Utils.corner(b, 10)
        return b
    end

    -- Título da lista
    Utils.create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 138),
        BackgroundTransparency = 1,
        Text = "KEYS GERADAS",
        TextColor3 = theme.textDim, TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = main,
    })

    -- Lista scrollable
    local list = Utils.create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -240),
        Position = UDim2.new(0, 10, 0, 162),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 4, ScrollBarImageColor3 = theme.warn,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = main,
    })
    Utils.create("UIListLayout", {
        Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list,
    })

    local function refreshList()
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        local entries = KeyManager.list()
        statusInfo.Text = string.format(
            "Keys ativas: %d  •  Arquivo: %s",
            #entries,
            FileStore.supported and "✅ salvando" or "⚠️ em memória"
        )
        if #entries == 0 then
            Utils.create("TextLabel", {
                Size = UDim2.new(1, -8, 0, 40),
                BackgroundTransparency = 1,
                Text = "(nenhuma key gerada)\nEscolha uma duração acima",
                TextColor3 = theme.textDim, TextSize = 11,
                Font = Enum.Font.Gotham, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = list,
            })
            return
        end

        for _, item in ipairs(entries) do
            local row = Utils.create("Frame", {
                Size = UDim2.new(1, -8, 0, 56),
                BackgroundColor3 = theme.bgLight,
                BorderSizePixel = 0, Parent = list,
            })
            Utils.corner(row, 8)
            Utils.stroke(row, theme.stroke, 1)

            -- Nome da key
            local keyLbl = Utils.create("TextLabel", {
                Size = UDim2.new(1, -130, 0, 20), Position = UDim2.new(0, 12, 0, 6),
                BackgroundTransparency = 1, Text = item.key,
                TextColor3 = theme.text, TextSize = 12,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
            })

            -- Info de expiração / HWID
            local infoText
            local infoColor
            if item.expires == 0 then
                infoText = "♾️  Permanente"
                infoColor = theme.purple
            else
                local daysLeft = KeyManager.daysLeft(item.expires)
                if daysLeft <= 0 then
                    infoText = "❌  Expirada em " .. KeyManager.formatTime(item.expires)
                    infoColor = theme.danger
                else
                    infoText = string.format("📅  %d dia(s) — expira %s",
                        daysLeft, KeyManager.formatTime(item.expires))
                    infoColor = theme.success
                end
            end
            -- Anexa info de HWID
            if item.hwid then
                infoText = infoText .. "  •  🔒 vinculada"
            else
                infoText = infoText .. "  •  🔓 livre"
            end

            Utils.create("TextLabel", {
                Size = UDim2.new(1, -130, 0, 16), Position = UDim2.new(0, 12, 0, 28),
                BackgroundTransparency = 1, Text = infoText,
                TextColor3 = infoColor, TextSize = 10,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
            })

            -- Botão copiar
            local copyBtn = Utils.create("TextButton", {
                Size = UDim2.fromOffset(52, 40), Position = UDim2.new(1, -120, 0.5, -20),
                BackgroundColor3 = theme.accent, Text = "Copiar",
                TextColor3 = Color3.new(1,1,1), TextSize = 10,
                Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = row,
            })
            Utils.corner(copyBtn, 6)
            copyBtn.MouseButton1Click:Connect(function()
                if copyToClipboard(item.key) then
                    copyBtn.Text = "✓"
                    task.delay(1, function() copyBtn.Text = "Copiar" end)
                end
            end)

            -- Botão revogar
            local delBtn = Utils.create("TextButton", {
                Size = UDim2.fromOffset(52, 40), Position = UDim2.new(1, -60, 0.5, -20),
                BackgroundColor3 = theme.danger, Text = "Revogar",
                TextColor3 = Color3.new(1,1,1), TextSize = 10,
                Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = row,
            })
            Utils.corner(delBtn, 6)
            delBtn.MouseButton1Click:Connect(function()
                KeyManager.revoke(item.key)
                refreshList()
            end)
        end
    end

    -- Cria os 3 botões de duração
    local day1Btn  = mkDurBtn("+ 1 DIA",   1,   theme.accent)
    local day7Btn  = mkDurBtn("+ 7 DIAS",  7,   theme.discord)
    local permBtn  = mkDurBtn("PERMANENTE", nil, theme.purple)

    -- Handler genérico
    local function generateAndShow(days, btn)
        local newKey, expires = KeyManager.generate(days)
        local originalText = btn.Text
        if copyToClipboard(newKey) then
            btn.Text = "✓ Copiada!"
        else
            btn.Text = "✓ " .. string.sub(newKey, 8)
        end
        refreshList()
        task.delay(2, function() btn.Text = originalText end)
        -- Mostra a key completa num print (caso o clipboard falhe)
        local durStr = days and (days .. " dia(s)") or "permanente"
        print(string.format("[Admin] Key gerada (%s): %s", durStr, newKey))
        if expires and expires > 0 then
            print(string.format("[Admin] Expira em: %s", KeyManager.formatTime(expires)))
        end
    end

    day1Btn.MouseButton1Click:Connect(function() generateAndShow(1, day1Btn) end)
    day7Btn.MouseButton1Click:Connect(function() generateAndShow(7, day7Btn) end)
    permBtn.MouseButton1Click:Connect(function() generateAndShow(nil, permBtn) end)

    -- Aviso se arquivo não suportado
    if not FileStore.supported then
        Utils.create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 1, -60),
            BackgroundTransparency = 1,
            Text = "⚠️ Seu executor não suporta writefile. Keys somem ao fechar.",
            TextColor3 = theme.warn, TextSize = 10,
            Font = Enum.Font.Gotham, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = main,
        })
    end

    refreshList()
end

--====================================================================
-- API UI
--====================================================================
function UI.switchTab(name)
    State.UI.tab = name
    local theme = getTheme()
    for tn, b in pairs(refs.tabs) do
        Utils.tween(b, 0.2, {
            BackgroundColor3 = (tn == name) and theme.accent or theme.accentOff,
        })
    end
    for pn, p in pairs(refs.pages) do p.Visible = (pn == name) end
end

function UI.toggle(v)
    State.UI.visible = v
    if refs.mainFrame then refs.mainFrame.Visible = v end
    if refs.gui and refs.gui:FindFirstChild("FloatingBtn") then
        refs.gui.FloatingBtn.Visible = not v
    end
end

function UI.minimize(m)
    State.UI.minimized = m
    if not refs.mainFrame then return end
    Utils.tween(refs.mainFrame, 0.3, {
        Size = m and UDim2.fromOffset(360, 46) or UDim2.fromOffset(360, 480),
    })
end

function UI.refreshTheme()
    if refs.gui then
        refs.gui:Destroy()
        refs.gui = nil
        refs.tabs = {}
        refs.pages = {}
    end
    UI.build()
end

function UI.build()
    createRootGui()
    createFloatingButton()
    createMainWindow()
    createHeader(refs.mainFrame)
    createTabBar(refs.mainFrame)
    createContentArea(refs.mainFrame)
    buildFutebolPage()
    buildScriptsPage()
    buildAuditoriaPage()
    buildConfigPage()
    UI.switchTab(State.UI.tab)
end

--====================================================================
-- KEYBIND
--====================================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == State.Keybinds.toggleUI then
        UI.toggle(not State.UI.visible)
    end
end)

--====================================================================
-- 🚀 INICIALIZAÇÃO
--====================================================================
KeyManager.load()
LoginScreen.show(function(level, info)
    State.Access.level = level
    State.Access.keyData = info
    print(string.format("[Soccer Hub] Acesso: %s", level))
    UI.build()
    print("✅ Soccer Hub v4.0 carregado.")
    if level == "admin" then
        print("🛡 Bem-vindo, owner. Painel admin na aba Config.")
    end
end)
