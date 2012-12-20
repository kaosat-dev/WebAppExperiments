define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  marionette = require 'marionette'
  
  vent = require './coffeescad.vent'
  contentTemplate = require "text!modules/content.tmpl"
  DummySubApp = require 'modules/dummyModule/dummyApp'
  
  class MainLayout extends Backbone.Marionette.Layout
    template: contentTemplate
    regions:
      menu:    "#menu"
      content: "#content"
    
    events:
      "click .newDummy":    ()->vent.trigger("dummy:new")
      "click .deleteDummy": ()->vent.trigger("dummy:delete")
      "click .listDummies": ()->vent.trigger("dummy:list")
      "click .saveDummies": ()->vent.trigger("dummies:save")
      "click .dropBoxLogin": ()->vent.trigger("dropbox:login")
      "click .folderCreate": ()->vent.trigger("folder:create")
      
    constructor:(options)->
      super options
      
      
  class CoffeeScadApp extends Backbone.Marionette.Application
    root: "/WebAppExperiments/storage/backbone/index.html/"
    title: "Coffeescad"
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
      @initStorage()
      ###
      @vent.bind("downloadStlRequest", stlexport)
      @vent.bind("fileSaveRequest", saveProject)
      @vent.bind("fileLoadRequest", loadProject)
      @vent.bind("fileDeleteRequest", deleteProject)
      @vent.bind("editorShowRequest", showEditor)
      ###
      
    initLayout:=>
      @layout = new MainLayout()
      @headerRegion.show @layout
     
    initStorage:=>
      @dropBoxStorage = require './dummyModule/storage/dropboxStorage'
      @dropBoxStorage.authentificate()
    
    initSettings:->
      @settings = new Settings()
      @bindTo(@settings.get("General"), "change", @settingsChanged)
      
    onStart:()=>
      console.log "app started"
      #$("[rel=tooltip]").tooltip
      #  placement:'bottom' 
      #@glThreeView.fromCsg()#YIKES 
      dummySubApp = new DummySubApp
        regions: 
          mainRegion: "#content"#@layout.regions
      dummySubApp.start()
      
      
    onAppStarted:(appName)->
      console.log "I see app: #{appName} has started"
      
    onInitializeBefore:()->
      console.log "before init"
      
    onInitializeAfter:()=>
      """For exampel here close and 'please wait while app loads' display"""
      console.log "after init"
      
    onDropboxLoginRequested:()->
      @dropBoxStorage.authentificate()
    
    createFolder:()->
      console.log "trying to create folder"
      @dropBoxStorage.createFolder("blabla")
      
      

  return CoffeeScadApp   


