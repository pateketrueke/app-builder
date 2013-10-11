config = require(process.env["LINEMAN_MAIN"]).config
config = config.extend "files",

  app:
    dev: {}
    dist: {}

    jsPath: "app/js"

    jsViews:
      src: "app/templates/**/*.jade"
      dest: "generated/js/views.js"

  spec:
    ci:
      src: [
        "vendor/components/jasmine.async/lib/jasmine.async.js"
        "vendor/components/blanket/dist/jasmine/blanket_jasmine.js"
      ]
      dest: "generated/js/spec-ci.js"

    app:
      src: "generated/blanket/**/*.js"
      dest: "generated/js/spec-app.js"

    helpers:
      src: "spec/helpers/**/*.js"
      dest: "generated/js/spec-helpers.js"

  coffee:
    app: "app/js/**/*.{coffee,coffee.md,litcoffee}"
    spec: "spec/**/*.{coffee,coffee.md,litcoffee}"

  bower:
    dest: "vendor/components"

  blanket:
    src: "generated/coffee"
    dest: "generated/blanket"
    files: "**/*.{coffee,coffee.md,litcoffee}"

  literate:
    docIndex: "app/docs/index.us"
    docTemplate: "app/docs/layout.us"
    docStyles: "app/docs/styles.css"
    docMain: "app/docs/welcome.us"
    docDest: "htmldocs"
    docSrc: [
      "app/js/**/*.{md,litcoffee}"
      "spec/**/*.{md,litcoffee}"
    ]

  css:
    files: ["vendor/css/**/*.css"]
    minified: "dist/css/<%= pkg.name %>.css"
    concatenated: "generated/css/app.css"

  js:
    files: ["vendor/js/**/*.js"]
    minified: "dist/js/<%= pkg.name %>.js"
    concatenatedSpec: "generated/js/spec.js"
    concatenatedVendor: "generated/js/vendor.js"


# vendors
grunt = require "grunt"
vendor = grunt.file.readYAML "#{__dirname}/../app/vendor.yaml"

for kind in ['js', 'css']
  if vendor[kind] and config[kind]
    config[kind].files.unshift("vendor/components/#{file}") for file in vendor[kind].reverse()

# settings
options = grunt.file.readYAML "#{__dirname}/../app/config.yaml"

config.app.dist = options.dist or {}
config.app.dev = options.dev or config.app.dist or {}

module.exports = config
