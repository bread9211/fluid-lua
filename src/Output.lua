local window = js.global
local THREE = window.THREE

local Common = require("src.Common")
local Simulation = require("src.Simulation")

local get = require("utils.shaders")
local FaceVert = get("face.vert")
local ColorFrag = get("color.frag")

local Scene = THREE.Scene
local Camera = THREE.Camera
local Mesh = THREE.Mesh
local PlaneBufferGeometry = THREE.PlaneBufferGeometry
local RawShaderMaterial = THREE.RawShaderMaterial
local Vector2 = THREE.Vector2

local Output = {}
local OutputMT = {__index = Output}

function Output:new()
    print("Generating output...")

    local self = {}

    self.simulation = Simulation:new()
    self.scene = js.new(Scene)
    self.camera = js.new(Camera)
    self.output = js.new(Mesh, js.new(PlaneBufferGeometry, 2, 2), js.new(RawShaderMaterial, {
        vertexShader = FaceVert,
        fragmentShader = ColorFrag,
        uniforms = {
            velocity = {
                value = self.simulation.fbos.vel_0.texture,
            },
            boundarySpace = {
                value = js.new(Vector2),
            },
        },
    }))
    self.scene:add(self.output)

    print("Generated output")
    return setmetatable(self, OutputMT)
end

function Output:addScene(mesh)
    self.simulation:add(mesh)
end

function Output:resize()
    self.simulation:resize();
end

function Output:render()
    Common.renderer:setRenderTarget(nil);
    Common.renderer:render(self.scene, self.camera);
end

function Output:update()
    self.simulation:update();
    self:render();
end

print("Output.lua initialized")
return Output;