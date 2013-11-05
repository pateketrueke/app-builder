# Global scope and utilities

    # backup for later
    default_title = document.title


    isWord = (str) ->
      !/\w+[_.+-]\w+|[a-z][A-Z]/.test(str)

    ucChar = (str, n=1) ->
      str.substr(0, n).toUpperCase() + str.substr n


    partial = (path, vars={}) ->
      app.render path, vars

    layout = (path, vars={}) ->
      $('#wrapper').html partial(path, vars)

    title = (name, sep=' | ') ->
      replace = []
      replace.push name if name
      default_title = document.title = replace.join sep

    subtitle = (sub_title, sep=' | ') ->
      out = []
      out.push default_title if default_title
      out.push sub_title if sub_title
      document.title = out.join sep


    @helpers.ucfirst = (str) ->
      if isWord(str) then ucChar(str) else str

    @helpers.ucwords = (str) ->
      str.replace /(^|\s)(\S+)/g, (zero, one, two) ->
        one + if isWord(two) then ucChar(two) else two

    @helpers.url_for = ->
      app.url arguments...
