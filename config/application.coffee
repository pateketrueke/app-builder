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
    "grunt-bower-task"
    "grunt-contrib-jade"
    "grunt-blanket"
  ]

  prependTasks:
    common: ["bower:install", "jade"]

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
        "<%= files.coffee.generated %>"
        "<%= files.coffee.generatedSpec %>"
        "<%= files.template.concatenatedViews %>"
        "<%= files.js.concatenatedCI %>"
        "<%= files.js.concatenatedApp %>"
        "<%= files.js.concatenatedSpec %>"
        "<%= files.js.concatenatedVendor %>"
      ]

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
    install: {}

  watch:
    coffee:
      tasks: ["coffee", "concat:app"]

    jade:
      files: "<%= files.template.jade.src %>"
      tasks: ["jade", "concat:js"]

    lint:
      files: ["<%= files.js.app.files %>"]

    js:
      files: ["<%= files.js.files %>", "<%= files.js.app.files %>"]
      tasks: ["concat:vendor", "concat:app"]

    ci:
      files: ["<%= files.js.ci.files %>"]
      tasks: ["concat:ci"]

  jshint:
    files: ["<%= files.js.app.files %>"]

  concat:
    vendor:
      src: ["<%= files.js.files %>"]
      dest: "<%= files.js.concatenatedVendor %>"

    app:
      src: ["<%= files.js.app.files %>", "<%= files.coffee.generated %>"]
      dest: "<%= files.js.concatenatedApp %>"

    js:
      src: "<%= files.template.generated %>"
      dest: "<%= files.template.concatenatedViews %>"

    ci:
      src: "<%= files.js.ci.files %>"
      dest: "<%= files.js.concatenatedCI %>"

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
