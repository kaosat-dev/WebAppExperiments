define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  marionette = require 'marionette'
  vent = require '../coffeescad.vent'
  
  class DummyRouter extends Backbone.Marionette.AppRouter
    appRoutes: 
        "dummy:list"  : 'listDummies'
        "dummy:new"   : 'newDummy'
        "dummy:delete": 'deleteDummy'
        "dummy:save"  : 'saveDummy'
        "dummy:find"  : 'findDummy'
        "dummies:save": 'saveDummies'
        "dummies:fetch":'fetchDummies'
        
    constructor:(options)->
      super options
      @setController(options.controller)
      
    setController:(controller)=>
      @controller = controller
      for route, methodName of @appRoutes
        #console.log "Route: #{route} #{methodName}"
        vent.bind(route, @controller[methodName])
            
  return DummyRouter
