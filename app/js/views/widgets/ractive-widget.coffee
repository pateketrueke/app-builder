class App.ractiveWidget

  users = []
  current_user = 1

  constructor: (context) ->
    { @partial } = context

    @view = new Ractive
      el: '#sample-out'
      template: @partial 'ractive'
      sanitize: on

    @view.on
      set_user: (e) =>
        @set_user e.node.value

  set_user: (id) ->
    current_user = parseInt id, 10
    @view.set
      selected: current_user
      current_user: users[current_user]

  render: (params) ->
    users = params.list
    @view.set
      users: users
      selected: current_user
      current_user: users[current_user]
