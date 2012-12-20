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
    path: ""
      
    constructor:(models,options)->
      super models,options
      @path = options.path
      @on('reset',()->console.log "reset collection")
      @on('fetch',()->console.log "fetching collection");

  return DummyCollection