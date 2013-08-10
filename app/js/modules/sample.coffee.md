
    class App.Sample

      constructor: (app) ->
        { @send } = app.context

      render_welcome = (params) ->
        @title 'Welcome!', ' - '
        @el.innerHTML += @partial 'sample'

        widget = new App.ractiveWidget @
        widget = widget.render params

      initialize_module: (mapper) ->
        mapper.draw (match) ->
          match('/').to 'hello_world'

          hello_world: =>
            data = [
              { name: 'John doe' }
              { name: 'Joe Merengues' }
              { name: 'Scrooge McDuck' }
            ]

            @send render_welcome, list: data
