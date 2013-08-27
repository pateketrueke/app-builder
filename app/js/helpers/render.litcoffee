
    class App.Render

      default_title = document.title

      initialize_module: ->

        @subtitle = @helpers.title = (subtitle, sep=' | ') =>
          out = []
          out.push default_title if default_title
          out.push subtitle if subtitle
          document.title = out.join sep

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
          default_title = document.title = replace.join sep
