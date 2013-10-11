config = require(process.env["LINEMAN_MAIN"]).config
config = config.extend "application",

  server:
    pushState: on

  loadNpmTasks: [
    "grunt-markdown"
    "grunt-bower-task"
    "grunt-contrib-jade"
    "grunt-closure-compiler"
    "grunt-blanket"
  ]

  prependTasks:
    common: ["bower"]

  removeTasks:
    common: ["handlebars", "coffee", "concat", "jshint", "jst"]
    dist: ["uglify"]

  appendTasks:
    common: ["jade", "coffee:*", "blanket", "concat:*"]
    dist: ["closure-compiler"]

  pages:
    dev: { context: "<%= files.app.dev %>" }
    dist: { context: "<%= files.app.dist %>" }

  bower:
    install:
      options:
        targetDir: "<%= files.bower.dest %>"
        install: true
        copy: false

  clean:
    js:
      src: ["dist", "htmldocs", "generated", "vendor/components"]

  coffee:
    options:
      bare: on
    compile:
      expand: on
      ext: ".js"
      cwd: "<%= files.app.jsPath %>"
      src: "<%= files.blanket.files %>"
      dest: "<%= files.blanket.src %>"
    spec:
      src: [
        "<%= files.coffee.generatedSpecHelpers %>"
        "<%= files.coffee.specHelpers %>"
        "<%= files.coffee.spec %>"
      ]
      dest: "<%= files.spec.app.dest %>"

  markdown:
    docs:
      files: [
        { expand: on, src: "<%= files.literate.docSrc %>", dest: "<%= files.literate.docDest %>", ext: ".html" }
      ]
      options:
        template: "<%= files.literate.docTemplate %>"
        markdownOptions:
          gfm: on
          highlight: (code, lang) ->
            hljs = require "highlight.js"
            hljs.highlight(lang or "coffeescript", code).value

  blanket:
    options: {}
    compile:
      src: "<%= files.blanket.src %>"
      dest: "<%= files.blanket.dest %>"

  concat:
    js:
      options: { banner: "" }
      src: "<%= files.spec.ci.src %>"
      dest: "<%= files.spec.ci.dest %>"

    app:
      options:
        banner: "~(function (app) {\n"
        footer: "\n})(thinner.loader());\n"
      files:
        "<%= files.js.concatenated %>": "<%= files.blanket.src %>/**/*.js"
        "<%= files.js.concatenatedSpec %>": [
          "<%= files.spec.app.src %>"
          "<%= files.spec.app.dest %>"
        ]

    spec:
      src: "<%= files.spec.helpers.src %>"
      dest: "<%= files.spec.helpers.dest %>"

    vendor:
      options:
        process: (src, filepath) ->
          src.replace /["']use strict['"]\s*;?/g, ''
      src: "<%= files.js.files %>"
      dest: "<%= files.js.concatenatedVendor %>"

    css:
      src: [
        "<%= files.less.generatedVendor %>"
        "<%= files.less.generatedApp %>"
        "<%= files.css.files %>"
        "<%= files.css.app %>"
      ]
      dest: "<%= files.css.concatenated %>"

  jade:
    compile:
      options:
        client: on
        compileDebug: off
      src: "<%= files.app.jsViews.src %>"
      dest: "<%= files.app.jsViews.dest %>"

  cssmin:
    compress:
      src: "<%= files.css.concatenated %>"
      dest: "<%= files.css.minified %>"

  "closure-compiler":
    app:
      closurePath: '/usr/share/closure-compiler'
      jsOutputFile: "<%= files.js.minified %>"
      js: [
        "<%= files.app.jsViews.dest %>"
        "<%= files.js.concatenatedVendor %>"
        "<%= files.js.concatenated %>"
      ]
      maxBuffer: 9001
      noreport: on
      options:
        compilation_level: 'SIMPLE_OPTIMIZATIONS'

  watch:
    coffeeSpecs:
      tasks: ["coffee:spec", "concat:spec", "concat:app"]

    coffee:
      tasks: ["coffee:compile", "blanket", "concat:spec", "concat:app"]

    jade:
      files: "<%= files.app.jsViews.src %>"
      tasks: ["jade", "concat:views"]

    css:
      files: ["<%= files.css.vendor %>", "<%= files.css.files %>", "<%= files.css.app %>"]
      tasks: ["concat:css"]

    js:
      files: ["<%= files.js.files %>"]
      tasks: ["concat:vendor"]


module.exports = config
