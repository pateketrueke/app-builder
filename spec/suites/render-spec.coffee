app = new App '/'
app.load(App.modules()).run()

$('#sample-out').hide()

describe 'Render', ->

  it 'will handle correctly all partials', ->
    other = app.context.partial 'partial', name: 'John Doe'
    expect(other).toEqual 'John Doe'
    expect(app.context.partial).toThrow()

  it 'will handle the title also', ->
    app.context.title 'Some'
    app.context.title 'Testing'
    expect(document.title).toEqual 'Testing'

  it 'will bind our helpers', ->
    app.context.helpers.up = (bar) -> bar.toUpperCase()
    expect(app.context.partial('help', test: 'candy')).toEqual '<span>CANDY</span>'
