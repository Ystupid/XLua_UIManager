local UIBehaviour = {
    __index = 
    {
        __Init = function(self, panelData)
            self.active = false
            self.name = panelData.name
            self.gameObject = panelData.gameObject
            self.transform = panelData.transform
            self.canvas = panelData.canvas
            self.canvasGroup = panelData.canvasGroup

            self:OnInit()
        end,

        __Open = function(self)
            self.active = true
            self:OpenTween()
            self:OnOpen()
        end,

        __Close = function(self)
            self.active = false
            self:CloseTween()
            self:OnClose()
        end,

        __Update = function(self)
            self:OnUpdate()
        end,

        GetLayer = function(self)
            return self.canvas.sortingOrder
        end,

        SetLayer = function(self, layer)
            self.canvas.sortingOrder = layer
            return self
        end,

        Close = function(self)
            UIManager.ClosePanel(self.name)
        end,

        OnInit = function(self)
        end,

        AddListener = function(self)
        end,

        OpenTween = function(self)
            self.canvasGroup.alpha = 1
            self.canvasGroup.interactable = true
            self.canvasGroup.blocksRaycasts = true
        end,

        OnOpen = function(self)
        end,

        CloseTween = function(self)
            self.canvasGroup.alpha = 0
            --self.canvasGroup.interactable = false
            self.canvasGroup.blocksRaycasts = false
            self:SetLayer(0)
        end,

        OnClose = function(self)
        end,

        OnUpdate = function(self)
        end
    }
}

return UIBehaviour
