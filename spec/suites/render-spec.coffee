app = new App element, '/'
app.load(App.modules()).run()

describe 'Render', ->

  it 'will handle correctly all partials', ->
    other = app.context.partial 'other', name: 'John Doe'
    expect(other).toEqual 'John Doe'
    expect(app.context.partial).toThrow()

  it 'will handle the title also', ->
    app.context.title 'Some'
    app.context.title 'Testing'
    expect(document.title).toEqual 'Testing'

  it 'will bind our helpers', ->
    app.context.helpers.up = (bar) -> bar.toUpperCase()
    expect(app.context.partial('help', test: 'candy')).toEqual '<span>CANDY</span>'
