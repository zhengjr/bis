object BisHttpServerHandlerMapWebModule: TBisHttpServerHandlerMapWebModule
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'Default'
      OnAction = BisHttpServerHandlerMapWebModuleDefaultAction
    end
    item
      Name = 'Distance'
      PathInfo = '/distance'
      OnAction = BisHttpServerHandlerMapWebModuleDistanceAction
    end
    item
      Name = 'Duration'
      PathInfo = '/duration'
      OnAction = BisHttpServerHandlerMapWebModuleDurationAction
    end
    item
      Name = 'Geocode'
      PathInfo = '/geocode'
      OnAction = BisHttpServerHandlerMapWebModuleGeocodeAction
    end
    item
      Name = 'Route'
      PathInfo = '/route'
      OnAction = BisHttpServerHandlerMapWebModuleRouteAction
    end>
  Height = 150
  Width = 215
end