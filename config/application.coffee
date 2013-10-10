concat = { banner: "~(function (app) {\n", footer: "\n})(thinner.loader());\n" }

config = require(process.env["LINEMAN_MAIN"]).config
config = config.extend "application",

  server:
    pushState: on

  loadNpmTasks: [
    "grunt-markdown"
    "grunt-bower-task"
    "grunt-contrib-jade"
    "grunt-blanket"
  ]

  prependTasks:
    common: ["bower", "jade"]

  removeTasks:
    common: ["handlebars", "jst"]

  appendTasks:
    common: ["blanket"]

  pages:
    dev:
      context:
        js: "<%= files.app.dev.js %>"
        css: "<%= files.app.dev.css %>"
    dist:
      context:
        js: ["<%= files.app.dist.js %>"]
        css: ["<%= files.app.dist.css %>"]

  bower:
    install:
      options:
        targetDir: "<%= files.bower.dest %>"
        install: true
        copy: false

  clean:
    js:
      src: [
        "dist"
        "htmldocs"
        "generated"
        "vendor/components"
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

  watch:
    coffee:
      files: ["<%= files.coffee.spec %>", "<%= files.coffee.app %>"]
      tasks: ["coffee", "concat:app", "blanket"]

    jade:
      files: "<%= files.template.jade.src %>"
      tasks: ["jade", "concat:views"]

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
      options: concat
      files:
        "<%= files.js.concatenatedApp %>": [
          "<%= files.js.app.files %>"
          "<%= files.coffee.generated %>"
        ]

    spec:
      options: concat
      dest: "<%= files.js.concatenatedSpec %>"
      src: [
          "<%= files.coffee.generatedSpecHelpers %>"
          "<%= files.coffee.specHelpers %>"
          "<%= files.js.specHelpers %>"
          "<%= files.js.app.files %>"
          "<%= files.coffee.generated %>"
          "<%= files.coffee.generatedSpec %>"
          "<%= files.js.spec %>"
        ]

    views:
      dest: "<%= files.js.concatenatedViews %>"
      src: "<%= files.template.generated %>"

    vendor:
      options:
        separator: ';'
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
        "<%= files.js.concatenatedVendor %>"
        "<%= files.js.concatenatedApp %>"
      ]

  cssmin:
    compress:
        src: "<%= files.css.concatenated %>"
        dest: "<%= files.css.minifiedDist %>"


module.exports = config
