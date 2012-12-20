// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(function(require) {
    var $, CoffeeScadApp, DummySubApp, MainLayout, contentTemplate, marionette, vent, _;
    $ = require('jquery');
    _ = require('underscore');
    marionette = require('marionette');
    vent = require('./coffeescad.vent');
    contentTemplate = require("text!modules/content.tmpl");
    DummySubApp = require('modules/dummyModule/dummyApp');
    MainLayout = (function(_super) {

      __extends(MainLayout, _super);

      MainLayout.prototype.template = contentTemplate;

      MainLayout.prototype.regions = {
        menu: "#menu",
        content: "#content"
      };

      MainLayout.prototype.events = {
        "click .newDummy": function() {
          return vent.trigger("dummy:new");
        },
        "click .deleteDummy": function() {
          return vent.trigger("dummy:delete");
        },
        "click .listDummies": function() {
          return vent.trigger("dummy:list");
        },
        "click .saveDummies": function() {
          return vent.trigger("dummies:save");
        },
        "click .fetchDummies": function() {
          return vent.trigger("dummies:fetch");
        },
        "click .dropBoxLogin": function() {
          return vent.trigger("dropbox:login");
        },
        "click .dropBoxLogout": function() {
          return vent.trigger("dropbox:logout");
        },
        "click .folderCreate": function() {
          return vent.trigger("folder:create");
        },
        "click .findDummy": function() {
          return vent.trigger("dummy:find", $("#dummyFindInput").val());
        }
      };

      function MainLayout(options) {
        MainLayout.__super__.constructor.call(this, options);
      }

      return MainLayout;

    })(Backbone.Marionette.Layout);
    CoffeeScadApp = (function(_super) {

      __extends(CoffeeScadApp, _super);

      CoffeeScadApp.prototype.root = "/WebAppExperiments/storage/backbone/index.html/";

      CoffeeScadApp.prototype.title = "Coffeescad";

      CoffeeScadApp.prototype.regions = {
        headerRegion: "#header",
        mainRegion: "#content"
      };

      function CoffeeScadApp(options) {
        this.onInitializeAfter = __bind(this.onInitializeAfter, this);

        this.onStart = __bind(this.onStart, this);

        this.initStorage = __bind(this.initStorage, this);

        this.initLayout = __bind(this.initLayout, this);
        CoffeeScadApp.__super__.constructor.call(this, options);
        this.vent = vent;
        this.addRegions(this.regions);
        this.on("initialize:before", this.onInitializeBefore);
        this.on("initialize:after", this.onInitializeAfter);
        this.on("start", this.onStart);
        this.vent.on("app:started", this.onAppStarted);
        this.vent.on("dropbox:login", this.onDropboxLoginRequested);
        this.vent.on("folder:create", this.createFolder);
        this.initLayout();
        this.initStorage();
      }

      CoffeeScadApp.prototype.initLayout = function() {
        this.layout = new MainLayout();
        return this.headerRegion.show(this.layout);
      };

      CoffeeScadApp.prototype.initStorage = function() {
        this.dropBoxStorage = require('./dummyModule/storage/dropboxStorage');
        return this.dropBoxStorage.authentificate();
      };

      CoffeeScadApp.prototype.initSettings = function() {
        this.settings = new Settings();
        return this.bindTo(this.settings.get("General"), "change", this.settingsChanged);
      };

      CoffeeScadApp.prototype.onStart = function() {
        var dummySubApp;
        console.log("app started");
        dummySubApp = new DummySubApp({
          regions: {
            mainRegion: "#content"
          }
        });
        dummySubApp.start();
        return vent.trigger("dummy:list");
      };

      CoffeeScadApp.prototype.onAppStarted = function(appName) {
        return console.log("I see app: " + appName + " has started");
      };

      CoffeeScadApp.prototype.onInitializeBefore = function() {
        return console.log("before init");
      };

      CoffeeScadApp.prototype.onInitializeAfter = function() {
        "For exampel here close and 'please wait while app loads' display";
        return console.log("after init");
      };

      CoffeeScadApp.prototype.onDropboxLoginRequested = function() {
        return this.dropBoxStorage.authentificate();
      };

      CoffeeScadApp.prototype.createFolder = function() {
        console.log("trying to create folder");
        return this.dropBoxStorage.createFolder("blabla");
      };

      return CoffeeScadApp;

    })(Backbone.Marionette.Application);
    return CoffeeScadApp;
  });

}).call(this);
