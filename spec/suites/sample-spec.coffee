app.run ->

 describe 'Sample', ->

  async = new AsyncSpec @

  app.go('/').then ->

    describe 'Some util fun', ->
      it 'capitalize almost all strings', ->
        { ucfirst, ucwords } = app.helpers

        expect(ucfirst 'x-y').toEqual 'x-y'
        expect(ucfirst 'abc').toEqual 'Abc'
        expect(ucwords 'abc def').toEqual 'Abc Def'
        expect(ucwords 'a basic sample-string __with camelCase').toEqual 'A Basic sample-string __with camelCase'

      it 'can I change the title?', ->
        { title, subtitle } = app.imports

        title 'Foo'
        subtitle 'Bar'

        expect(document.title).toBe 'Foo | Bar'

    describe 'Some workflow', ->

      async.it 'pass the basic selection screen test', (done) ->
        expect($('#wrapper button').text()).toBe 'Continue (no selection)'

        app.go('/user/1').then ->
          expect($('#sample-out li').size()).toBe 3
          expect($('#wrapper input:checked').closest('li').text()).toBe 'Joe Merengues'

          $('#wrapper li:eq(0) input').trigger 'click'
          expect($('#wrapper input:checked').closest('li').text()).toBe 'John Doe'

          app.go('/').then (handler) ->
            expect($('#wrapper button').text()).toBe 'Show selected'
            expect(app.get 'user').toEqual { name: 'John Doe', id: 0 }

            $('#wrapper button').trigger 'click'
            expect(alert()[0]).toBe 'John Doe'
            done()
