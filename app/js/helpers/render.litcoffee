
    class App.Render

      cached = {}
      ticker = null
      title = document.title

      initialize_module: ->

        @helpers.title = (subtitle, sep=' | ') =>
          out = []
          out.push title if title
          out.push subtitle if subtitle
          @title out.join sep

        @partial = (path, vars={}) =>
          path = path ? 'undefined'
          template = "app/templates/#{path.replace /[^\w_-]/g, '/'}"

          unless view = JST[template]
            throw new Error "Missing '#{template}' template!"

          vars[prop] = value for prop, value of @helpers
          vars.partial = arguments.callee
          view.apply @globals, [vars]

        @title = (name, sep=' | ') =>
          replace = []
          replace.push name if name
          document.title = replace.join sep
          title = document.title unless title

        @html = (id) =>
          return cached[id] if cached[id]
          cached[id] = document.getElementById id

        @to = (hash) =>
          clearTimeout ticker if ticker
          ticker = setTimeout ->
            document.location.hash = hash.replace '#', ''
          , 13
