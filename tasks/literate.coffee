
module.exports = (grunt) ->
  _ = grunt.util._

  grunt.registerTask "literate", "Generate pseudo-navigation index from Markdown pages", ->

    files = require "#{process.cwd()}/config/files"
    pkg = grunt.file.readJSON "package.json"
    path = files.literate.docDest
    index = "#{path}/index.html"
    style = "#{path}/style.css"


    list = (set, path, current) ->
      return "" unless set

      out = []
      tmp = { basePath: '', baseName: 'index.html', docTitle: pkg.title }

      out.push "<h2>#{linkify path, tmp, current}</h2>"
      out.push "<ul>"

      for dir, item of set
        out.push "  <li><h3>#{dir}</h3>"
        out.push "  <ul>"

        unless item.childs.length
          item.childs.push item.node

        for sub in item.childs
          out.push "    <li>#{linkify path + dir, sub, current}</li>"

        out.push "  </ul>"
        out.push "  </li>"

      out.push "</ul>"
      out.join "\n"

    linkify = (dir, node, current) ->
      href = "#{node.basePath}/#{node.baseName}"
      klass = if href is current then ' class="here"' else ''

      """
      <a href="#{dir.replace /\/+$/g, ''}/#{node.baseName}"#{klass}>#{node.docTitle}</a>
      """

    titleize = (str) ->
      str.replace(/\.[\w.]+$/g, "").replace(/^\d+_/, "").replace /_/g, " "


    tree = []
    map = {}
    nth = 0

    _(grunt.file.expand "#{path}/**/*.html").each (src) ->
      basePath = src.split("/")
      baseName = basePath.pop()
      basePath = basePath.join("/").substr path.length
      docTitle = titleize src.split("/").pop().replace path, ""
      srcFile = "#{process.cwd()}/#{src}"

      unless index is src
        unless leaf = tree[basePath]
          leaf = tree[basePath] =
            node: { docTitle, basePath, baseName }
            childs: []

        leaf.childs.push { docTitle, basePath, baseName }

        map[srcFile] = { title: docTitle, path: "#{basePath}/#{baseName}" }


    layout = grunt.file.read files.literate.docIndex
    welcome = grunt.file.read files.literate.docMain

    grunt.file.write index, _.template layout,
      title: pkg.title
      style: "./style.css"
      tree: list(tree, "./", "index.html")
      body: _.template(welcome, { pkg })

    grunt.log.writeln 'File "' + index + '" created.'

    grunt.file.copy files.literate.docStyles, style
    grunt.log.writeln 'File "' + style + '" copied.'


    for src, doc of map
      nth += 1
      dots = new Array doc.path.split("/").length
      dots = "./#{dots.join '../'}"

      grunt.file.write src, _.template layout,
        title: "#{pkg.title} | #{doc.title}"
        style: "#{dots}style.css"
        tree: list(tree, dots, doc.path)
        body: grunt.file.read src

    grunt.log.writeln "#{nth} file(s) was literated."
