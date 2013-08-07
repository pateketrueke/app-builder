
    class App.Sample

      constructor: (app) ->
        { @el, @title, @partial } = app.context

      render_welcome: (params) ->
        @title 'Welcome!', ' - '
        @el.innerHTML += @partial 'sample', params

      initialize_module: (mapper) ->
        mapper.draw (match) ->
          match('/').to 'hello_world'

          hello_world: =>
            data = [
              { name: 'John doe' }
              { name: 'Joe Merengues' }
              { name: 'Scrooge McDuck' }
            ]

            @render_welcome list: data
