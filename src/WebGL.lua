local Common = require("src.Common")
local Output = require("src.Output")
local Mouse = require("src.Mouse")

local window = js.global

return function(properties)
    local self = {}
    self.properties = properties

    Common.init()
    Mouse.init()

    self.init()
    self.loop()

    window:addEventListener("resize", self.resize)

    self.init = function()
        self.properties.wrapper.prepend(Common.renderer.domElement)
        self.output = Output()
    end

    self.resize = function()
        Common.resize()
        self.output.resize()
    end

    self.render = function()
        Mouse.update()
        Common.update()
        self.output.update()
    end

    self.loop = function()
        self.render()
        window:requestAnimationFrame(self.loop)
    end
end