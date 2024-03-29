// Generated by CoffeeScript 1.3.3
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(function(require) {
  var MainContentLayout, marionette, template;
  marionette = require('marionette');
  template = require("text!templates/mainContent.tmpl");
  MainContentLayout = (function(_super) {

    __extends(MainContentLayout, _super);

    function MainContentLayout() {
      this.onRender = __bind(this.onRender, this);
      return MainContentLayout.__super__.constructor.apply(this, arguments);
    }

    MainContentLayout.prototype.template = template;

    MainContentLayout.prototype.regions = {
      edit: "#edit",
      gl: "#gl"
    };

    MainContentLayout.prototype.onRender = function() {
      var container, paddingWrapper;
      paddingWrapper = this.$el.find("#paddingWrapper");
      return container = this.$el.find("#container");
    };

    return MainContentLayout;

  })(marionette.Layout);
  return MainContentLayout;
});
