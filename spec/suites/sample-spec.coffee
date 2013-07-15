describe 'Now lets fun!', ->
  async = new AsyncSpec @

  async.it 'should works?', (done) ->
    sample = """
             <ul id="sample"><li>John doe</li><li>Joe Merengues</li><li>Scrooge McDuck</li></ul>
             """

    delay done, ->
      expect(String(app.context.el.innerHTML)).toEqual sample
