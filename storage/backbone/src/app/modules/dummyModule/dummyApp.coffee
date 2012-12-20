define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  marionette = require 'marionette'
  vent = require '../coffeescad.vent'
  
  DummyCollectionView = require './dummyView'
  Dummy = require './dummy'
  DummyCollection = require './dummyCollection'
  DummyRouter = require "./dummyRouter"
  ###############################
 
  class DummySubApp extends Backbone.Marionette.Application
    title: "DummySubApp"
    regions:
      mainRegion: "#dummyContent"
    
    constructor:(options)->
      super options
      @vent = vent
      @addRegions @regions
      
      @router = new DummyRouter
        controller: @
        
      @init()
      @dummies = new DummyCollection null,
          path: "project1"

      @on("start", @onStart)
      
    init:=>
      @addInitializer ->
        console.log "oh yeah, initializing"
        @vent.trigger "app:started", "#{@title}"
        
    onStart:()=>
      #@dummies.fetch()
        
    newDummy:=>
      console.log "so you want a new dummy eh ?"
      @dummies.create(name: Math.random())
      
    saveDummy:(dummy)=>
      dummy.save()
      
    deleteDummy:=>
      console.log "killing a dummy"
    
    listDummies:=>
      console.log "showing dummies"
      @dummyView = new DummyCollectionView
        collection : @dummies
      @mainRegion.show(@dummyView)
      
    saveDummies:=>
      @dummy.save()
      
    fetchDummies:=>
      @dummies.fetch()#update:true)
      
    findDummy:(name)=>
      console.log "trying to find dummy called: #{name}"
      #result = @dummies.get(name)
      #console.log "result", result
      
      dummy = new Dummy null,
        options:
          pathRoot:"/project1"
      dummy.id =  "0.4431052121799439"#name
      toto = dummy.fetch()
      
  return DummySubApp