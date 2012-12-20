define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  boostrap = require 'bootstrap'
  marionette = require 'marionette'
  
  vent = require '../coffeescad.vent'
  dummyTemplate = require "text!./dummy.tmpl"
  
  
  class DummyView extends Backbone.Marionette.ItemView
    template: dummyTemplate
    ui:
      contentEditor: "#contentEditor"
      
    events:
      'change textarea ': 'updateContent'
      'click .removeDummy': 'delete'
      'click .saveDummy': ()->vent.trigger("dummy:save", @model)

    constructor:(options)->
      super options
    
    delete:()->
      @model.destroy()
    
    updateContent:(event)->
      @model.set "content", @ui.contentEditor.val()
      
      
  class DummyCollectionView extends Backbone.Marionette.CollectionView
    itemView:DummyView
    
    constructor:(options)->
      super options
      @collection.bind('reset', @onCollectionReset)
    
    onCollectionReset:()->
      console.log "connection reset"

  return DummyCollectionView