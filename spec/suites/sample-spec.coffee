describe 'Sample', ->
  async = new AsyncSpec @

  async.it 'should works?', (done) ->
    delay done, ->
      expect(String(app.context.el.innerHTML)).toEqual '<div id="sample-out"></div>'
