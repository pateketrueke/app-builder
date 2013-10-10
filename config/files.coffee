config = require(process.env["LINEMAN_MAIN"]).config
config = config.extend "files",

  app:
    dev: {}
    dist: {}

  bower:
    dest: "vendor/components"

  blanket:
    dest: "generated/coverage"
    src: "generated/js/app"

  template:
    jade:
      src: ["app/templates/**/*.jade", "app/templates/**/*.jd"]
      dest: "generated/template/jade.js"

  coffee:
    app: ["app/js/**/*.litcoffee", "app/js/**/*.coffee.md", "app/js/**/*.coffee"]
    spec: ["spec/**/*.litcoffee", "spec/**/*.coffee.md", "spec/**/*.coffee"]
    docs:
      idx: "app/docs/index.us"
      tpl: "app/docs/layout.us"
      css: "app/docs/styles.css"
      main: "app/docs/welcome.us"
      src: [
        "app/**/*.md"
        "app/**/*.litcoffee"
        "spec/**/*.litcoffee"
        "spec/**/*.coffee.md"
      ]
      dest: "htmldocs/"

  css:
    files: ["vendor/css/**/*.css"]
    minifiedDist: "dist/css/<%= pkg.name %>.css"

  js:
    files: ["vendor/js/**/*.js"]

    app:
      files: ["app/js/**/*.js"]

    ci:
      files: [
        "vendor/components/jasmine.async/lib/jasmine.async.js"
        "vendor/components/blanket/dist/jasmine/blanket_jasmine.js"
      ]

    minifiedDist: "dist/js/<%= pkg.name %>.js"
    concatenatedCI: "generated/js/ci.js"
    concatenatedApp: "generated/js/app/main.js"
    concatenatedSpec: "generated/js/spec/main.js"
    concatenatedViews: "generated/js/views.js"
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
