local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataService = require(ReplicatedStorage.Source.Core.Framework.DataService).client
local MountUI = require(ReplicatedStorage.Source.StartUp.MountUI)
local PlotServiceClient = require(ReplicatedStorage.Source.Features.Plots.PlotServiceClient)
local Vfx = require(ReplicatedStorage.Source.Features.Vfx)
local UIController = require(ReplicatedStorage.Source.Features.App.UIController)
local DataTemplate = require(ReplicatedStorage.Source.Game.Items.DataTemplate)

DataService:init(DataTemplate)
UIController:init()
MountUI()
Vfx.init()
PlotServiceClient:init()
