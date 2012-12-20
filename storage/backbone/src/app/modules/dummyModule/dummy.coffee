define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  boostrap = require 'bootstrap'
  marionette = require 'marionette'
  DropBoxStorage= require './storage/dropboxStorage'
  
  class Dummy extends Backbone.Model
    defaults:
      name:     "mainPart"
      ext:      "coscad"
      content:  ""
    
    idAttribute: 'name'
    sync: DropBoxStorage.sync
    
    constructor:(options)->
      super options
      @on("request",@toto)
    toto:->
      console.log "toto"
  

  return Dummy