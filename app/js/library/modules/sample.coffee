class App.Sample

  render_welcome = (params) ->
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

        @title 'Welcome!', ' - '
        @send render_welcome, list: data
