define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  marionette = require 'marionette'
  
  vent = require './core/vent'
  DataChannelApp = require './dataChannel/dataChannelApp'
  contentTemplate = require "text!modules/content.tmpl"
  
  class MainLayout extends Backbone.Marionette.Layout
    template: contentTemplate
    regions:
      menu:    "#menu"
      content: "#content"
    
    events:
      "click .chatStart": ()->vent.trigger("chat:start")
      "click .chatStop": ()->vent.trigger("chat:stop")
      
    constructor:(options)->
      super options
      
      
  class WebRTCApp extends Backbone.Marionette.Application
    root: "/WebAppExperiments/webrtc/index.html/"
    title: "WebRtcExperiment"
    regions:
      headerRegion: "#header"
      mainRegion: "#content"
      
      
    constructor:(options)->
      super options
      @vent = vent
      @addRegions @regions
        
      @on("initialize:before",@onInitializeBefore)
      @on("initialize:after",@onInitializeAfter)
      @on("start", @onStart)
      @vent.on("app:started", @onAppStarted)
      @vent.on("dropbox:login",@onDropboxLoginRequested)
      @vent.on("folder:create",@createFolder)
      
      @initLayout()
     
    initLayout:=>
      @layout = new MainLayout()
      @headerRegion.show @layout
     
    initSettings:->
      @settings = new Settings()
      @bindTo(@settings.get("General"), "change", @settingsChanged)
      
    onStart:()=>
      console.log "app started"
      dataChannelApp = new DataChannelApp
        regions: 
          mainRegion: "#content"
      dataChannelApp.start()
      
    onAppStarted:(appName)->
      console.log "I see app: #{appName} has started"
      
    onInitializeBefore:()->
      console.log "before init"
      
    onInitializeAfter:()=>
      """For exampel here close and 'please wait while app loads' display"""
      console.log "after init"
      

  return WebRTCApp   


