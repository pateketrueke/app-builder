# Exports an object that defines
#  all of the configuration needed by the projects'
#  depended-on grunt tasks.
#
# You can find the parent object in: node_modules/lineman/config/application.coffee
#
config = require(process.env["LINEMAN_MAIN"]).config
config = config.extend "application",

  #Override application configuration here. Common examples follow in the comments.

  # API Proxying
  #
  # During development, you'll likely want to make XHR (AJAX) requests to an API on the same
  # port as your lineman development server. By enabling the API proxy and setting the port, all
  # requests for paths that don't match a static asset in ./generated will be forwarded to
  # whatever service might be running on the specified port.
  #
  server:
    pushState: on
    # apiProxy:
    #   enabled: on
    #   host: 'localhost'
    #   port: 3000

  loadNpmTasks: [
    "grunt-markdown"
    "grunt-bower-task"
    "grunt-contrib-jade"
    "grunt-contrib-compress"
    "grunt-blanket"
  ]

  prependTasks:
    common: ["jade"]

  removeTasks:
    common: ["handlebars", "jst"]

  pages:
    dev:
      context:
        js: "<%= files.app.dev.js %>"
        css: "<%= files.app.dev.css %>"
    dist:
      context:
        js: ["<%= files.app.dist.js %>"]
        css: ["<%= files.app.dist.css %>"]

  clean:
    js:
      src: [
        "<%= files.bower.dest %>"
        "<%= files.blanket.dest %>"
        "<%= files.coffee.docs.dest %>"
        "<%= files.coffee.generated %>"
        "<%= files.coffee.generatedSpec %>"
        "<%= files.template.concatenatedViews %>"
        "<%= files.js.concatenatedCI %>"
        "<%= files.js.concatenatedApp %>"
        "<%= files.js.concatenatedSpec %>"
        "<%= files.js.concatenatedVendor %>"
      ]

  compress:
    main:
      options:
        archive: "<%= pkg.name %>.zip"

      files: [
        { src: ["dist/**"] }
      ]

  markdown:
    docs:
      files: [
        { expand: on, src: "<%= files.coffee.docs.src %>", dest: "<%= files.coffee.docs.dest %>", ext: ".html" }
      ]
      options:
        template: "<%= files.coffee.docs.tpl %>"
        markdownOptions:
          gfm: on
          highlight: (code, lang) ->
            hljs = require "highlight.js"
            hljs.highlight(lang or "coffeescript", code).value

  coffee:
    options:
      bare: on

  jade:
    compile:
      options:
        client: on
        compileDebug: off

      files:
        "<%= files.template.jade.dest %>": "<%= files.template.jade.src %>"

  bower:
    options:
      copy: off
      targetDir: "<%= files.bower.dest %>"
    update: {}

  watch:
    literate:
      files: "<%= files.coffee.docs.src %>"
      tasks: ["markdown", "literate"]

    coffee:
      tasks: ["coffee", "concat:app"]

    bower:
      files: "<%= files.bower.file %>"
      tasks: ["bower"]

    jade:
      files: "<%= files.template.jade.src %>"
      tasks: ["jade", "concat:app"]

    lint:
      files: ["<%= files.js.app.files %>"]

    css:
      files: ["<%= files.css.vendor %>", "<%= files.css.files %>", "<%= files.css.app %>"]
      tasks: ["concat:css"]

    js:
      files: ["<%= files.js.files %>", "<%= files.js.app.files %>"]
      tasks: ["concat:vendor", "concat:app"]

    ci:
      files: ["<%= files.js.ci.files %>"]
      tasks: ["concat:js"]

  jshint:
    files: ["<%= files.js.app.files %>"]

  concat:
    js:
      src: "<%= files.js.ci.files %>"
      dest: "<%= files.js.concatenatedCI %>"

    app:
      options:
        process: (src, filepath) ->
          "!(function (/* #{filepath} */) {\n#{src}\n}).apply(window || this)"
      files:
        "<%= files.js.concatenatedApp %>": ["<%= files.js.app.files %>", "<%= files.coffee.generated %>"]
        "<%= files.template.concatenatedViews %>": ["<%= files.template.generated %>"]

    vendor:
      options:
        process: (src, filepath) ->
          src.replace /["']use strict['"]\s*;?/g, ''
      files:
        "<%= files.js.concatenatedVendor %>": ["<%= files.js.files %>"]

    css:
      src: [
        "<%= files.less.generatedVendor %>"
        "<%= files.less.generatedApp %>"
        "<%= files.css.files %>"
        "<%= files.css.app %>"
      ]
      dest: "<%= files.css.concatenated %>"

  blanket:
    compile:
      options: {}
      files:
        "<%= files.blanket.dest %>": "<%= files.blanket.src %>"

  uglify:
    js:
      dest: "<%= files.js.minifiedDist %>"
      src: [
        "<%= files.template.concatenatedViews %>"
        "<%= files.js.concatenatedVendor %>"
        "<%= files.js.concatenatedApp %>"
      ]

  cssmin:
    compress:
        src: "<%= files.css.concatenated %>"
        dest: "<%= files.css.minifiedDist %>"


module.exports = config
