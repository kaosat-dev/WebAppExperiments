define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  marionette = require 'marionette'
  vent = require '../core/vent'
  
  DataChannelView = require './dataChannelView'
  DataChannelRouter = require "./dataChannelRouter"
  ###############################
 
  class DataChannelApp extends Backbone.Marionette.Application
    title: "DataChannelApp"
    regions:
      mainRegion: "#dataChannelContent"
    
    constructor:(options)->
      super options
      @vent = vent
      @addRegions @regions
      
      @router = new DataChannelRouter
        controller: @
        
      @init()
      @on("start", @onStart)
      
    init:=>
      @addInitializer ->
        console.log "oh yeah, initializing"
        @vent.trigger "app:started", "#{@title}"
        
    onStart:()=>
      @mainRegion.show new DataChannelView()
      #@dummies.fetch()
    

      
  return DataChannelApp