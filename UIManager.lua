local uiBehaviour = require("UI/UIBehaviour")

local Path_UIPrefab = "Prefabs/UIPrefabs/"
local Path_UIScript = "Logics/UIScripts/"

local GameObject = CS.UnityEngine.GameObject
local UIManager = class()

local uiRoot = nil
local uiCamera = nil

local panelMap = {}
local panelQueue = {count = 0}

---判断面板是否已经加载
---@param name string
---@return boolean
local IsLoad = function(name)
    return panelMap[name] ~= nil
end

---判断面板是否已经打开
---@param name any
---@return boolean
local IsOpen = function(name)
    if IsLoad(name) == false then
        return false
    end

    local panel = panelMap[name]
    return panel.script.active
end

---加载UI
---@param name string
---@return table
local LoadUI = function(name)
    local path = Path_UIPrefab .. name

    if IsLoad(name) == false then
        local asset = AssetManager.Load(path, typeof(GameObject))
        local gameObject = AssetManager.Instantiate(asset, uiRoot)

        local canvas = gameObject:AddComponent(typeof(CS.UnityEngine.Canvas))
        local rayCaster = gameObject:AddComponent(typeof(CS.UnityEngine.UI.GraphicRaycaster))
        local canvasGroup = gameObject:AddComponent(typeof(CS.UnityEngine.CanvasGroup))
        canvas.overrideSorting = true

        local script = require(Path_UIScript .. name)
        setmetatable(script, uiBehaviour)

        local panelData = {
            name = name,
            fullName = path,
            gameObject = gameObject,
            canvas = canvas,
            rayCaster = rayCaster,
            canvasGroup = canvasGroup,
            script = script
        }

        panelMap[name] = panelData
        script:__Init(panelData)
    end

    return panelMap[name]
end

local GetNextLayer = function()
    local index = panelQueue.count
    local layer = 0
    if index > 0 then
        layer = panelQueue[index].script:GetLayer() + 20
    end
    return layer
end

local Update = function()
    for key, value in ipairs(panelQueue) do
        value.script:__Update()
    end
end

local OpenPanel = function(name, layer)
    --print("OpenPanel:"..name)

    local panel = LoadUI(name)

    if panel.script.active then
        return panel
    end

    panel.script:__Open()

    if layer == nil then
        layer = GetNextLayer()
    end

    panel.script:SetLayer(layer)
    panelQueue.count = panelQueue.count + 1
    panelQueue[panelQueue.count] = panel
end

local ClosePanel = function(name)
    local count = panelQueue.count

    if count <= 0 then
        return
    end

    local panel = nil
    local index = count

    if name ~= nil then
        while index > 0 do
            if panelQueue[index]["name"] == name then
                panel = panelQueue[index]
                break
            end
            index = index - 1
        end
    else
        panel = panelQueue[index]
    end

    if panel == nil then
        print("ClosePanel Error:" .. name)
        return
    end
    --print("ClosePanel:"..panelQueue[index].name)
    panel.script:__Close()

    panelQueue.count = panelQueue.count - 1

    for i = index, count do
        panelQueue[i] = panelQueue[i + 1]
    end

end

UIManager.OpenPanel = OpenPanel
UIManager.ClosePanel = ClosePanel
UIManager.Update = Update

UIManager.ctor = function()
    if uiRoot == nil then
        uiRoot = GameObject.Find("MainCanvas/RootNode").transform
    end

    MonoManager:AddUpdate("UIManager.Update", Update)
end

return UIManager.new()
