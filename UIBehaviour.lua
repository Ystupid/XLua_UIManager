local UIBehaviour = {}

UIBehaviour.__index = {}

UIBehaviour.__index.__Init = function (self,panelData)
    self.name = panelData.name
    self.gameObject = panelData.gameObject
    self.transform = panelData.transform
    self.canvas = panelData.canvas
    self.canvasGroup = panelData.canvasGroup

    self:OnInit()
end

UIBehaviour.__index.__Open = function (self)
    self:OpenTween()
    self:OnOpen()
end

UIBehaviour.__index.__Close = function (self)
    self:CloseTween()
    self:OnClose()
end

UIBehaviour.__index.__Update = function (self)
    self:OnUpdate()
end

UIBehaviour.__index.GetLayer = function (self)
    return self.canvas.sortingOrder
end

UIBehaviour.__index.SetLayer = function (self,layer)
    self.canvas.sortingOrder = layer
    return self
end

UIBehaviour.__index.Close = function (self)
    UIManager.ClosePanel(self.name)
end

UIBehaviour.__index.OnInit = function (self)

end

UIBehaviour.__index.AddListener = function (self)

end

UIBehaviour.__index.OpenTween = function (self)
    self.canvasGroup.alpha = 1
    self.canvasGroup.interactable = true
    self.canvasGroup.blocksRaycasts = true
end

UIBehaviour.__index.OnOpen = function (self)

end

UIBehaviour.__index.CloseTween = function (self)
    self.canvasGroup.alpha = 0
    --self.canvasGroup.interactable = false
    self.canvasGroup.blocksRaycasts = false
    self:SetLayer(0)
end

UIBehaviour.__index.OnClose = function (self)

end

UIBehaviour.__index.OnUpdate = function (self)

end

return UIBehaviour