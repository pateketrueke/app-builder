# Errors

Here we'll define some classes for error handling.

    thinner (App) ->

## ErrorBase Class

The basis for all errors.

      class ErrorBase

        # holds the origin
        rorigin = new RegExp(location.origin, 'g')

Removes the current `location.origin` from the error stack string.

        reduce: (str) ->
          lines = str.replace(/[ \n]+$/, '').split /\n+/
          return "<p>#{lines.pop().replace(rorigin, '')}</p>" if lines.length is 1
          "<ul><li>#{lines.join '</li><li>'}</li></ul>".replace rorigin, ''

## errorHandler Class

This class is used when a exception occurs, isn't perfect but is very useful.

      class App.errorHandler extends ErrorBase
        exception: (e) ->
          app.router.reset()

Shows sort of formatted debug, just a plain message but it could be better.

          $('#wrapper').html """
            <h1>errorHandler</h1>
            <pre>#{@reduce e.fileName}##{e.lineNumber} #{e.message}

            #{e.stack and @reduce(e.stack) or 'Stack: N/A'}</pre>
            """

## notFound Class

This class is used for unhandled or unknown routes.

      class App.notFound extends ErrorBase
        exception: (e) ->
          app.router.reset()

Certainly you can do it better.

          $('#wrapper').html "<h1>notFound</h1><p>#{e.message}</p>"
