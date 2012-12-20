define (require)->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  LocalStorage = require 'localstorage'
  Dropbox = require "dropbox"
  
  class DropBoxStorage
    
    constructor:->
      @client = new Dropbox.Client
        key: "h8OY5h+ah3A=|AS0FmmbZJrmc8/QbpU6lMzrCd5lSGZPCKVtjMlA7ZA=="
        sandbox: true
      
    authentificate:()=>
      @client.authDriver new Dropbox.Drivers.Redirect(rememberUser:true, useQuery:true)
      @client.authenticate (error, client)=>
        if error
          return @showError(error)
        @validated()
        
    signOut:()->
      @client.signOut (error)=>
        if not error?
          console.log "signout ok"

    validated:()->
      console.log "all is fine"
      
    showError:(error)->
      console.log "error in dropbox"
      switch error.status
        when 401 then
          # If you're using dropbox.js, the only cause behind this error is that
          # the user token expired.
          # Get the user through the authentication flow again.
        when 404 then
          # The file or folder you tried to access is not in the user's Dropbox.
          # Handling this error is specific to your application.
        when 507 then
          # The user is over their Dropbox quota.
          # Tell them their Dropbox is full. Refreshing the page won't help.
        when 503 then
          # Too many API requests. Tell the user to try again later.
          # Long-term, optimize your code to use fewer API calls.
        when 400  then
          # Bad input parameter
        when 403 then 
          # Bad OAuth request.
        when 405 then
          # Request method not expected
        else
          # Caused by a bug in dropbox.js, in your application, or in Dropbox.
          # Tell the user an error occurred, ask them to refresh the page.
      
    sync:(method, model, options)=>
      console.log "dropbox storage"
      console.log "method "+method
      console.log "model"
      console.log model
      console.log "options"
      console.log options
      
      
      
      switch method
        when 'read' 
          console.log "reading"
          @findAll(model, options)
          
        when 'create'
          console.log "creating"
          
          unless model.id
            model.set model.id, model.idAttribute
            #model.id = guid()
          
          console.log("id"+model.get("id"))
          id = model.id
          if model.get "ext"
            id = "#{id}.#{model.get('ext')}"
          @writeFile(id, JSON.stringify(model))
          return model.toJSON()
          
        when 'update'
          console.log "updating"
          id = model.id
          if model.get "ext"
            id = "#{id}.#{model.get('ext')}"
          if model.collection.path?
            id ="#{model.collection.path}/#{id}"
          console.log "id: #{id}"
          @writeFile(id, JSON.stringify(model))
          return model.toJSON()
          
        when 'delete'
          console.log "deleting"
          console.log model
          id = model.id
          if model.get "ext"
            id = "#{id}.#{model.get('ext')}"
          if model.collection.path?
            id ="#{model.collection.path}/#{id}"
          @remove(id)
          
    
    find: (model) ->
      return JSON.parse(this.localStorage().getItem(this.name+"-"+model.id))
    
    findAll:(model, options)->
      success = options.success
      error = options.error
      
      promises = []
      promise  = @readDir("/")
      model.trigger('fetch', model, null, options)
      results = []
      
      fetchData=(fileName)=>
        console.log "got #{fileName}"
        p = @readFile2(fileName)
        p.then (data)=>
          promises.push 
          console.log "Data: #{data}"
          results.push data
      
      truc=(entries)=>
        console.log "args",arguments
        for fileName in entries
          console.log "filename: #{fileName}"
          promises.push @readFile2(fileName)
        
          
      #promise.then(truc)
      $.when(promise).then(truc).pipe.apply($, promises).done ()=>
        console.log "args",arguments[0]
        console.log("ALL DONE", results)
        model.trigger('reset',results)
      
      ###  
      $.when.apply($, promises).done ()=>
        arguments[0]
        console.log("ALL DONE", results)
        model.trigger('reset',results)
      ###
        
      ###
      
        for fileName in entries
          
        model.trigger('reset')
        #options.success(res)
      ###
      #promise1.then(getStuff).then(myServerScript2Data)
      ###
      callback = (entries)=>
        console.log entries
        console.log "Entries nb"+entries.length
        for fileName in entries
          console.log fileName
          readFileContent= (fileContent)=>
            console.log "fileContent"
            console.log fileContent
            @resultOfFindAll.push(JSON.parse(fileContent))
          @readFile(readFileContent,fileName)
          
      
      ###
      #return @resultOfFindAll
      
    remove:(name)->
      @client.remove name, (error, userInfo)->
        if error
          return showError(error)
        console.log "removed #{name}"
        
    writeFile:(name, content)->
      @client.writeFile name, content, (error, stat) =>
        if error
          return @showError(error)
        console.log ("File saved as revision " + stat.versionTag)
        
    createFolder:(name)->
      @client.mkdir name, (error,stat) =>
        if error
          return @showError(error)  
        console.log "folder create ok"
        
    readDir:(path)->
      d = $.Deferred()
      @client.readdir path, (error, entries)=>
        if error
          return @showError(error)
        d.resolve entries
      return d.promise()
        #callback(entries)
        
    readDir2:(path)->
      return @client.readdir "/"
        
    readFile:(callback, path)->
      @client.readFile path, (error, data)=>
        if error
          return @showError(error)
        callback(data)
        
    readFile2:(path)->
      d = $.Deferred()
      @client.readFile path, (error, data)=>
        if error
          return @showError(error)
        d.resolve data
      return d.promise()
      
  store = new DropBoxStorage
  return store 