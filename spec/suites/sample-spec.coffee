
describe 'Sample', ->

  it 'it should works...', ->
    expect($('#sample-out li').size()).toEqual 3

  it 'can I do some clicks?', ->
    $('#sample-out input').eq(0).trigger('click')
    expect(document.location.pathname).toEqual '/user/0'

    $('#sample-out input').eq(2).trigger('click')
    expect(document.location.pathname).toEqual '/user/2'

  it 'go home, you\'re drunk!!', ->
    app.context.go 'hello_world'
    expect(document.location.pathname).toEqual '/'
