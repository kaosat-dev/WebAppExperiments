define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  marionette = require 'marionette'
  require 'bootstrap'


  app = new marionette.Application
    root: "/fg"
      
  app.addRegions
    navigationRegion: "#navigation"
    mainRegion: "#mainContent"
    statusRegion: "#statusBar"
    modal: ModalRegion
    dialogRegion: DialogRegion
    fileBrowseRegion: FileBrowseRegion
    
  app.on "start", (opts)->
    console.log "App Started"
    $("[rel=tooltip]").tooltip
      placement:'bottom' 
    
   # jquery_layout = require 'jquery_layout' 
   # $("body").layout({ applyDemoStyles: true })  
    
  app.on "initialize:after", ->
    console.log "after init"
    
    ###fetch all settings###
  app.addInitializer (options)->

    
  # Mix Backbone.Events, modules, and layout management into the app object.
  ###return _.extend app,
    module: (additionalProps)->
      return _.extend
        Views: {}
        additionalProps
  ###
  return app