// Generated by CoffeeScript 1.3.3
(function() {

  require.config({
    deps: ["main"],
    paths: {
      libs: "../assets/js/libs",
      plugins: "../assets/js/plugins",
      vendor: "../assets/vendor",
      jquery: "../assets/js/libs/jquery-1.8.1.min",
      underscore: "../assets/js/libs/underscore-min",
      backbone: "../assets/js/libs/backbone",
      bootstrap: "../assets/js/libs/bootstrap.min",
      dropbox: "../assets/js/libs/dropbox",
      bootbox: "../assets/js/plugins/bootbox.min",
      marionette: "../assets/js/plugins/backbone.marionette.min",
      eventbinder: "../assets/js/plugins/backbone.eventbinder.min",
      wreqr: "../assets/js/plugins/backbone.wreqr.min",
      localstorage: "../assets/js/plugins/backbone.localstorage"
    },
    shim: {
      underscore: {
        deps: [],
        exports: '_'
      },
      bootstrap: {
        deps: ["jquery"],
        exports: "bootstrap"
      },
      bootbox: {
        dep: ["bootstrap"]
      },
      'backbone': {
        deps: ["underscore"],
        exports: "Backbone"
      },
      marionette: {
        deps: ["jquery", "backbone", "eventbinder", "wreqr"],
        exports: "marionette"
      },
      localstorage: {
        deps: ["backbone", "underscore"],
        exports: "localstorage"
      },
      utils: {
        deps: ["jquery"],
        exports: "normalizeEvent"
      },
      dropbox: {
        deps: ["jquery"],
        exports: "Dropbox"
      }
    }
  });

}).call(this);
