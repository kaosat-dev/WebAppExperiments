define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  boostrap = require 'bootstrap'
  marionette = require 'marionette'
  
  vent = require '../core/vent'
  dummyTemplate = require "text!./dataChannel.tmpl"
  
  
  class DataChannelView extends Backbone.Marionette.ItemView
    template: dummyTemplate
    ui:
      contentEditor: "#messageEditor"
      
    events:
      'change textarea ': 'updateContent'

    constructor:(options)->
      super options
    
    delete:()->
      @model.destroy()
    
    updateContent:->
      console.log("blzh")
    
      

  return DataChannelView