
    class App.Sample

      widget = {}

      hello_world: ->
        # do nothing

      show_user: (params) ->
        widget.set_user params.id
        @subtitle widget.current_user().name

      draw_view = ->
        @title 'Welcome!', ' - '

        $('body').append @partial 'sample'

        widget = new App.ractiveWidget @
        widget.render list: [
          { name: 'John doe' }
          { name: 'Joe Merengues' }
          { name: 'Scrooge McDuck' }
        ]

        widget.view.on 'set_user', (e) =>
          @go 'show_user', id: e.node.value

      initialize_module: (mapper) ->
        mapper.draw (match) ->
          match('/').to 'hello_world'
          match('/user/:id').to 'show_user'

          { @hello_world, @show_user }

        @send draw_view
