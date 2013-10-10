# Example

Main application workflow with [Thinner](https://github.com/pateketrueke/thinner).

    thinner (App) ->

## showError Class

Just a dummy for testing.

      class App.showError
        enter: ->
          throw new Error 'message'

## showHome Class

A button will `alert()` some message depending on user selection made through the link.

      class App.showHome

User interaction bindings.

        actions:
          'before_choose.click': 'show_name'
          'after_choose.click': 'show_name'

When the user clicks the button.

        show_name: ->
          if user = app.get('user')
            alert user.name
          else
            alert 'Pick someone!'

Before the handler has fully loaded.

        enter: ->
          title 'Hello World'
          layout 'welcome', user: app.get 'user'

## showUser Class

Through this view the user should choose a sole user from the list.

      class App.showUser

Before setup any view we must load their layout.

        enter: ->
          title 'Welcome!'
          layout 'sample'

Renderize the user list.

          @someWidget().render [
            { name: 'John Doe' }
            { name: 'Joe Merengues' }
            { name: 'Scrooge McDuck' }
          ]

Updates the current user value.

          @someWidget().view.on 'set_user', (e) =>
            app.set 'user', @someWidget().current_user()
            app.go 'show_user', id: e.node.value

> When the handler exit destroys all registered _ractive_ instances.

Finally, selects an user based on the current handler params when fully loads.

        setup: (params) ->
          @someWidget().set_user params.id
          subtitle @someWidget().current_user().name, ' - '
