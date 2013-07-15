# Exports an object that defines
#  all of the paths & globs that the project
#  is concerned with.
#
# The "configure" task will require this file and
#  then re-initialize the grunt config such that
#  directives like <config:files.js.app> will work
#  regardless of the point you're at in the build
#  lifecycle.
#
# You can find the parent object in: node_modules/lineman/config/files.coffee
#
config = require(process.env["LINEMAN_MAIN"]).config
config = config.extend "files",

  #Override file patterns here

  app:
    dev:
      js: ["/js/views.js", "/js/vendor.js", "/js/app/main.js"]
      css: "/css/app.css"
    dist:
      js: "/js/<%= pkg.name %>.js"
      css: "/css/<%= pkg.name %>.css"


  bower:
    dest: "vendor/components"

  blanket:
    dest: "coverage/"
    src: "generated/js/app/"

  template:
    jade:
      src: ["app/templates/**/*.jade", "app/templates/**/*.jd"]
      dest: "generated/template/jade.js"
    concatenatedViews: "generated/js/views.js"

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
    concatenatedVendor: "generated/js/vendor.js"


# vendors
grunt = require "grunt"
vendor = grunt.file.readYAML "#{__dirname}/../app/vendor.yaml"

for kind in ['js', 'css']
  if vendor[kind] and config[kind]
    config[kind].files.unshift(file) for file in vendor[kind]


module.exports = config
