describe 'Now lets fun!', ->
  async = new AsyncSpec @

  async.it 'should works?', (done) ->
    sample = """
             <ul id="sample"><li><span>John doe</span></li><li><span>Joe Merengues</span></li><li><span>Scrooge McDuck</span></li></ul>
             """

    delay done, ->
      expect(String(app.context.el.innerHTML)).toEqual sample
