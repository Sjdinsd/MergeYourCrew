local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotServiceClient = require(ReplicatedStorage.Source.Features.Plots.PlotServiceClient)

local Vfx = require(ReplicatedStorage.Source.Features.Vfx)
Vfx.init()

PlotServiceClient:init()

local dataservice = require(ReplicatedStorage.Packages.dataservice)
dataservice.client:init()
