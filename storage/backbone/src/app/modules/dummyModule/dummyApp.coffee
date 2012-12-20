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
      @dummies.fetch()
        
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
      
 
  #dummySubApp = new DummySubApp()
  return DummySubApp