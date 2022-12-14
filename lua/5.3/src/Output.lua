local Common = require("src.Common")
local THREE = js.global.THREE

local Simulation = require("src.Simulation")
local Object = require("utils.convertToJSObject")
local new = require("utils.new")
local get = require("utils.shaders")
local face_vert = get("face.vert")
local color_frag = get("color.frag")

return function()
    local self = {}

    self.simulation = Simulation()

    self.scene = new(THREE.Scene)
    self.camera = new(THREE.Camera)
    self.output = new(THREE.Mesh,
        new(THREE.PlaneGeometry, 2, 2),
        new(THREE.RawShaderMaterial, Object({
            vertexShader = face_vert,
            fragmentShader = color_frag,
            uniforms = {
                velocity = {
                    value = self.simulation.fbos.vel_0.texture
                },
                boundarySpace = {
                    value = new(THREE.Vector2)
                },
                hue = {
                    value = self.simulation.options.hue
                },
                brightness = {
                    value = 1.0 - self.simulation.options.brightness
                },
                background = {
                    value = self.simulation.options.background
                }
            }
        }))
    )

    self.scene:add(self.output)

    self.addScene = function(mesh)
        self.scene:add(mesh)
    end

    self.resize = function()
        self.simulation.resize()
    end

    self.render = function()
        self.output.material.uniforms.hue.value = self.simulation.options.hue
        self.output.material.uniforms.brightness.value = 1.0 - self.simulation.options.brightness
        self.output.material.uniforms.background.value = self.simulation.options.background

        Common.renderer:setRenderTarget(nil)
        Common.renderer:render(self.scene, self.camera)
    end

    self.update = function()
        self.simulation.update()
        self.render()
    end

    return self
end