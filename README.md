# Sample.app
[![Build Status](https://travis-ci.org/pateketrueke/app-builder.png)](https://travis-ci.org/pateketrueke/app-builder)

This template uses [Lineman](https://github.com/testdouble/lineman) because YOLO.

Where I start?
--------------

Do you remember MVC?

Well, this is [MOVE](http://cirw.in/blog/time-to-move-on), the better.

```coffeescript
app = new App null, '/'
app.load Module
app.run()
```

Modules
-------

Almost everything will occurs within modules looks as below:

```coffeescript
class Module

  render_template = (page) ->
    @el.innerHTML += "Page title: #{page.title}"

  initialize_module: (mapper) ->
    @global_helper = ->

    mapper.draw (match) ->
      match('/').to 'hello_world'

      hello_world:
        model: (params) ->
          new Page params.id
        setup: (page) ->
          @send render_template, page
        events:
          testEvent: ->
```

Features
--------

- Powered by [router.js](https://github.com/tildeio/router.js), our framework for [route recognizing](https://github.com/tildeio/route-recognizer) an [RSVP](https://github.com/tildeio/rsvp.js).

- Provides support for code coverage with [Blanket](http://alex-seville.github.io/blanket/) and adds [Jade](http://jade-lang.com/) and [Bower](https://github.com/bower/bower) as core dependencies.

- Also tweaks `application.coffee` and `files.coffee` settings for its best approach.
