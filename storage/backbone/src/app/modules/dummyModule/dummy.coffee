define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  boostrap = require 'bootstrap'
  marionette = require 'marionette'
  DropBoxStorage= require './storage/dropboxStorage'
  
  class Dummy extends Backbone.Model
    """PathRoot is used similarly to Backbones urlRoot"""
    defaults:
      name:     "mainPart"
      ext:      "coscad"
      content:  ""
      
    idAttribute: 'name'
    
    sync: DropBoxStorage.sync
    pathRoot: ""
    
    constructor:(attributes, options)->
      super attributes, options
      console.log attributes
      @pathRoot = options.pathRoot


  return Dummy