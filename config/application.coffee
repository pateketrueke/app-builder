config = require(process.env["LINEMAN_MAIN"]).config
common =

  server:
    pushState: on

  loadNpmTasks: [
    "grunt-markdown"
    "grunt-bower-task"
    "grunt-contrib-copy"
    "grunt-contrib-jade"
    "grunt-contrib-compress"
    "grunt-closurecompiler"
    "grunt-blanket"
  ]

  prependTasks:
    common: ["bower"]

  removeTasks:
    common: ["handlebars", "coffee", "concat", "jshint", "jst"]
    dist: ["uglify"]

  appendTasks:
    common: ["jade", "coffee:*", "blanket", "concat:*", "copy:public"]
    dist: ["closurecompiler"]

  locals: {}

  pages:
    dev: { context: "<%= files.app.dev %>" }
    dist: { context: "<%= files.app.dist %>" }

  copy:
    public:
      files: [
        { expand: on, flatten: off, cwd: "<%= files.app.public.cwd %>", src: "<%= files.app.public.src %>", dest: "<%= files.app.public.dest %>", filter: "isFile" }
      ]

  bower:
    install:
      options:
        targetDir: "<%= files.bower.dest %>"
        install: true
        copy: false

  clean:
    js:
      src: ["<%= files.app.cleanDirs %>"]

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
    options:
      branchTracking: on
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
        banner: ";(function (app) {\nvar ENV = <%= JSON.stringify(locals || {}) %>;\n"
        footer: "\n}).call(this, thinner.loader());\n"
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

  closurecompiler:
    app:
      files:
        "<%= files.js.minified %>": [
          "<%= files.app.jsViews.dest %>"
          "<%= files.js.concatenatedVendor %>"
          "<%= files.js.concatenated %>"
        ]
      options:
        language_in: 'ECMASCRIPT5'
        warning_level: 'QUIET'
        summary_detail_level: 0
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


# overrides
if process.argv.indexOf('--') > 0
  grunt = require "grunt"
  _ = grunt.util._

  merge = (dest, src) ->
    for key, val of src
      if _.isArray(dest[key])
        dest[key] = dest[key].concat val
      else if _.isObject(dest[key])
        merge(dest[key], val)
      else
        dest[key] = val

  targets = process.argv.slice(process.argv.indexOf('--') + 1)

  for target in targets
    try
      targetConfig = require "#{__dirname}/environment/#{target}.coffee"
    catch e
      targetConfig = grunt.file.readYAML "#{__dirname}/environment/#{target}.yaml"

    merge common, targetConfig

module.exports = config.extend "application", common
