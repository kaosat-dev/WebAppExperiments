define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  boostrap = require 'bootstrap'
  marionette = require 'marionette'
  Dummy = require './dummy'
  DropBoxStorage= require './storage/dropboxStorage'
    
  class DummyCollection extends Backbone.Collection
    model: Dummy
    sync: DropBoxStorage.sync
      
    constructor:(models, options)->
      super models,options
      @path = options.path or ""
      @on('update', @onUpdate)
      @on('reset',  @onReset)
      @on('fetch',  ()->console.log "fetching collection")
    
    onReset:()->
      console.log "reset collection"
      console.log @
      
    onUpdate:()->
      console.log "updated collection"
      console.log @
      
  return DummyCollection