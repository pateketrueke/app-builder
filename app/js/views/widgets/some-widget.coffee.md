# Ractive views

We're using [Ractive](https://github.com/Rich-Harris/Ractive) because it rocks a lot.

    thinner (App) ->

Automatically instantiate our _ractive_ view.

      class App.showUser.someWidget
        view:
          el: '#sample-out'
          sanitize: on

        users = []
        current_user = -1

        constructor: (@app) ->
          @view.template = @app.render 'ractive'

The current user data.

        current_user: ->
          user = users[current_user]
          user.id = current_user
          user

Changes the user selection.

        set_user: (id) ->
          current_user = +id
          @view.set
            selected: current_user
            current_user: users[current_user]

Set the users list and updates the view.

        render: (list) ->
          users = list
          @view.set
            users: users
            selected: current_user
            current_user: users[current_user]

Event handling.

        setup: ->
          @view._bound = [] # Ractive v0.3.7 bug
          @view.on
            set_user: (e) =>
              @set_user e.node.value
