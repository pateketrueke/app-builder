# Base

The application core and routing.

    thinner (App) ->
      class App.myApp

> Note that every class must be defined inside a `mohawk()` calling to keep your classes isolated.

With the `actions` property we can manage all the DOM events within the current handler easily.

        actions:
          'redirect.click': 'page_link'

> Note that our link has the `js-action` class and a `data-action` value
> that match our `redirect` action above.

> ```
> # jade
> # a.js-action(data-action='redirect', href=url_for('foo-route')) bar
>
> # html
> # <a class="js-action" data-action="redirect" href="/foo">bar</a>
> ```

        page_link: (e, el) ->
          e.preventDefault()
          app.go el.attr 'href'
          false


## Routing

Each namespaced class under the `App` scope that begins with a uppercased letter will be treated as a module.

In this case the `App.Sample` module will define the application routing.

    app.router.map (match) ->
      match('/').to 'my_app', (match) ->

By doing this our `App.myApp` handler context will evaluated before any other route.

        match('/').to 'show_home'
        match('/user').to 'show_error'
        match('/user/:id').to 'show_user'

This results in an useful application bootstrap mechanism.
